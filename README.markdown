# Administrative scripts

[![Open in Visual Studio Code](https://open.vscode.dev/badges/open-in-vscode.svg)](https://open.vscode.dev/organization/repository)

Welcome! 😊 This repository contains scripts that I use for carrying out various tasks in Windows, mostly (but not exclusively) administrative tasks.

## How to download an use

You can either download each script individually or clone this entire repository. Most scripts are standalone and have no dependencies. One major exception is the `MpDefinitionPackage` module. (It's a PowerShell script module, meaning that you need its entire folder.) Most scripts are PowerShell, so you need to open a PowerShell window to run them.

## Description of scripts

### AppX

Deals with Microsoft Store app packages.

- `Inventory AppX Packages.ps1`: The `Get-AppxPackage` cmdlet in PowerShell can find all installed Microsoft Store apps, but it does not do a good job of discovering their display names. At best, it can show the technical package name. This script lists all AppX packages installed for the current user account, along with their display names. It accepts a `-Verbose` switch and its output can be piped to `Format-Table` or `Format-List`. I believe it can be expanded to work machine-wide.
- `Remove notorious AppX packages.ps1`: This one is mostly for me, but others can find educational value in it. This script uninstalls a number of Microsoft Store apps for all users, without deleting their provisioned packages. I believe it can only run on Windows 10 version 1809 or later.

The following script belong to long-gone days. Nowadays, they are probably just dangerous, but not as dangerous as reckless things you find on the web.

- `Reinstall AppX Packages.ps1`:  Resets and re-registers all AppX packages that were either shipped with Windows or were published by Microsoft. It is a safer alternative to the utterly sadistic one-liners abound the web that retrieve a list of all AppX packages and reset them all.
- `Repair system apps.ps1`: Re-registers all AppX packages installed in the "SystemApp" folder.

### BITS

The following scripts ask the BITS service for a list of all of its download and upload operations with a certain status and format the results in a certain form. More specifically:

Script name                        | Desired job status         | Format
---------------------------------- | -------------------------- | ------
`Active BITS jobs - Detailed.ps1`  | "Transferring"             | List
`Active BITS jobs - Table.ps1`     | "Transferring"             | Table
`Pending BITS jobs - Detailed.ps1` | anything but "Transferred" | List
`Pending BITS jobs - Table.ps1`    | anything but "Transferred" | Table

`All BITS jobs - Custom.ps1` asks the BITS service for list of all of its operation, then summarizes them, so that only the job status, job ID, display name, type, priority, bytes transferred, and bytes total are shown, along with a list of all files in each job.

### Firewall

- `Get-WindowsFirewallStatus.cmd` reports whether Windows Firewall is on or off. It requires Windows 10.

### Icon cache

There was a period of time (2011–2016) when Windows was plagued with bugs that corrupted the icon cache. These scripts were conceived in that time, as ways of mitigating the problem. I have long stopped using them though.

`Refresh icon cache with MoveFile.cmd` is the most effective of those but it is hard-coded to use an installed copy of `MoveFile.exe` from the Microsoft Sysinternals utility set.

### Last logon time

- `LastLogon.ps1` returns a list of all local user accounts, as well as the date and time of their last logon.
- `LastLogon (Deprecated).vbs` takes a long time to run, but returns a list of all local user accounts, as well as the date and time of their last logon. A matter of licensing: I did not write this script. The user who posted it was called `Corvus1` and posted it in educational spirit. It's very old and outdated anyway; it's best not to use it.

### Maintenance

- `Repair-AllVolumes.ps1`: Enumerates all fixed-disk volumes and sequentially runs `Repair-Volume` on them to scan them for errors.
- `Repair-Windows.ps1`: Repairs the online Windows instance by running DISM and SFC. Their logs are moved to the desktop.
- `nGen Update.bat`: Runs nGen inside Windows PowerShell. While PowerShell 6 and 7 run on .NET Core, Windows PowerShell and some Windows-exclusive PowerShell modules (which PowerShell 7 also loads) run on .NET Framework. Run this script with admin privileges whenever you update .NET Framework, or whenever you feel Windows PowerShell or PowerShell 7 for Windows are sluggish at launch time.

### Security

#### MpDefinitionPackage module

This entire folder, `MpDefinitionPackage`, is a PowerShell module that adds a cmdlet to your PowerShell: `Build-MpDefinitionPackage`. This cmdlet extracts Microsoft malware definition files from one computer and packages them up into a self-extracting archive, so that it can be installed on other computers. It requires WinRAR to work.

I conceived it as a script at a time when our site was suffering a network outage. Not only we couldn't update our antimalware, users were using USB flash drives (notorious for being malware carriers) to transfer files. Desperate times need desperate measures. I wrote this solution to keep our devices secure. Eventually, I turned it into a module.

**Warning:** I do not guarantee that this solution works. If you wish to update an entire network while preserving Internet bandwidth, the official solutions are _Windows Server Update Services_ and _System Center_.

**Warning:** Residents of the United States of America must use this module in compliance with the Title 17 of United States Code, section 117 ("Limitations on exclusive rights: Computer programs"), article C. In other words, use this script only to keep your Microsoft antimalware product up-to-date and only when you have no other options.

#### Others

- `Clear-WindowsDefenderHistory.ps1`: Clears the "protection history" of Microsoft Defender Antivirus (commonly referred to as Windows Defender). Starting with Windows 10 version 1703, this products no longer allows the users to clear the protection history via its UI. This "history", however, is each user's personal property. It is the owner's discretion to keep or clear it.

### Shell

The following scripts fix the `.ps1` file association in Microsoft Windows.

- `Fix 'Run with PowerShell' verb (legacy).reg`
- `Fix 'Run with PowerShell' verb (PowerShell 7).reg`
- `Fix 'Run with PowerShell' verb (Windows 10).reg`
- `Fix 'Run with PowerShell' verb (Visual Studio Code - System).reg`

Since at least PowerShell 3.0, there has been a bug in the "Run with PowerShell" verb (formerly "Run with Windows PowerShell") of the `.ps1` files: If your PowerShell script has a mono quotation mark (`'`) in its name, the "Run with PowerShell" command fails. Let's inspect the command string to find out why:

```bash
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" "-Command" "if((Get-ExecutionPolicy ) -ne 'AllSigned') { Set-ExecutionPolicy -Scope Process Bypass }; & '%1'"
```

The offending part is the last seven letters: `& '%1'"`

In this string, `%1` gets replaced with the name of your `.ps1` file. If this file's name contains mono quotation marks, the parser gets mislead.

In legacy PowerShell versions, the solution is to use the `-File` switch instead of the `-Command`. In modern versions of PowerShell (7.x and 5.1 for Windows 10), however, I opted a more fancy approach:

```bash
"C:\Program Files\PowerShell\7\pwsh.exe" -Command "$host.UI.RawUI.WindowTitle = 'PowerShell 7 (x64)'; if ((Get-ExecutionPolicy ) -ne 'AllSigned') { Set-ExecutionPolicy -Scope Process Bypass }; & """%1"""; Pause"
```

I've replaced the offending mono quotation marks with three double quotation marks. This way, I can keep using the `-Command` switch. I've added a new "Pause" instruction that prevents the script window from disappearing.

### Shutdown

The names of these scripts are self-explanatory.

- Log off.vbs
- Power off.vbs
- Power off (Alternative).vbs
- Restart.vbs
- Restart (Alternative).vbs

#### Further reading: modern ways

- [Stop-Computer](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/stop-computer?view=powershell-5.1)
- [Restart-Computer](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/restart-computer?view=powershell-5.1)

#### Further reading: old ways

- "[The Desktop FilesPsTools Primer](https://docs.microsoft.com/en-us/previous-versions/technet-magazine/cc162490(v=msdn.10))", an article in the old _TechNet Magazine_, March 2007
- [Win32_OperatingSystem class](https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-operatingsystem) of CIMWin32
    - [Reboot method](https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/reboot-method-in-class-win32-operatingsystem)
    - [Shutdown method](https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/shutdown-method-in-class-win32-operatingsystem)
    - [Win32Shutdown method](https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32shutdown-method-in-class-win32-operatingsystem)
    - [Win32ShutdownTracker method](https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32shutdowntracker-method-in-class-win32-operatingsystem)
- [Shutting Down Computers and Logging Off Users](https://docs.microsoft.com/en-us/previous-versions/tn-archive/ee156553(v=technet.10))
    - [Shutting Down a Computer](https://docs.microsoft.com/en-us/previous-versions/tn-archive/ee156545(v=technet.10))
    - [Restarting a Computer](https://docs.microsoft.com/en-us/previous-versions/tn-archive/ee156548(v=technet.10))

### Time

- `Firmware time is UTC.reg`: Configures Windows to interpret the real-time clock as UTC time. Ordinarily, Windows interprets it as the local time corresponding to the time zone you've selected. Most Linux distros that interpret it as UTC, so you may need this script if you multi-boot a Linux distro along Windows. After applying this, restart the computer.

### Unicode test suite

A group of PNG images with multilingual file names. This set is intended to represent a practical real-world use of Unicode.

See [its documentation](Unicode%20test%20suite/README.md).

### Update management

- `Check automatic update services.ps1`: Gives you a list of all update channels registered with the local instance of the Windows Update service. You are probably aware of the "Windows Update" and "Microsoft Update" channels. (The former contains updates for Windows only, the latter for all Microsoft products.) But not everyone knows about WSUS. This script is specifically useful to find out if the local computer is properly registered with WSUS.
- `Install all with PowerShell.ps1`: Scans the current folder for Windows updates that you've manually downloaded from Microsoft Catalog or WSUS, then invokes `Add-WindowsPackage` to install them all. There was a time when Microsoft released 1.5 GB worth of updates each month. I used to download them once and use this script to install them on several computers at home, thus saving 4.5 GB of download. (At work we use WSUS to save bandwidth.) Before you ask, no, the Delivery Optimization service does not reduce bandwidth consumption for you; it reduces bandwidth consumption for Microsoft's servers. It depends on a centralized peer coordination server on the Internet.
- `Install all with DISM.exe.ps1`: Scans the current folder for Windows updates that you've manually downloaded from Microsoft Catalog or WSUS, then invokes `dism.exe` to install them all.
- `Opt in to Microsoft Update.ps1` and `Opt out of Microsoft Update.ps1` are used to enable or disable the "Microsoft Update" channel on the local computer. These scripts are much faster than the cumbersome  official GUI way, which I've long forgotten. When the "Microsoft Update" channel is not enabled, Windows uses the "Windows Update" channel instead.
- `Run all MSPs.ps1`: Scans the current folder and all its subfolders for `.msp` files and invokes Windows Installer to install them all. Many apps use MSPs to delivery updates. Microsoft Office 2016 and earlier are such apps.

### Wallpaper

The following two scripts are co-developed with Ramesh Srinivasan (the author of [WinHelpOnline.com](https://www.winhelponline.com)). More specifically, he wrote them in VBScript first, and I re-wrote them in PowerShell to support Unicode. Then, he credited me in his blog post and we added additional bits to support Windows 10. Back then, I knew zero about PowerShell and its philosophy, so, these scripts are unlike any other PowerShell scripts. In fact, they generate graphical message boxes.

- Find current wallpaper (Windows 7).ps1
- Find current wallpaper (Windows 8,10).ps1

### (Code snippets)

This special folder contains source code that one should not run directly. Rather, PowerShell developers could read them, learn from them, or include portions of them in their PowerShell scripts.

- `Demo - Message boxes in PowerShell.ps1`: This scripts demonstrates how to invoke message boxes within a PowerShell script. Normally, one must not use message boxes (or `Write-Host`) inside PowerShell scripts. Before Windows 10, however, console apps had serious problems displaying Unicode characters, so I used message boxes instead.
- `Demo - Pipeline-ready function.ps1`: Demonstrates how PowerShell passes objects through the pipeline.
- `Function library.psm1`: Contains a number of reusable functions. I've chosen the `.psm1` filename extension to prevent it from being accidentally run as a script, but it is not a real module. Each function has its own local help. The functions include:
    - **Test-ProcessAdminRights**: Returns $True when the process running this script has administrative privileges
    - **Test-UserAdminMembership**: Returns $True when the user account running this script is a member of the local Administrators group.
    - **Unregister-ScheduledTaskEx**: Unregisters several scheduled tasks whose names matches a wildcard patten (not regex)
    - **Remove-RegistryValues**: Attempts to remove one or more values from a given path in Windows Registry.
    - **New-TemporaryFileName**: Generates a string to use as your temporary file's name.
    - **New-TemporaryFolderName**: Generates a string to use as your temporary folder's name.
- `Template.psm1`: A simple template for creating `.psm1` files. It enables the strict mode, separates the public functions from private functions, and exposes the public functions.
