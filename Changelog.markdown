# Change log

## October 2021

New:

- **Demos folder** contains scripts that demonstrates how PowerShell works
- **Demos\ANSI escape sequences.ps1:** Demonstrates the use of ANSI escape sequences in PowerShell. In reality, I use it to calibrate my settings, i.e., to ensure that my color schemes and font choices maintain a high contrast. I kept it compatible with PowerShell 5.1.
- **Demos\Hello, World!.ps1:** This is a simple "Hello, World!" app in PowerShell. It is perfect for testing those alleged PowerShell-to-C# converters. To this date, I haven't seen one that can correctly convert this simple script to `Console.Write("Hello, World!")`.
- **Demos\Sort order.ps1:** Compares how .NET Framework sorts a `Char[]` array versus a `String[]` array, when both have the same contents.
- **Demos\Working paths.ps1:** There are three types of working paths (working folders) in PowerShell: Process working path, script working path, and invoker's working path. There are four ways of discovering them. This script prints the results of all four ways. However, for the invokers working path to show its effect, you must invoke this demo script from within another script.

Changes:

- **Code snippets folder:** Moved from `(Code snippets)`
- **Demos\Message boxes in PowerShell.ps1:** Moved from `(Code snippets)\Demo - Message boxes in PowerShell.ps1`
- **Demos\Pipeline-ready function.ps1:** Moved from `(Code snippets)\Demo - Pipeline-ready function.ps1`
- **Code snippets\PSM1 template.psm1:** Moved from `(Code snippets)\Template.psm1`

## July 2021

New:

- **~Meta~ Analyze.ps1:** Analyzes all PowerShell scripts via Script Analyzer.
- **Changelog.markdown:** The file whose contents you are reading right now!
- **(Code snippets)\Template.psm1:** A simple template for creating `.psm1` files. It enables the strict mode, separates the public functions from private functions, and exposes the public functions.
- **(Code snippets)\Demo - Pipline-ready function.ps1:** Demonstrates how PowerShell passes objects through the pipeline.
- **Update management\Clear-WindowsUpdateHistory.ps1:** Clears the history of installed Windows updates. Use this script when your update history is corrupt, causing Windows Update to download update packages even after you've installed an equivalent `.msu` package manually.

Changes:

- **(Code snippets)\Functions library.psm1:** Support `-WhatIf` and `-Confirm` in `Unregister-ScheduledTaskEx`, `Remove-RegistryValues`
- **AppX\Inventory AppX Packages.ps1:** Update legal notice
- **AppX\Reinstall Appx Packages.ps1:** Rename from `Reinstall-AppxPackages.ps1`
- **AppX\Remove notorious AppX packages.ps1:** Rename from `(Specialized) Remove these appx packages.ps1`. Require administrative privileges. Update package names.
- **AppX\Repair system apps.ps1:** Require administrative privileges
- **BITS\Active BITS jobs - Detailed.ps1:** Require administrative privileges
- **BITS\Active BITS jobs - Table.ps1:** Require administrative privileges
- **BITS\All BITS jobs - Custom.ps1:** Rewrite completely to use Write-Output instead of Write-Host. Remove the color-coding feature.
- **BITS\Pending BITS jobs - Detailed.ps1:** Require administrative privileges
- **BITS\Pending BITS jobs - Table.ps1:** Require administrative privileges
- **Maintenance\Repair-Windows.ps1:** Use `$PSScriptRoot`
- **Security\MpDefinitionPackage\~Meta~ Analyze.ps1:** Pipe output to `Format-Table -AutoSize`
- **Security\MpDefinitionPackage\~Meta~ Run.ps1:** Use `$PSScriptRoot`
- **Unicode test suite\Readme.markdown:** Rename from "README.md" to avoid the disputed ".md" filename extension
- **Update management\Find-MicrosoftUpdate.ps1:** Rename from `Get-WindowsUpdateFromMicrosoftCatalog.ps1`. Add comment-based help.
- **Update management\Install all with PowerShell.ps1:** Rename from `Install with DISM module.ps1`. Use `$PSScriptRoot` and `Out-Null`.
- **Update management\Install all with DISM.exe.ps1:** Rename from `Install with DISM.exe.ps1`. Use `$PSScriptRoot` and `Out-Null`.
- **Update management\Run all MSPs.ps1:** Use `$PSScriptRoot` and `Out-Null`

Deletions:

- **Download\Download-Channel9VideosFromRSS.ps1:** This script was unreliable.
