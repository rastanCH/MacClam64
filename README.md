# 🛡️ MacClam64

**Open-source real-time antivirus for macOS on Apple Silicon (M1, M2, M3, M4), powered by [ClamAV](http://www.clamav.net/).**

This project compiles ClamAV natively for ARM64 architecture, configures real-time monitoring via `fswatch`, and installs system services (`launchd`) for automatic protection at startup. No Terminal window needs to stay open.

> **Origin Story:** This is a modern revival of the *Non-Graphical ClamAV Antivirus Solution for Mac OS X* originally written by [killdash9](https://github.com/killdash9/MacClam). As the original project (written in 2015 for Intel Macs) failed to compile on Apple Silicon, **MacClam64** was created as a free, open-source, and native alternative to ClamXAV.

### How it works
MacClam64 sets up real-time directory monitoring using:
- **[ClamAV](http://www.clamav.net/)**: The antivirus engine.
- **[fswatch](https://github.com/emcrisostomo/fswatch)**: Actively monitors directories for new or modified files.

When a file changes, it is immediately sent to `clamd` for scanning. Periodic full scans can be scheduled, and individual files can be scanned via the command line.

### Features
- **100% Native ARM64**: Compiled from source specifically for Apple Silicon chips.
- **Real-Time Monitoring**: Automatically watches `~/` (Home) and `/Applications` folders.
- **Automatic Quarantine**: Threats are instantly moved to a safe folder (`~/MacClam64/quarantine`).
- **Silent Operation**: Runs in the background via `launchd`. No persistent Terminal window required.
- **Privacy First**: No cloud uploads, everything stays local. Open-source.

## Installation

Open your Terminal and run the following command:

```bash
curl -fsSL https://raw.githubusercontent.com/rastanCH/MacClam64/main/MacClam64.sh | bash
```
Note: You may need to enter your administrator password to install Homebrew dependencies.
### Note for macOS Users:
If the automatic Homebrew installation fails with a "sudo access" error, please install Homebrew manually first by running:
```bash
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
```
Then re-run the MacClam64 installation command.

## Critical Step: Full Disk Access

Upon first run, macOS may block the scanner and show pop-ups asking for permission to access folders. To fix this permanently and stop the pop-ups:

1. Go to System Settings > Privacy & Security > Full Disk Access.
2. Click the « + » button and add the following binaries:
	- ~/MacClam64/opt/bin/clamdscan
	- /opt/homebrew/bin/fswatch (or the path to your fswatch binary; to see ```/opt/``` folder, go to "Macintosh HD" disk, then Maj+Cmd+.)
3. Toggle the switch to ON for both.
4. Restart the services (or reboot your Mac):
```bash
launchctl unload ~/Library/LaunchAgents/com.macclam64.*.plist
launchctl load ~/Library/LaunchAgents/com.macclam64.*.plist
```
Once done, no more pop-ups will appear.

## Verification
The installer does not run the test automatically because **Full Disk Access** permissions are required first.
Once you have granted permissions, run this command in Terminal:
```bash
echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' > ~/Downloads/eicar_test.com
```
- If ```eicar_test_macclam64.com``` disappears from your ```Downloads``` folder, it works!
- Check ```~/MacClam64/quarantine/``` to see the captured file.
- IF the file remains, check the logs in ```~/MacClam64/log/```or verify Full Disk Access settings.

## Useful Commands
### Manually update virus definitions:
```
~/MacClam64/opt/bin/freshclam --config-file=~/MacClam64/opt/etc/freshclam.conf
```
### Manually scan a folder:
```
~/MacClam64/opt/bin/clamdscan --config-file=~/MacClam64/opt/etc/clamd.conf /path/to/folder
```
### Uninstall:
```
launchctl unload ~/Library/LaunchAgents/com.macclam64.clamd.plist
launchctl unload ~/Library/LaunchAgents/com.macclam64.fswatch.plist
rm -rf ~/MacClam64 ~/Library/LaunchAgents/com.macclam64.*
```

## Project Structure
- ```~/MacClam64/opt/```: Compiled binaries and libraries.
- ```~/MacClam64/quarantine/```: Isolated suspicious files.
- ```~/MacClam64/log/```: Activity logs.
- ```~/Library/LaunchAgents/com.macclam64.*.plist```: System startup services.

## License
This project is distributed under the MIT License. See LICENSE.txt.

## Disclaimer
ClamAV is primarily effective against Windows malware and cross-platform threats. While it detects some macOS-specific malware, it should be used alongside Apple's native protections (XProtect, Gatekeeper) and good digital hygiene.
