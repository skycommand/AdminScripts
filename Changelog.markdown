# Change log

## June 2024

New:

- `Apps\Is x64.ps1`
- `Hardware\Set-BluetoothRadio.ps1`
- `Security\Malicious Software Removal Tool\Allow Windows Update to install MRT.reg`
- `Security\Malicious Software Removal Tool\Prevent Windows Update from installing MRT.reg`
- `Shell\Folder view state\Delete folder view state.reg`
- `Shell\Promotional Store apps (pre-Setup)\Disable promotional Store apps.reg`
- `Shell\Promotional Store apps (pre-Setup)\Enable promotional Store apps.reg`
- `Shell\Removable drives outside This PC\Hide removable drives outside This PC.reg`
- `Shell\Removable drives outside This PC\Show removable drives outside This PC, 32-bit.reg`
- `Shell\Removable drives outside This PC\Show removable drives outside This PC, 64-bit.reg`
- `Shell\Special folders under This PC\Remove all special folders from This PC, 32-bit.reg`
- `Shell\Special folders under This PC\Remove all special folders from This PC, 64-bit.reg`
- `Shell\Special folders under This PC\Restore all special folders to This PC, 32-bit.reg`
- `Shell\Special folders under This PC\Restore all special folders to This PC, 64-bit.reg`
- `Shell\Telemetry\Disable diagnostics data collection (reversible with Settings app).reg`
- `Shell\Web results in Windows Search\Disable web results in Windows Search.reg`
- `Shell\Web results in Windows Search\Restore web results to Windows Search.reg`

Changed:

- **AppX**: Renamed to **Apps**
- **Get installed apps.ps1**: Moved into the `Apps` folder
- **Optimize PATH variable.ps1**: Improved reliability
- **Find redundant drivers.ps1**: Minor wording change
- **Get Windows Firewall status.cmd**: Moved into the `Security\Others` folder. Improved, so that it now lists 32-bit apps installed on x64 machines.
- **Clear Windows Defender history.ps1**: Moved into the `Security\Others` folder

## March 2024

Changed:

- **Demos\ANSI escape sequences.ps1:** Extended this demo to support contrast comparison.

## February 2024

New:

- **Update management\Install updates with Wusa.exe.ps1:** Scans the current folder and all its subfolders for `.msu` files and invokes Windows Update Standalone Installer to install them all.

Remove:

- **Maintenance\Repair Windows.ps1:** This script proved more difficult than I had anticipated. I never had time to finish it.

Changed:

- **AppX\Get AppX package names.ps1:** Added help contents
- **AppX\Reinstall AppX Packages.ps1:** Added help contents
- **AppX\Remove AppX packages.ps1:** Added help contents
- **AppX\Repair system AppX packages.ps1:** Added help contents
- **BITS\Get all BITS jobs, custom.ps1:** Revised
- **Maintenance\Clean compatibility store.ps1:** Added help contents
- **Maintenance\Find broken services.ps1:** Trivial whitespace changes
- **Maintenance\Repair all volumes.ps1:** Added help contents

## November 2023

Changed (minor):

- **Shell\Wallpaper\Find current wallpaper (Windows 7).ps1**: Streamlines the version-checking code
- **Shell\Wallpaper\Find current wallpaper.ps1**: Streamlines the version-checking code
- **Maintenance\Clean compatibility store.ps1**: Shortens the code

## August 2023

Deprecated:

- Clear-WindowsDefenderHistory.ps1

## June 2023

Changed:

- **Maintenance\Optimize PATH variable.ps1**: This script now performs optimizations automatically.
- **AppX\Remove AppX packages.ps1**: Revised to match modern use cases. It no longer attempts to remove apps for all users.
- **Changelog.markdown**: Fixed dates.

## March 2023

Changed (major):

- **Shell\Wallpaper\Find current wallpaper.ps1**: I finally managed to obtain a second monitor! Now, this script correctly reports all wallpaper when multiple monitors have different wallpapers.

Changed (others):

- **Shell\Wallpaper\Find current wallpaper (Windows 7).ps1**: Fixed error handling bug.
- **Unicode test suite**: Removed Wikipedia logos, as my cooperation with Wikipedia is now over – and not in a good way. Someone purporting to represent Wikipedia's administration sent me a not-nice email. I've since decided not to trust anything I read in that email, including the identity of its sender and its degree of officiality. However, Wikipedia is yet another entry in the long list of institutions that started as champions of freedom, only to become a figurative police state.
- **Update management\Disable Microsoft Update.ps1**: Added `#Requires -Version 5.1`.
- **Update management\Enable Microsoft Update.ps1**: Added `#Requires -Version 5.1`.
- **Update management\Install updates with Dism.exe.ps1**: Fixed error handling bug.
- **Update management\Install updates with MsiExec.exe.ps1**: Fixed error handling bug.
- **Update management\Install updates with PowerShell.ps1**: Fixed error handling bug.

## February 2023

New:

- **Maintenance\Get installed apps.ps1**: A rudimentary script that queries Windows Registry for installed apps. In Windows PowerShell 5.1, you could accomplish the same via the `Get-Package` cmdlet since Windows comes bundled with a "Programs" package provider. This provider is not available in PowerShell 7.0 and later.

