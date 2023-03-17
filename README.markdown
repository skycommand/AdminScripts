# Administrative scripts

![GitHub language count](https://img.shields.io/github/languages/count/skycommand/AdminScripts?style=for-the-badge)
![GitHub repo size](https://img.shields.io/github/repo-size/skycommand/AdminScripts?style=for-the-badge)
![GitHub](https://img.shields.io/github/license/skycommand/AdminScripts?style=for-the-badge)

Welcome! 😊

This repository contains scripts that I use for carrying out various tasks in Windows, mostly (but not exclusively) administrative tasks.

## How to download an use

You can either download each script individually or clone this entire repository. With one exception, all scripts are standalone and have no dependencies. That exception is the `MpDefinitionPackage` PowerShell module. (It's a PowerShell script module, meaning that you need its entire folder.) Most scripts are in PowerShell, so you need to open a PowerShell window to run them.

### Note for the newbies

I'm flattered that you intend to use my scripts. I hope you find them useful. But please pay attention.

YOU. WILL. FAIL...

...if you try to run this script by the following methods:

1. Issuing a `PowerShell.exe ScriptName.ps1` command
2. Right-clicking `ScriptName.ps1`, selecting Open With..., choosing PowerShell

Reason: PowerShell's script execution syntax is:

    powershell.exe -File "<ScriptName.ps1>" <parameters>


## Description of scripts

### AppX

Deals with Microsoft Store app packages.

- `Get AppX package names.ps1`: The `Get-AppxPackage` cmdlet in PowerShell can find all installed Microsoft Store apps, but it does not do a good job of discovering their display names. At best, it can show the technical package name. This script lists all AppX packages installed for the current user account, along with their display names. It accepts a `-Verbose` switch and its output can be piped to `Format-Table` or `Format-List`. I believe it can be expanded to work machine-wide.

- `Reinstall AppX Packages.ps1`:  Resets and re-registers all AppX packages that were either shipped with Windows or were published by Microsoft. It is a safer alternative to the utterly sadistic one-liners abound the web that retrieve a list of all AppX packages and reset them all.

- `Remove AppX packages.ps1`: This one is mostly for me, but others can find educational value in it. This script uninstalls a number of Microsoft Store apps for all users, without deleting their provisioned packages. I believe it can only run on Windows 10 version 1809 or later.

The following script belong to long-gone days. Nowadays, they are probably just dangerous, but not as dangerous as reckless things you find on the web.

- `Repair system AppX packages.ps1`: Re-registers all AppX packages installed in the "SystemApp" folder.

### BITS

The following scripts ask the BITS service for a list of all of its download and upload operations with a certain status and format the results in a certain form. More specifically:

Script name                           | Desired job status         | Format
------------------------------------- | -------------------------- | ------
`Get active BITS jobs, detailed.ps1`  | "Transferring"             | List
`Get active BITS jobs, table.ps1`     | "Transferring"             | Table
`Get pending BITS jobs, detailed.ps1` | anything but "Transferred" | List
`Get pending BITS jobs, table.ps1`    | anything but "Transferred" | Table

`Get all BITS jobs, custom.ps1` asks the BITS service for list of all of its operation, then summarizes them, so that only the job status, job ID, display name, type, priority, bytes transferred, and bytes total are shown, along with a list of all files in each job.

### Code snippets

This folder contains code that one should not run directly. Rather, PowerShell developers could read them, learn from them, or include portions of them in their PowerShell scripts.

- `Function library.psm1`: Contains a number of reusable functions. I've chosen the `.psm1` filename extension to prevent it from being accidentally run as a script, but it is not a real module. Each function has its own local help. The functions include:
    - **Test-ProcessAdminRight**: Returns $True when the process running this script has administrative privileges. Starting with PowerShell 4.0, the "Requires -RunAsAdministrator" directive prevents the execution of the script when administrative privileges are absent. However, there are still times that you'd like to just check the privilege (or lack thereof), e.g., to announce it to the user or downgrade script functionality gracefully.
    - **Test-UserAdminMembershipDirect**: Returns $True when the user account running this script is a **direct** member of the local Administrators group. However, even when this function returns $False, the user account may still be a nested member of said group. This function has several use cases, but it is not a reliable test as to whether the script running it has administrative privileges. (For that purpose, use Test-ProcessAdminRight.)
    - **Test-UserAdminMembershipRecursive**: Returns $True when the user account running this script is a member (direct or nested) of the local Administrators group. This function is not a reliable test as to whether the script running it has administrative privileges. (For that purpose, use Test-ProcessAdminRight.) However, it has several use cases, one of which is knowing whether the current user can request elevated access through the User Account Control.
    - **Unregister-ScheduledTaskEx**: Unregisters several scheduled tasks whose names matches a wildcard patten (not regex).
    - **Remove-RegistryValue**: Attempts to remove one or more values from a given path in Windows Registry.
    - **New-TemporaryFileName**: Generates a string to use as your temporary file's name.
    - **New-TemporaryFolderName**: Generates a string to use as your temporary folder's name.
    - **Get-AlphaUpper:** Returns an array of Char containing the English uppercase letters.
    - **Get-AlphaLower:** Returns an array of Char containing the English lowercase letters.
    - **Exit-BecauseOsIsNotSupported:** Ends the script with the following terminating error: "This operating system is not supported." Raises `PSInvalidOperationException`.
    - **Exit-BecauseFolderIsMissing:** Ends the script with the following terminating error: "Could not find the `$Title` at '`$Path`'." Raises `System.IO.DirectoryNotFoundException`.
    - **Exit-BecauseFileIsMissing:** Ends the script with the following terminating error: "Could not find the `$Title` at '`$Path`'." Raises `System.IO.FileNotFoundException`.

- `PSM1 template.psm1`: A simple template for creating `.psm1` files. It enables the strict mode, separates the public functions from private functions, and exposes the public functions.
- `PS1 template`: A simple template for creating `.ps1` files. It has skeleton code for comment-based help, importing the `System.Management.Automation` namespace, a parameter block, and an entry point function called `PublicStaticVoidMain`. While writing code in Visual Studio Code, this entry point function helps you keep your variables and logic within a function scope and avoid poisoning your environment with residue variables in the global scope.

### Demos

- `ANSI escape sequences.ps1`: Demonstrates the use of ANSI escape sequences to write text in plain, bold, underlined, and inverse styles, as well as in the 16 basic colors.
- `Hello, World!.ps1`: All developers start their journey by writing a "Hello, World!" app. This is the app in PowerShell.
- `Message boxes in PowerShell.ps1`: This scripts demonstrates how to invoke message boxes within a PowerShell script. Normally, one must not use message boxes (or `Write-Host`) inside PowerShell scripts. Before Windows 10, however, console apps had serious problems displaying Unicode characters, so I used message boxes instead.
- `Pipeline-ready function.ps1`: Demonstrates how PowerShell passes objects through the pipeline.
- `Sort order.ps1`: Demonstrates how differently .NET sorts visually identical String[] and Char[] arrays.
- `System colors.ps1`: Demonstrates the `System.Drawing.SystemColors` class. This class enumerates the colors that Windows 7 uses to render its standard UI on the screen. Unfortunately, this class has limited uses in Windows 10 because it cannot retrieve the new Accent Color.
- `Working paths.ps1`: In PowerShell, "working path" is an elusive concept. Cmdlets obey the PowerShell run-space's current folder while .NET methods use the "current folder" set onto the hosting process, e.g., `PowerShell.exe` or `PwSh.exe`.

### Firewall

- `Get-WindowsFirewallStatus.cmd` reports whether Windows 10's Firewall is on or off.

### Graphics

- `Find good JPEG images.ps1`: This script first enumerates JPEG files within a folder. You can specify the `-Recurse` switch to force searching subfolders too. After that, it opens each file and extracts it width and height in pixels. The script silently ignores JPEG files that it cannot parse. I use this script to find JPEG images that use Huffman Coding instead of Arithmetic Coding.
- `Find good JPEG images (Opt-1).ps1`: This script is my attempt to improve the performance of `Find good JPEG images.ps1`. I reasoned that instead of loading an entire JPEG file, I can load only the first 32 kB and still retrieve its width and height. I reasoned that reading less from the disk translates to higher performance. I was not wrong, but I had grossly overestimated the performance gain. I let both script loose over a set of 46,419 JPEG files. The performance gain was ... insignificant.

### Last logon time

- `Get last logon  time.ps1` returns a list of all local user accounts, as well as the date and time of their last logon.
- `Get last logon  time (Deprecated).vbs` takes a long time to run, but returns a list of all local user accounts, as well as the date and time of their last logon. A matter of licensing: I did not write this script. The user who posted it was called `Corvus1` and posted it in educational spirit. It's very old and outdated anyway; it's best not to use it.

### Maintenance

- `Clean compatibility store.ps1`: This script cleans the Windows compatibility store of items that you no longer have installed. This cleanup act is unlikely to improve your system's performance or stability. Perform it only if you absolutely need it, e.g., on a system you're preparing for generalization/imaging, to protect your privacy, or if a ludicrous lawsuit settlement is forcing you.
- `Compile PowerShell native images.bat`: Runs nGen inside Windows PowerShell. While PowerShell 6 and 7 run on .NET Core, Windows PowerShell and some Windows-exclusive PowerShell modules (which PowerShell 7 also loads) run on .NET Framework. Run this script with admin privileges whenever you update .NET Framework, or whenever you feel Windows PowerShell or PowerShell 7 for Windows are sluggish at launch time.
- `Find broken services.ps1`: Finds and list Windows services whose executable file paths are invalid. These services cannot start. This script won't delete them. In fact, it is imperative not to delete those "bad" entries without proper inspection. If they belong to built-in Windows services, you might want to repair your copy of Windows instead. Broken Windows entries could be a sign of malware penetration.
- `Find redundant drivers.ps1`: Sometimes, you have two versions of a device driver installed. This script finds them and lists older ones. But please do not use this script with "cleanup" mentality. (To discourage your from that mentality, the script doesn't automatically delete older drivers.) I found this script useful in one instance: On an HP laptop on which a Validity driver was interfering with a Synaptic WBF driver. I've derived this script from a free, open-source script by [Dmitry Nefedov](https://github.com/farag2). Be sure to visit his repo too.
- `Get installed apps.ps1`: A rudimentary script that queries Windows Registry for installed apps. In Windows PowerShell 5.1, you could accomplish the same via the `Get-Package` cmdlet since Windows comes bundled with a "Programs" package provider. This provider is not available in PowerShell 7.0 and later.
- `Optimize PATH variable.ps1`: If you work with package managers (as a developer) or containerization solutions (as an IT admin), your PATH variable gets dirty soon. This script inspects both copies of PATH (per-user and machine-wide), removes bad or redundant entries, normalizes paths, and displays the optimized results.
- `Repair all volumes.ps1`: Enumerates all fixed-disk volumes and sequentially runs `Repair-Volume` on them to scan them for errors.
- `Repair Windows.ps1`: Repairs the online Windows instance by running DISM and SFC. Their logs are moved to the desktop.

### Security

#### MpDefinitionPackage module

This entire folder, `MpDefinitionPackage`, is a PowerShell module that adds a cmdlet to your PowerShell: `Build-MpDefinitionPackage`. This cmdlet extracts Microsoft malware definition files from one computer and packages them up into a self-extracting archive, so that it can be installed on other computers. It requires WinRAR to work.

I conceived it as a script at a time when our site was suffering a network outage. Not only we couldn't update our antimalware, users were using USB flash drives (notorious for being malware carriers) to transfer files. Desperate times need desperate measures. I wrote this solution to keep our devices secure. Eventually, I turned it into a module.

**Warning:**

- Be aware that Microsoft antimalware definitions are copyright-protected properties of Microsoft Corporation. Handling them, with or without this module, must be in compliance with the copyright laws of your region. Residents of the United States of America must use this module in compliance with the Title 17 of United States Code, section 117 ("Limitations on exclusive rights: Computer programs"), article C (USC17 § 117c).
- I do not guarantee that this solution works. If you wish to update an entire network while preserving Internet bandwidth, the official solutions are _Windows Server Update Services_ and _System Center_.

#### Others

- `Clear-WindowsDefenderHistory.ps1`: Clears the "protection history" of Microsoft Defender Antivirus (commonly referred to as Windows Defender). Starting with Windows 10 version 1703, this products no longer allows the users to clear the protection history via its UI. This "history", however, is each user's personal property. It is the owner's discretion to keep or clear it.

### Shell

#### File associations

The following scripts fix the `.ps1` file association in Microsoft Windows.

- `Fix 'Run with PowerShell' verb (legacy).reg`
- `Fix 'Run with PowerShell' verb (PowerShell 7).reg`
- `Fix 'Run with PowerShell' verb (Windows 10).reg`
- `Fix 'Run with PowerShell' verb (Visual Studio Code - System-wide).reg`

Since at least PowerShell 3.0, there has been a bug in the "Run with PowerShell" verb (formerly "Run with Windows PowerShell") of the `.ps1` files: If your PowerShell script has a mono quotation mark (`'`) in its name, the "Run with PowerShell" command fails. Let's inspect the command string to find out why:

```bash
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" "-Command" "if((Get-ExecutionPolicy ) -ne 'AllSigned') { Set-ExecutionPolicy -Scope Process Bypass }; & '%1'"
```

The offending part is the last seven letters: `& '%1'"`

In this string, `%1` gets replaced with the name of your `.ps1` file. If this file's name contains mono quotation marks, the parser gets misled.

In legacy PowerShell versions, the solution is to use the `-File` switch instead of the `-Command`. In modern versions of PowerShell (7.x and 5.1 for Windows 10), however, I opted a more fancy approach:

```bash
"C:\Program Files\PowerShell\7\pwsh.exe" -Command "$host.UI.RawUI.WindowTitle = 'PowerShell 7 (x64)'; if ((Get-ExecutionPolicy ) -ne 'AllSigned') { Set-ExecutionPolicy -Scope Process Bypass }; & """%1"""; Pause"
```

I've replaced the offending mono quotation marks with three double quotation marks. This way, I can keep using the `-Command` switch. I've added a new "Pause" instruction that prevents the script window from disappearing.

#### Icon cache

There was a period of time (2011–2016) when Windows was plagued with bugs that corrupted the icon cache. These scripts were conceived in that time, as ways of mitigating the problem. I have long stopped using them, though.

`Refresh icon cache with MoveFile.cmd` is the most effective of those but it is hard-coded to use an installed copy of `MoveFile.exe` from the Microsoft Sysinternals utility set.

#### Wallpaper

The following two scripts are co-developed with Ramesh Srinivasan (the author of [WinHelpOnline.com](https://www.winhelponline.com)). More specifically, he wrote them in VBScript first, and I re-wrote them in PowerShell to support Unicode. Then, he credited me in his blog post and we added additional bits to support Windows 10. Back then, I knew zero about PowerShell and its philosophy, so, these scripts are unlike any other PowerShell scripts. In fact, they generate graphical message boxes.

- `Find current wallpaper (Windows 7).ps1`
- `Find current wallpaper.ps1`

### Shutdown

The names of these scripts are self-explanatory.

- `Log off.vbs`
- `Power off.vbs`
- `Power off (Alternative).vbs`
- `Restart.vbs`
- `Restart (Alternative).vbs`

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

In this folder, you find a group of text files that use Unicode characters in their names. They represent a widespread Unicode use case that does not consist of some arbitrary Unicode characters. The Unicode strings used in the file names have been in front of two billion Internet users for one and half a decade. They are the most peer-reviewed pieces of Unicode strings in the world.

These files aren't copyright-encumbered. But please be aware that "Wikipedia" is a trademark of "Wikimedia Foundation." As long as you don't try to include it in the title of your product or organization, you are fine.

### Update management

- `Clear Windows Update history.ps1`: This scripts clears the so-called Windows "update history," which is a log of installation events, not a history. This log could be potentially misleading. It might report that you've installed the "security update for Visual C++ 2005 SP1 Redistributable Package" on such-and-such date and time, without telling that you've removed it on a later date. Clearing scary logs is sometimes necessary.
- `Disable Microsoft Update.ps1` and `Enable Microsoft Update.ps1` are used to enable or disable the "Microsoft Update" channel on the local computer. These scripts are much faster than the cumbersome official GUI way, which I've long forgotten. When the "Microsoft Update" channel is not enabled, Windows uses the "Windows Update" channel instead.
- `Find update on Microsoft Catalog.ps1`: Finds an update package on Microsoft Catalog and returns its ID.
- `Get automatic update services.ps1`: Gives you a list of all update channels registered with the local instance of the Windows Update service. You are probably aware of the "Windows Update" and "Microsoft Update" channels. (The former contains updates for Windows only, the latter for all Microsoft products.) But not everyone knows about WSUS. This script is specifically useful to find out if the local computer is properly registered with WSUS.
- `Install updates with Dism.exe.ps1`: Scans the current folder for Windows updates that you've downloaded from Microsoft Catalog or WSUS, then invokes `dism.exe` to install them all.
- `Install updates with MsiExec.exe.ps1`: Scans the current folder and all its subfolders for `.msp` files and invokes Windows Installer to install them all.
- `Install updates with PowerShell.ps1`: Scans the current folder for Windows updates that you've downloaded from Microsoft Catalog or WSUS, then invokes `Add-WindowsPackage` to install them all. There was a time when Microsoft released 1.5 GB worth of updates each month. I used to download them once and use this script to install them on several computers at home, thus saving 4.5 GB of download. (At work we use WSUS to save bandwidth.) Before you ask, no, the Delivery Optimization service does not reduce bandwidth consumption for you; it reduces bandwidth consumption for Microsoft's servers. It depends on a centralized peer coordination server on the Internet.
