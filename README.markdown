# Administrative scripts

Scripts for carrying out administrative tasks, mostly in Windows

## AppX

Deals with Microsoft Store app packages.

1. `Inventory AppX Packages.ps1`: The `Get-AppxPackage` cmdlet in PowerShell can find all installed Microsoft Store apps, but it does not do a good job of discovering their display names. At best, it can show the technical package name. This script lists all AppX packages installed for the current user account, along with their display names. It accepts a `-Verbose` switch and its output can be piped to `Format-Table` or `Format-List`. I believe it can be expanded to work machine-wide.
2. `Reinstall-AppxPackages.ps1`: This script belongs to long-gone days. Nowadays, it is probably just dangerous. It resets and re-registers all AppX packages that were either shipped with Windows or were published by Microsoft. It is a safer alternative to the utterly sadistic one-liner that retrieves a list of all AppX packages and reset them all.
3. `Repair system apps.ps1`: This script also belongs to long-gone days. Nowadays, it is probably just dangerous. It re-registers all AppX packages installed in the "SystemApp" folder.
4. `(Specialized) Remove these AppX packages.ps1`: This one is mostly for me, but others can find educational value in it. This script uninstalls a number of Microsoft Store apps for all users, without deleting their provisioned packages. I believe it can only run on Windows 10 version 1809 or later.

## BITS

1. `Active BITS jobs - Detailed.ps1`: Asks the BITS service to give a list of all of its download and upload operations whose status is "Transferring". The result would be in the list form.
2. `Active BITS jobs - Table.ps1`: Asks the BITS service to give a list of all of its download and upload operations whose status is "Transferring". The result would be in the table form. I recommend maximizing your PowerShell window for this.
3. `All BITS jobs - Custom.ps1`: Asks the BITS service to give a list of all of its operation, then summarizes them, so that only the job state (color-coded), job ID, display name, type, priority, bytes transferred, and bytes total are shown, along with a list of all files in each job.
4. `Pending BITS jobs - Detailed.ps1`: Asks the BITS service to give a list of all of its download and upload operations whose status is anything but "Transferred". The result would be in the list form.
5. `Pending BITS jobs - Table.ps1`: Asks the BITS service to give a list of all of its download and upload operations whose status is anything but "Transferred". The result would be in the table form. I recommend maximizing your PowerShell window for this.

## Download

1. `Download-Channel9VideosFromRSS.ps1` helps download entire Channel 9 sets of videos. It accepts one RSS URL for the video set and one download location.

## Firewall

1. `Report status.cmd` reports whether Windows Firewall is on or off. It requires Windows 10.

## Icon cache

There was a period of time when Windows was plagued with bugs that corrupted the icon cache. These scripts were conceived in that time, as ways of mitigating the problem. I have long stopped using them though.

`Refresh icon cache with MoveFile.cmd` is the most effective of those but it is hard-coded to use an installed copy of `MoveFile.exe` from the Microsoft Sysinternals utility set.

## Last logon time

1. `LastLogon.ps1` returns a list of all local user accounts, as well as the date and time of their last logon.
2. `LastLogon (Deprecated).vbs` takes a long time to run, but returns a list of all local user accounts, as well as the date and time of their last logon. A matter of licensing: I did not write this script. The user who posted it was called `Corvus1` and posted it in educational spirit. It's very old and outdated anyway; it's best not to use it.

## Maintenance

1. `Repair-AllVolumes.ps1`: Enumerates all fixed-disk volumes and sequentially runs `Repair-Volume` on them to scan them for errors.
2. `Repair-Windows.ps1`: Repairs the online Windows instance by running DISM and SFC. Their logs are moved to the desktop.
3. `nGen Update.bat`: Runs nGen inside Windows PowerShell. While PowerShell 6 and 7 run on .NET Core, Windows PowerShell and some Windows-exclusive PowerShell modules (which PowerShell 7 also loads) run on .NET Framework. Run this script with admin privileges whenever you update .NET Framework, or whenever you feel Windows PowerShell or PowerShell 7 for Windows are sluggish at launch time.

## Security

### MpDefinitionPackage

This entire folder, `MpDefinitionPackage`, is a PowerShell module that adds a cmdlet to your PowerShell: `Build-MpDefinitionPackage`. This cmdlet extracts Microsoft malware definition files from one computer and packages them up into a self-extracting archive, so that it can be installed on other computers. It requires WinRAR to work.

I conceived it as a script at a time when our site was suffering a network outage. Not only we couldn't update our antimalware, users were using USB flash drives (notorious for being malware carriers) to transfer files. Desperate times need desperate measures. I wrote this solution to keep our devices secure. Eventually, I turned it into a module.

**Warning:** I do not guarantee that this solution works. If you wish to update an entire network while preserving Internet bandwidth, the official solutions are _Windows Server Update Services_ and _System Center_.

**Warning:** Residents of the United States of America must use this module in compliance with the Title 17 of United States Code, section 117 ("Limitations on exclusive rights: Computer programs"), article C. In other words, use this script only to keep your Microsoft antimalware product up-to-date and only when you have no other options.

## Shell

