# 🛡️ MacClam64

**Open-source real-time antivirus for macOS on Apple Silicon (M1, M2, M3, M4), powered by [ClamAV](http://www.clamav.net/).**

This project compiles ClamAV natively for ARM64 architecture, configures real-time monitoring via `fswatch`, and installs system services (`launchd`) for automatic protection at startup. No Terminal window needs to stay open.

> **Origin Story:** This is a modern revival of the *Non-Graphical ClamAV Antivirus Solution for Mac OS X* originally written by [killdash9](https://github.com/killdash9/MacClam). As the original project (written in 2015 for Intel Macs) failed to compile on Apple Silicon, **MacClam64** was created as a free, open-source, and native alternative to ClamXAV.

## ✨ How it works

MacClam64 sets up real-time directory monitoring using:
- **[ClamAV](http://www.clamav.net/)**: The antivirus engine.
- **[fswatch](https://github.com/emcrisostomo/fswatch)**: Actively monitors directories for new or modified files.

When a file changes, it is immediately sent to `clamd` for scanning. Periodic full scans can be scheduled, and individual files can be scanned via the command line.

## 🚀 Features

- **100% Native ARM64**: Compiled from source specifically for Apple Silicon chips.
- **Real-Time Monitoring**: Automatically watches `~/` (Home) and `/Applications` folders.
- **Automatic Quarantine**: Threats are instantly moved to a safe folder (`~/MacClam64/quarantine`).
- **Silent Operation**: Runs in the background via `launchd`. No persistent Terminal window required.
- **Privacy First**: No cloud uploads, everything stays local. Open-source.

## 📥 Installation

Open your Terminal and run the following command:

```bash
curl -fsSL https://raw.githubusercontent.com/rastanCH/MacClam64/main/MacClam64.sh | bash
Note: You may need to enter your administrator password to install Homebrew dependencies.

⚠️ Critical Step: Full Disk Access

Upon first run, macOS may block the scanner and show pop-ups asking for permission to access folders. To fix this permanently and stop the pop-ups:

Go to System Settings > Privacy & Security > Full Disk Access.
Click the « + » button and add the following binaries:
~/MacClam64/opt/bin/clamdscan
/opt/homebrew/bin/fswatch (or the path to your fswatch binary)
Toggle the switch to ON for both.
Restart the services (or reboot your Mac):
bash
Copier
launchctl unload ~/Library/LaunchAgents/com.macclam64.*.plist
launchctl load ~/Library/LaunchAgents/com.macclam64.*.plist
Once done, no more pop-ups will appear.

🧪 Verification

The installer automatically runs a test using the harmless EICAR test file.

If eicar_test_macclam64.com disappears from your Downloads folder, it works!
Check ~/MacClam64/quarantine/ to see the captured file.
🔧 Useful Commands

Manually update virus definitions:
bash
Copier
~/MacClam64/opt/bin/freshclam --config-file=~/MacClam64/opt/etc/freshclam.conf
Manually scan a folder:
bash
Copier
~/MacClam64/opt/bin/clamdscan --config-file=~/MacClam64/opt/etc/clamd.conf /path/to/folder
Uninstall:
bash
Copier
launchctl unload ~/Library/LaunchAgents/com.macclam64.clamd.plist
launchctl unload ~/Library/LaunchAgents/com.macclam64.fswatch.plist
rm -rf ~/MacClam64 ~/Library/LaunchAgents/com.macclam64.*
📁 Project Structure

~/MacClam64/opt/: Compiled binaries and libraries.
~/MacClam64/quarantine/: Isolated suspicious files.
~/MacClam64/log/: Activity logs.
~/Library/LaunchAgents/com.macclam64.*.plist: System startup services.
📄 License

This project is distributed under the MIT License. See LICENSE.txt.

⚠️ Disclaimer

ClamAV is primarily effective against Windows malware and cross-platform threats. While it detects some macOS-specific malware, it should be used alongside Apple's native protections (XProtect, Gatekeeper) and good digital hygiene.{\rtf1\ansi\ansicpg1252\cocoartf2870
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 HelveticaNeue-Bold;\f1\fnil\fcharset0 HelveticaNeue;\f2\fnil\fcharset0 HelveticaNeue-Medium;
\f3\fnil\fcharset0 .AppleSystemUIFontMonospaced-Regular;}
{\colortbl;\red255\green255\blue255;\red23\green41\blue65;\red255\green255\blue255;\red13\green80\blue209;
\red24\green26\blue30;\red87\green96\blue106;\red240\green245\blue250;\red164\green191\blue221;\red27\green31\blue34;
\red218\green76\blue12;}
{\*\expandedcolortbl;;\cssrgb\c11373\c21569\c32549;\cssrgb\c100000\c100000\c100000;\cssrgb\c3529\c41176\c85490;
\cssrgb\c12157\c13725\c15686;\cssrgb\c41569\c45098\c49020;\cssrgb\c95294\c96863\c98431;\cssrgb\c70196\c79608\c89412\c30196;\cssrgb\c14118\c16078\c18039;
\cssrgb\c89020\c38431\c3529;}
{\*\listtable{\list\listtemplateid1\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid1\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid1}
{\list\listtemplateid2\listhybrid{\listlevel\levelnfc0\levelnfcn0\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{decimal\}.}{\leveltext\leveltemplateid101\'02\'00.;}{\levelnumbers\'01;}\fi-360\li720\lin720 }{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid102\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li1440\lin1440 }{\listname ;}\listid2}
{\list\listtemplateid3\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid201\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid3}
{\list\listtemplateid4\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid301\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid4}
{\list\listtemplateid5\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid401\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid5}}
{\*\listoverridetable{\listoverride\listid1\listoverridecount0\ls1}{\listoverride\listid2\listoverridecount0\ls2}{\listoverride\listid3\listoverridecount0\ls3}{\listoverride\listid4\listoverridecount0\ls4}{\listoverride\listid5\listoverridecount0\ls5}}
\paperw11900\paperh16840\margl1440\margr1440\vieww19300\viewh14740\viewkind0
\deftab720
\pard\pardeftab720\sa240\partightenfactor0

\f0\b\fs48 \cf2 \cb3 \expnd0\expndtw0\kerning0
MacClam64\
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs28 \cf0 \cb1 Open-source real-time antivirus for macOS on Apple Silicon (M1, M2, M3, etc.), powered by {\field{\*\fldinst{HYPERLINK "http://www.clamav.net/"}}{\fldrslt \cf4 \kerning1\expnd0\expndtw0 \ul \ulc4 ClamAV}}. This project compiles ClamAV natively for ARM64 architecture, configures real-time monitoring via `fswatch`, and installs system services (`launchd`) for automatic protection at startup. No Terminal window needs to stay open.\cf2 \cb3 \
This is an updated version of the Non-Graphical ClamAV Antivirus Solution for Mac OS X written by killdash9, as it is available here: {\field{\*\fldinst{HYPERLINK "https://github.com/killdash9/MacClam"}}{\fldrslt \cf2 https://github.com/killdash9/MacClam}}. As I tried to install it, I realised it was written in 2015 for Mac Intel chip, and it blocked when trying to install on Mac ARM64 (Apple Silicon). So I decided to write a new free alternative to ClamXAV ({\field{\*\fldinst{HYPERLINK "https://www.clamxav.com/"}}{\fldrslt \cf2 https://www.clamxav.com}}).\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardeftab720\pardirnatural\partightenfactor0
\cf5 \cb1 \kerning1\expnd0\expndtw0 MacClam64 sets up real-time directory monitoring and schedules regular scans. It uses {\field{\*\fldinst{HYPERLINK "http://www.clamav.net/"}}{\fldrslt \cf4 \ul \ulc4 ClamAV}} as its antivirus engine and {\field{\*\fldinst{HYPERLINK "https://github.com/emcrisostomo/fswatch"}}{\fldrslt \cf4 \ul \ulc4 fswatch}} to actively monitor directories for new or modified files. These are then sent to clamd for scanning. Periodic full scans are scheduled using cron.  Additionally, it offers a command-line option to scan individual files or directories as needed.\
\pard\tx220\tx720\pardeftab720\li720\fi-720\sb240\sa80\partightenfactor0

\f2\fs32 \cf2 \cb3 \expnd0\expndtw0\kerning0
Features\
\pard\tx220\tx720\pardeftab720\li720\fi-720\pardirnatural\partightenfactor0
\ls1\ilvl0
\f1\fs28 \cf5 \cb1 \kerning1\expnd0\expndtw0 {\listtext	\uc0\u8226 	}
\f0\b 100% Native ARM64
\f1\b0 : Compiled from source specifically for Apple Silicon chips.\
{\listtext	\uc0\u8226 	}
\f0\b Real-Time Monitoring
\f1\b0 : Automatically watches \cf0 \expnd0\expndtw0\kerning0
`~/` and `/Applications` folders.\
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls1\ilvl0\cf0 \kerning1\expnd0\expndtw0 {\listtext	\uc0\u8226 	}
\f0\b \expnd0\expndtw0\kerning0
Automatic Quarantine
\f1\b0 : Threats are instantly moved to a safe folder.\
\ls1\ilvl0\kerning1\expnd0\expndtw0 {\listtext	\uc0\u8226 	}
\f0\b \expnd0\expndtw0\kerning0
Silent Operation
\f1\b0 : Runs in the background via `launchd`.\
\ls1\ilvl0\kerning1\expnd0\expndtw0 {\listtext	\uc0\u8226 	}
\f0\b \expnd0\expndtw0\kerning0
Privacy First:
\f1\b0  No cloud uploads, everything stays local. Open-source.\
\pard\pardeftab720\sb240\sa240\partightenfactor0

\f0\b\fs40 \cf2 \cb3 Quick Installation\cb1 \
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs28 \cf2 \cb3 Open your Terminal and run:\
\pard\pardeftab720\partightenfactor0

\f3 \cf6 \cb7 ```bash\
\pard\pardeftab720\sa240\partightenfactor0
\cf6 \cb7 curl -fsSL https://raw.githubusercontent.com/rastanCH/MacClam64/main/MacClam64.sh | bash\
\pard\pardeftab720\sa240\partightenfactor0

\f1\fs32 \cf2 \cb3 Note: You may need to enter your administrator password to install Homebrew dependencies.
\f0\b\fs40 \
\pard\pardeftab720\sb240\sa240\partightenfactor0
\cf2 Critical Step: Full Disk Access\cb1 \
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs28 \cf2 \cb3 Upon first run, macOS may block the scanner and show pop-ups asking for permission to access folders. To fix this permanently:\cf2 \cb1 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa80\partightenfactor0
\ls2\ilvl0\cf2 \cb3 \kerning1\expnd0\expndtw0 {\listtext	1.	}\expnd0\expndtw0\kerning0
Go to System Settings > Privacy & Security > Full Disk Access.\cb1 \
\ls2\ilvl0\cb3 \kerning1\expnd0\expndtw0 {\listtext	2.	}\expnd0\expndtw0\kerning0
Click the \'ab + \'bb button and add the following binaries:\cb1 \
\pard\tx940\tx1440\pardeftab720\li1440\fi-1440\sa80\partightenfactor0
\ls2\ilvl1
\f3 \cf2 \cb8 \kerning1\expnd0\expndtw0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
~/MacClam64/opt/bin/clamdscan
\f1 \cb1 \
\pard\tx940\tx1440\tx2160\pardeftab720\li1440\fi-1440\sa80\partightenfactor0
\ls2\ilvl1
\f3 \cf2 \cb8 \kerning1\expnd0\expndtw0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
/opt/homebrew/bin/fswatch
\f1 \cb3  (or the path to your fswatch binary)\cb1 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa80\partightenfactor0
\ls2\ilvl0\cf2 \cb3 \kerning1\expnd0\expndtw0 {\listtext	3.	}\expnd0\expndtw0\kerning0
Toggle the switch to ON for both.\cb1 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls2\ilvl0\cf2 \cb3 \kerning1\expnd0\expndtw0 {\listtext	4.	}\expnd0\expndtw0\kerning0
Restart the services (or reboot your Mac):\cb1 \
\pard\tx940\tx1440\pardeftab720\li1440\fi-1440\partightenfactor0
\ls2\ilvl1
\f3 \cf9 \cb7 \kerning1\expnd0\expndtw0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
launchctl unload ~/Library/LaunchAgents/com.macclam64.*.plist\
\pard\tx940\tx1440\tx2160\pardeftab720\li1440\fi-1440\partightenfactor0
\ls2\ilvl1\cf9 \kerning1\expnd0\expndtw0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
launchctl load ~/Library/LaunchAgents/com.macclam64.*.plist\cf2 \cb1 \uc0\u8232 
\f1 \
\pard\pardeftab720\sa240\partightenfactor0
\cf2 \cb3 Once done, no more pop-ups will appear.
\fs32 \cf2 \cb1 \
\pard\pardeftab720\sb240\sa240\partightenfactor0

\f0\b\fs40 \cf2 \cb3 Verification\cb1 \
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs28 \cf2 \cb3 The installer automatically runs a test using the harmless EICAR test file.\cf2 \cb1 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa80\partightenfactor0
\ls3\ilvl0\cf2 \cb3 \kerning1\expnd0\expndtw0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
If 
\f3 \cb8 eicar_test_macclam64.com
\f1 \cb3  disappears from your 
\f3 \cb8 Downloads
\f1 \cb3  folder, it works!\cb1 \
\ls3\ilvl0\cb3 \kerning1\expnd0\expndtw0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
Check 
\f3 \cb8 ~/MacClam64/quarantine/
\f1 \cb3  to see the captured file.
\fs40 \
\pard\pardeftab720\sb240\sa240\partightenfactor0

\f0\b \cf2 Useful Commands\cb1 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa80\partightenfactor0
\ls4\ilvl0
\f2\b0\fs32 \cf2 \cb3 {\listtext	\uc0\u8226 	}Manually update virus definitions:
\f1 \cb1 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa80\partightenfactor0
\ls4\ilvl0
\f3\fs28 \cf9 \cb7 {\listtext	\uc0\u8226 	}~/MacClam64/opt/bin/freshclam --config-file=~/MacClam64/opt/etc/freshclam.conf\cf2 \cb1 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sb240\sa80\partightenfactor0
\ls4\ilvl0
\f2\fs32 \cf2 \cb3 {\listtext	\uc0\u8226 	}Manually scan a folder:
\f1 \cb1 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa80\partightenfactor0
\ls4\ilvl0
\f3\fs28 \cf9 \cb7 {\listtext	\uc0\u8226 	}~/MacClam64/opt/bin/clamdscan --config-file=~/MacClam64/opt/etc/clamd.conf /path/to/folder\
\pard\tx220\tx720\pardeftab720\li720\fi-720\sb240\sa80\partightenfactor0
\ls4\ilvl0
\f2\fs32 \cf2 \cb3 {\listtext	\uc0\u8226 	}Uninstall:
\f1 \cb1 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa80\partightenfactor0
\ls4\ilvl0
\f3\fs28 \cf9 \cb7 {\listtext	\uc0\u8226 	}launchctl unload ~/Library/LaunchAgents/com.macclam64.clamd.plist\
{\listtext	\uc0\u8226 	}launchctl unload ~/Library/LaunchAgents/com.macclam64.fswatch.plist\
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa80\partightenfactor0
\ls4\ilvl0\cf10 {\listtext	\uc0\u8226 	}rm\cf9  -rf ~/MacClam64 ~/Library/LaunchAgents/com.macclam64.*
\f1\fs32 \cf2 \cb1 \
\pard\pardeftab720\sb240\sa240\partightenfactor0

\f0\b\fs40 \cf2 \cb3 Project Structure\
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa80\partightenfactor0
\ls5\ilvl0
\f1\b0\fs28 \cf2 \kerning1\expnd0\expndtw0 {\listtext	\uc0\u8226 	}
\f3 \cb8 \expnd0\expndtw0\kerning0
~/MacClam64/opt/
\f1 \cb3 : Compiled binaries and libraries.\
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa80\partightenfactor0
\ls5\ilvl0\cf2 \cb1 \kerning1\expnd0\expndtw0 {\listtext	\uc0\u8226 	}
\f3 \cb8 \expnd0\expndtw0\kerning0
~/MacClam64/quarantine/
\f1 \cb3 : Isolated suspicious files.\
\ls5\ilvl0\cb1 \kerning1\expnd0\expndtw0 {\listtext	\uc0\u8226 	}
\f3 \cb8 \expnd0\expndtw0\kerning0
~/MacClam64/log/
\f1 \cb3 : Activity logs.\
\ls5\ilvl0\cb1 \kerning1\expnd0\expndtw0 {\listtext	\uc0\u8226 	}
\f3 \cb8 \expnd0\expndtw0\kerning0
~/Library/LaunchAgents/com.macclam64.*.plist
\f1 \cb3 : System startup services.
\fs32 \cb1 \
\pard\pardeftab720\sb240\sa240\partightenfactor0

\f0\b\fs40 \cf2 \cb3 License\cb1 \
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs28 \cf2 \cb3 This project is distributed under the MIT License. See 
\f3 \cf2 \cb8 LICENSE.txt
\f1 \cf2 \cb3 .\cf2 \cb1 \
\pard\pardeftab720\sb240\sa240\partightenfactor0

\f0\b\fs40 \cf2 \cb3 Disclaimer\cb1 \
\pard\pardeftab720\sa240\partightenfactor0

\f1\b0\fs28 \cf2 \cb3 ClamAV is primarily effective against Windows malware and cross-platform threats. While it detects some macOS-specific malware, it should be used alongside Apple's native protections (XProtect, Gatekeeper) and good digital hygiene.}
