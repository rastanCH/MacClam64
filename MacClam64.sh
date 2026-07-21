#!/bin/bash

# ==============================================================================
# MacClam64 Installer
# Installs ClamAV, fswatch, and configures real-time monitoring for macOS Apple Silicon.
# License: MIT
# ==============================================================================

set -e # Stop on critical error

echo "🛡️  Installing MacClam64 for Apple Silicon (ARM64)..."
echo "---------------------------------------------------------"

# 1. Prerequisites Check & Auto-Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "🍺 Homebrew is not installed."
    echo "🚀 Starting automatic installation..."
    echo "   (Press Ctrl+C within the next few seconds to cancel and install manually)"
    sleep 4 # Short delay to allow time to read and cancel if necessary
    
    # Launch of the official Homebrew installer
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # CRITICAL CHECK: On Apple Silicon, Homebrew installs to /opt/homebrew.
    # We must add it to the PATH for the current session immediately.
    if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    # Final verification
    if ! command -v brew &> /dev/null; then
        echo "❌ ERROR: Homebrew installation failed or PATH not updated."
        echo "   Please install Homebrew manually from https://brew.sh and re-run this script."
        exit 1
    fi
    echo "✅ Homebrew installed and configured successfully."
else
    echo "✅ Homebrew is already installed."
fi

# 2. Install System Dependencies via Homebrew
echo "📦 Installing dependencies (fswatch, cmake, check, json-c)..."
brew install fswatch cmake check json-c || { echo "Error installing dependencies"; exit 1; }

# 3. Setup Directories
INSTALL_DIR="$HOME/MacClam64"
SRC_DIR="$INSTALL_DIR/src"
BUILD_DIR="$SRC_DIR/build"
INSTALL_PREFIX="$INSTALL_DIR/opt"

mkdir -p "$SRC_DIR" "$BUILD_DIR" "$INSTALL_PREFIX" "$INSTALL_DIR/quarantine" "$INSTALL_DIR/log"

# 4. Compile OpenSSL (ARM64 Native)
OPENSSL_VER="3.3.2"
if [ ! -f "$INSTALL_PREFIX/lib/libcrypto.a" ]; then
    echo "🔐 Compiling OpenSSL $OPENSSL_VER for ARM64..."
    cd "$SRC_DIR"
    if [ ! -f "openssl-$OPENSSL_VER.tar.gz" ]; then
        curl -L -o "openssl-$OPENSSL_VER.tar.gz" "https://www.openssl.org/source/openssl-$OPENSSL_VER.tar.gz"
    fi
    tar -xzf "openssl-$OPENSSL_VER.tar.gz"
    cd "openssl-$OPENSSL_VER"
    
    ./Configure darwin64-arm64-cc no-shared --prefix="$INSTALL_PREFIX"
    make -j8
    make install
    cd "$SRC_DIR"
else
    echo "✅ OpenSSL already installed."
fi

# 5. Compile ClamAV
CLAMAV_VER="1.4.5"
if [ ! -f "$INSTALL_PREFIX/bin/clamd" ]; then
    echo "🦠 Compiling ClamAV $CLAMAV_VER..."
    cd "$SRC_DIR"
    if [ ! -f "clamav-$CLAMAV_VER.tar.gz" ]; then
        curl -L -o "clamav-$CLAMAV_VER.tar.gz" "https://www.clamav.net/downloads/production/clamav-$CLAMAV_VER.tar.gz"
    fi
    tar -xzf "clamav-$CLAMAV_VER.tar.gz"
    cd "clamav-$CLAMAV_VER"
    
    mkdir -p build && cd build
    
    cmake .. \
      -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
      -DOPENSSL_ROOT_DIR="$INSTALL_PREFIX" \
      -DCMAKE_BUILD_TYPE=Release \
      -DENABLE_UNIT_TESTS=OFF \
      -DENABLE_MILTER=OFF
    
    make -j8
    make install
    cd "$SRC_DIR"
else
    echo "✅ ClamAV already installed."
fi

# 6. Configure ClamAV
echo "⚙️  Configuring ClamAV..."
CONF_DIR="$INSTALL_PREFIX/etc"
DATA_DIR="$INSTALL_PREFIX/share/clamav"

if [ ! -f "$CONF_DIR/clamd.conf" ]; then
    cp "$CONF_DIR/clamd.conf.sample" "$CONF_DIR/clamd.conf"
    sed -i '' 's/^Example/#Example/' "$CONF_DIR/clamd.conf"
    echo "LogFile $INSTALL_DIR/log/clamd.log" >> "$CONF_DIR/clamd.conf"
    echo "LogTime yes" >> "$CONF_DIR/clamd.conf"
    echo "LocalSocket /tmp/clamd.socket" >> "$CONF_DIR/clamd.conf"
    echo "ExcludePath $INSTALL_DIR/quarantine" >> "$CONF_DIR/clamd.conf"