1. `PowerShell bug fix for 'Run with PowerShell' verb.reg` correctly registers Windows PowerShell with File Explorer. It is also useful for those who have corrupted or otherwise undesirably altered their `.ps1` registration.

## Shutdown

The names of these scripts are self-explanatory.

1. Log off.vbs
1. Power off.vbs
1. Power off (Alternative).vbs
1. Restart.vbs
1. Restart (Alternative).vbs

### Further reading: modern ways

1. [Stop-Computer](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/stop-computer?view=powershell-5.1)
2. [Restart-Computer](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/restart-computer?view=powershell-5.1)

### Further reading: Old ways

1. "[The Desktop FilesPsTools Primer](https://docs.microsoft.com/en-us/previous-versions/technet-magazine/cc162490(v=msdn.10))", an article in the old _TechNet Magazine_, March 2007
2. [Win32_OperatingSystem class](https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-operatingsystem) of CIMWin32
    - [Reboot method](https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/reboot-method-in-class-win32-operatingsystem)
    - [Shutdown method](https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/shutdown-method-in-class-win32-operatingsystem)
    - [Win32Shutdown method](https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32shutdown-method-in-class-win32-operatingsystem)
    - [Win32ShutdownTracker method](https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32shutdowntracker-method-in-class-win32-operatingsystem)
3. [Shutting Down Computers and Logging Off Users](https://docs.microsoft.com/en-us/previous-versions/tn-archive/ee156553(v=technet.10))
    - [Shutting Down a Computer](https://docs.microsoft.com/en-us/previous-versions/tn-archive/ee156545(v=technet.10))
    - [Restarting a Computer](https://docs.microsoft.com/en-us/previous-versions/tn-archive/ee156548(v=technet.10))

## Time

1. `Firmware time is UTC.reg`: Configures Windows to interpret the real-time clock as UTC time. Ordinarily, Windows interprets it as the local time corresponding to the time zone you've selected. Most Linux distros that interpret it as UTC, so you may need this script if you multi-boot a Linux distro along Windows. After applying this, restart the computer.

## Unicode test suite

A group of PNG images with multilingual file names. This set is intended to represent a practical real-world use of Unicode.

See [its documentation](Unicode%20test%20suite/README.md).

## Update management

1. `Check automatic update services.ps1`: Gives you a list of all update channels registered with the local instance of the Windows Update service. You are probably aware of the "Windows Update" and "Microsoft Update" channels. (The former contains updates for Windows only, the latter for all Microsoft products.) But not everyone knows about WSUS. This script is specifically useful to find out if the local computer is properly registered with WSUS.
2. `Install with DISM module.ps1`: Scans the current folder for Windows updates that you've manually downloaded from Microsoft Catalog or WSUS, then invokes `Add-WindowsPackage` to install them all. There was a time when Microsoft released 1.5 GB worth of update each month. I used to download them once and use this script to install them on several computers at home, thus saving 4.5 GB of download. (At work we use WSUS to save bandwidth.) Before you ask, no, the Delivery Optimization service does not reduce bandwidth consumption for you; it reduces bandwidth consumption for Microsoft's servers. Delivery Optimization depends on a centralized peer coordination server on the Internet.
3. `Install with DISM.exe.ps1`: Scans the current folder for Windows updates that you've manually downloaded from Microsoft Catalog or WSUS, then invokes `dism.exe` to install them all.
4. `Opt in to Microsoft Update.ps1` and `Opt out of Microsoft Update.ps1` are used to enable or disable the "Microsoft Update" channel on the local computer. These scripts are much faster than the cumbersome  official GUI way, which I've long forgotten. When the "Microsoft Update" channel is not enabled, Windows uses the "Windows Update" channel instead.
5. `Run all MSPs.ps1`: Scans the current folder and all its subfolders for `.msp` files and invokes Windows Installer to install them all. Many apps use MSPs to delivery updates. Microsoft Office 2016 and earlier are such apps.

## Wallpaper

The following two scripts are co-developed with Ramesh Srinivasan (the author of [WinHelpOnline.com](https://www.winhelponline.com)). More specifically, he wrote them in VBScript first, and I re-wrote them in PowerShell to support Unicode. Then, he credited me in his blog post and we added additional bits to support Windows 10. Back then, I knew zero about PowerShell and its philosophy, so, these scripts are unlike any other PowerShell scripts. In fact, they generate graphical message boxes.

1. Find current wallpaper (Windows 7).ps1
2. Find current wallpaper (Windows 8,10).ps1

## (Code snippets)

This special folder contains source code that one should not run directly. Rather, PowerShell developers could read them, learn from them, or include portions of them in their PowerShell scripts.

1. `Function library.psm1`: Contains a number of reusable functions. I've chosen the `.psm1` filename extension to prevent it from being accidentally run as a script. Each function has its own local help.
2. `Demo - Message boxes in PowerShell.ps1`: This scripts demonstrates how to invoke message boxes within a PowerShell script. Normally, one must not use message boxes (or `Write-Host`) inside PowerShell scripts. Before Windows 10, however, console apps had serious problems displaying Unicode characters, so I used message boxes instead.
