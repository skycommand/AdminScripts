# Administrative scripts
Scripts for carrying out administrative tasks, mostly in Windows

## Download

1. `Download-Channl9VideosFromRSS.ps1` helps download entire Channel 9 sets of videos. It accepts one RSS URL for the video set and one download location.

## Firewall

1. `Report status.cmd` reports whether Windows Firewall is on or off. It requires Windows 10.

## Shell

1. `PowerShell bug fix for 'Run with PowerShell' verb.reg` correctly registers Windows PowerShell with File Explorer. It is especially useful for those who have installed Visual Studio Code or have corrupted their .ps1 registration.

## Shutdown

The names of these scripts are self-explanatory.

1. Log off.vbs
2. Power off (Alternative).vbs
3. Power off.vbs
4. Restart (Alternative).vbs
5. Restart.vbs

## Unicode test suite

See [its documentation](Unicode%20test%20suite/README.md)

## Wallpaper

The following two scripts are co-developed with Ramesh Srinivasan (the author of [WinHelpOnline.com](https://www.winhelponline.com)). More specifically, he wrote them in VBScript first, and I re-wrote them in PowerShell to support Unicode. Then, he credited me in his blog post and we added additional bits to support Windows 10. Back then, I knew zero about PowerShell and its philosophy, so, these scripts are unlike any other PowerShell scripts. In fact, they generate graphical message boxes.

1. Find current wallpaper (Windows 7).ps1
2. Find current wallpaper (Windows 8,10).ps1