fi

if [ ! -f "$CONF_DIR/freshclam.conf" ]; then
    cp "$CONF_DIR/freshclam.conf.sample" "$CONF_DIR/freshclam.conf"
    sed -i '' 's/^Example/#Example/' "$CONF_DIR/freshclam.conf"
    echo "LogFile $INSTALL_DIR/log/freshclam.log" >> "$CONF_DIR/freshclam.conf"
    echo "LogTime yes" >> "$CONF_DIR/freshclam.conf"
    echo "DatabaseDirectory $DATA_DIR" >> "$CONF_DIR/freshclam.conf"
    echo "DatabaseMirror database.clamav.net" >> "$CONF_DIR/freshclam.conf"
fi

echo "📥 Updating virus definitions..."
"$INSTALL_PREFIX/bin/freshclam" --config-file="$CONF_DIR/freshclam.conf" || echo "⚠️  Update failed (check connection), but installation continues."

# 7. Create Monitoring Scripts
echo "👁️  Creating monitoring scripts..."
cat > "$INSTALL_DIR/scaniffile" <<'EOFSCRIPT'
#!/bin/bash
FILE="$1"
if [ -f "$FILE" ]; then
    INSTALL_PREFIX="$HOME/MacClam64/opt"
    "$INSTALL_PREFIX/bin/clamdscan" --config-file="$INSTALL_PREFIX/etc/clamd.conf" --move="$HOME/MacClam64/quarantine" --no-summary "$FILE" >/dev/null 2>&1
fi
EOFSCRIPT
chmod +x "$INSTALL_DIR/scaniffile"

cat > "$INSTALL_DIR/start_monitoring.sh" <<'EOFMONITOR'
#!/bin/bash
cd "$HOME"
"$HOME/MacClam64/opt/bin/fswatch" -E \
  -e "$HOME/MacClam64/quarantine" \
  -e "$HOME/MacClam64/log" \
  "$HOME" "/Applications" | while read line; do "$HOME/MacClam64/scaniffile" "$line"; done
EOFMONITOR
chmod +x "$INSTALL_DIR/start_monitoring.sh"

# 8. Install Launchd Services
echo "🚀 Installing automatic startup services..."
LAUNCH_DIR="$HOME/Library/LaunchAgents"

# ClamD Agent
cat > "$LAUNCH_DIR/com.macclam64.clamd.plist" <<EOFPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.macclam64.clamd</string>
    <key>ProgramArguments</key>
    <array>
        <string>$INSTALL_PREFIX/sbin/clamd</string>
        <string>--config-file=$CONF_DIR/clamd.conf</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$INSTALL_DIR/log/clamd-launchd.log</string>
    <key>StandardErrorPath</key>
    <string>$INSTALL_DIR/log/clamd-launchd.err</string>
</dict>
</plist>
EOFPLIST

# Fswatch Agent
cat > "$LAUNCH_DIR/com.macclam64.fswatch.plist" <<EOFPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.macclam64.fswatch</string>
    <key>ProgramArguments</key>
    <array>
        <string>$INSTALL_DIR/start_monitoring.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$INSTALL_DIR/log/fswatch-launchd.log</string>
    <key>StandardErrorPath</key>
    <string>$INSTALL_DIR/log/fswatch-launchd.err</string>
</dict>
</plist>
EOFPLIST

launchctl unload "$LAUNCH_DIR/com.macclam64.clamd.plist" 2>/dev/null || true
launchctl load "$LAUNCH_DIR/com.macclam64.clamd.plist"
launchctl unload "$LAUNCH_DIR/com.macclam64.fswatch.plist" 2>/dev/null || true
launchctl load "$LAUNCH_DIR/com.macclam64.fswatch.plist"

echo ""
echo "✅ Installation successful!"
echo "---------------------------------------------------------"
echo "🛡️  MacClam64 is now active in the background."
echo "📂  Suspicious files will be moved to: $INSTALL_DIR/quarantine"
echo ""
echo "⚠️  IMPORTANT: To prevent access pop-ups, please grant 'Full Disk Access':"
echo "   1. Go to System Settings > Privacy & Security > Full Disk Access"
echo "   2. Add: $INSTALL_PREFIX/bin/clamdscan"
echo "   3. Add: /opt/homebrew/bin/fswatch (or the fswatch binary path)"
echo "   4. Restart the services or your Mac."
echo ""
echo "🧪 Running quick test (EICAR)..."
echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' > ~/Downloads/eicar_test_macclam64.com
echo "Waiting 5 seconds..."
sleep 5
if [ ! -f ~/Downloads/eicar_test_macclam64.com ]; then
    echo "🎉 SUCCESS: Test file captured and quarantined!"
    ls -l "$INSTALL_DIR/quarantine/" | grep eicar
else
    echo "⚠️  Test file still present. Check logs in $INSTALL_DIR/log/ or grant Full Disk Access."
fi