Changed:

- **Demos\ANSI escape sequences.ps1**: More comprehensive demo. Uses `Write-Output` instead of `Write-Host`.
- **Demos\System colors.ps1**: Renamed from `Enumerate system colors.ps1`. Fixed PowerShell 5.1 compatibility. Used `Write-Output` instead of `Write-Host`.
- **Graphics\Find good JPEG images (Opt-1).ps1**: Added comment-based help
- **Graphics\Find good JPEG images.ps1**: Added comment-based help
- **Shell\Wallpaper\Find current wallpaper.ps1**: Despite almost every byte in the file having changed, there has been little difference in their functionality. I intended to add the ability to find additional wallpapers on systems with two or more monitors but I'm having trouble procuring a second monitor.
- **Shell\Wallpaper\Find current wallpaper (Windows 7).ps1**: Ditto
- The analyzer now loads a more recent version of PSScriptAnalyzer

## August 2022

Changed:

- **Maintenance\Optimize PATH variable.ps1**: Minor optimization
- **Unicode test suite**: Recompressed images losslessly

## June 2022

New:

- **Demos\Enumerate system colors.ps1**: Demonstrates the `System.Drawing.SystemColors` class. This class enumerates the colors that Windows 7 uses to render its standard UI on the screen. Unfortunately, this class has limited uses in Windows 10 because it cannot retrieve the new Accent Color.
- **Graphics\Find good JPEG images.ps1**: This script first enumerates JPEG files within a folder. You can specify the `-Recurse` switch to force searching subfolders too. After that, it opens each file and extracts it width and height in pixels. The script silently ignores JPEG files that it cannot parse. I use this script to find JPEG images that use Huffman Coding instead of Arithmetic Coding.
- **Graphics\Find good JPEG images (Opt-1).ps1**: This script is my attempt to improve the performance of `Find good JPEG images.ps1`. I reasoned that instead of loading an entire JPEG file, I can load only the first 32 kB and still retrieve its width and height. I reasoned that reading less from the disk translates to higher performance. I was not wrong, but I had grossly overestimated the performance gain. I let both script loose over a set of 46,419 JPEG files. The performance gain was ... insignificant.
- **Maintenance\Clean compatibility store.ps1**: This script cleans the Windows compatibility store of items that you no longer have installed. This cleanup act is unlikely to improve your system's performance or stability. Perform it only if you absolutely need it, e.g., on a system you're preparing for generalization/imaging, to protect your privacy, or if a ludicrous lawsuit settlement is forcing you.
- **Maintenance\Find broken services.ps1**: Finds and list Windows services whose executable file paths are invalid. These services cannot start. This script won't delete them. In fact, it is imperative not to delete those "bad" entries without proper inspection. If they belong to built-in Windows services, you might want to repair your copy of Windows instead. Broken Windows entries could be a sign of malware penetration.
- **Maintenance\Find redundant drivers.ps1**: Sometimes, you have two versions of a device driver installed. This script finds them and lists older ones. But please do not use this script with "cleanup" mentality. (To discourage your from that mentality, the script doesn't automatically delete older drivers.) I found this script useful in one instance: On an HP laptop on which a Validity driver was interfering with a Synaptic WBF driver. I've derived this script from a free, open-source script by [Dmitry Nefedov](https://github.com/farag2). Be sure to visit his repo too.
- **Maintenance\Optimize PATH variable.ps1**: If you work with package managers (as a developer) or containerization solutions (as an IT admin), your PATH variable gets dirty soon. This script inspects both copies of PATH (per-user and machine-wide), removes bad or redundant entries, normalizes paths, and displays the optimized results.
- **Update management\Find update on Microsoft Catalog.ps1**: Finds an update package on Microsoft Catalog and returns its ID.

Changed:

- **Changes to the folder structure:** "Icon cache", "File associations", and "Wallpaper" are now subfolders of "Shell".
- **Clear Windows Update history.ps1**: This script now disables `BITS`, `DoSvc`, `UsoSvc`, `WaaSMedicSvc`, and `wuauserv` before proceeding.
- **Disable Microsoft Update.ps1**: Now requires Powershell 5.1.
- **Enable Microsoft Update.ps1**: Now requires Powershell 5.1.
- **Get AppX package names.ps1**: Now requires Powershell 5.1.

## February 2022

New:

- **Shell**: There are now three new `.reg` files that fix the `.ps1` file association in Microsoft Windows. Consult with the readme file about what they do.
    - `Fix 'Run with PowerShell' verb (PowerShell 7).reg`
    - `Fix 'Run with PowerShell' verb (Windows 10).reg`
    - `Fix 'Run with PowerShell' verb (Visual Studio Code - System).reg`
- **Code snippets\PS1 template.ps1** used as a template for creating new `.ps1` files.
- **Demos\Pipeline-ready function.ps1** demonstrates the peculiarities of creating pipeline-ready functions.
- **Unicode test suite\Text file.markdown** is UTF-16  LE text file that contains text in 12 different languages. Only very good text editors can show them all correctly.

Changed:

- **Many name changes.** I've renamed many of the scripts, as part of adopting the following coding guidelines:
    - `.ps1` files will have natural English names, preferably starting with an imperative verb.
    - `.ps1` files will contain scripts that are expected to run interactively. `Write-Host` is allowed.
    - Fully automated scripts, from now on, go into `.psm1` modules and will have cmdlet names compliant with PowerShell verb-noun standards.
    - `.ps1` files will not have a `pause` command. This was a fragile approach. The duty of keeping the PowerShell window open for the user to see the output is now with the operating system shell.
- **Code snippets\Functions library.psm1** now passes PSScriptAnalyzer tests.
- **Demos\ANSI escape sequences.ps1** now passes PSScriptAnalyzer tests.

## October 2021

New:

- **Demos folder** contains scripts that demonstrates how PowerShell works
- **Demos\ANSI escape sequences.ps1**: Demonstrates the use of ANSI escape sequences in PowerShell. In reality, I use it to calibrate my settings, i.e., to ensure that my color schemes and font choices maintain a high contrast. I kept it compatible with PowerShell 5.1.
- **Demos\Hello, World!.ps1**: This is a simple "Hello, World!" app in PowerShell. It is perfect for testing those alleged PowerShell-to-C# converters. To this date, I haven't seen one that can correctly convert this simple script to `Console.Write("Hello, World!")`.
- **Demos\Sort order.ps1**: Compares how .NET Framework sorts a `Char[]` array versus a `String[]` array, when both have the same contents.
- **Demos\Working paths.ps1**: There are three types of working paths (working folders) in PowerShell: Process working path, script working path, and invoker's working path. There are four ways of discovering them. This script prints the results of all four ways. However, for the invokers working path to show its effect, you must invoke this demo script from within another script.

Changed:

- **Code snippets folder**: Moved from `(Code snippets)`
- **Demos\Message boxes in PowerShell.ps1**: Moved from `(Code snippets)\Demo - Message boxes in PowerShell.ps1`
- **Demos\Pipeline-ready function.ps1**: Moved from `(Code snippets)\Demo - Pipeline-ready function.ps1`
- **Code snippets\PSM1 template.psm1**: Moved from `(Code snippets)\Template.psm1`

## July 2021

New:

- **\~Meta\~ Analyze.ps1**: Analyzes all PowerShell scripts via Script Analyzer.
- **Changelog.markdown**: The file whose contents you are reading right now!
- **(Code snippets)\Template.psm1**: A simple template for creating `.psm1` files. It enables the strict mode, separates the public functions from private functions, and exposes the public functions.
- **(Code snippets)\Demo - Pipline-ready function.ps1**: Demonstrates how PowerShell passes objects through the pipeline.
- **Update management\Clear-WindowsUpdateHistory.ps1**: Clears the history of installed Windows updates. Use this script when your update history is corrupt, causing Windows Update to download update packages even after you've installed an equivalent `.msu` package manually.

Changed:

- **(Code snippets)\Functions library.psm1**: Support `-WhatIf` and `-Confirm` in `Unregister-ScheduledTaskEx`, `Remove-RegistryValues`
- **AppX\Inventory AppX Packages.ps1**: Update legal notice
- **AppX\Reinstall Appx Packages.ps1**: Rename from `Reinstall-AppxPackages.ps1`
- **AppX\Remove notorious AppX packages.ps1**: Rename from `(Specialized) Remove these appx packages.ps1`. Require administrative privileges. Update package names.
- **AppX\Repair system apps.ps1**: Require administrative privileges
- **BITS\Active BITS jobs - Detailed.ps1**: Require administrative privileges
- **BITS\Active BITS jobs - Table.ps1**: Require administrative privileges
- **BITS\All BITS jobs - Custom.ps1**: Rewrite completely to use Write-Output instead of Write-Host. Remove the color-coding feature.
- **BITS\Pending BITS jobs - Detailed.ps1**: Require administrative privileges
- **BITS\Pending BITS jobs - Table.ps1**: Require administrative privileges
- **Maintenance\Repair-Windows.ps1**: Use `$PSScriptRoot`
- **Security\MpDefinitionPackage\~Meta~ Analyze.ps1**: Pipe output to `Format-Table -AutoSize`
- **Security\MpDefinitionPackage\~Meta~ Run.ps1**: Use `$PSScriptRoot`
- **Unicode test suite\Readme.markdown**: Rename from "README.md" to avoid the disputed ".md" filename extension
- **Update management\Find-MicrosoftUpdate.ps1**: Rename from `Get-WindowsUpdateFromMicrosoftCatalog.ps1`. Add comment-based help.
- **Update management\Install all with PowerShell.ps1**: Rename from `Install with DISM module.ps1`. Use `$PSScriptRoot` and `Out-Null`.
- **Update management\Install all with DISM.exe.ps1**: Rename from `Install with DISM.exe.ps1`. Use `$PSScriptRoot` and `Out-Null`.
- **Update management\Run all MSPs.ps1**: Use `$PSScriptRoot` and `Out-Null`

Removed:

- **Download\Download-Channel9VideosFromRSS.ps1**: This script was unreliable.
