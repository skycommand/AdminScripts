#Requires -RunAsAdministrator
#Requires -Version 5.1

<#
.SYNOPSIS
  Re-registers all packaged apps marked as System Components for the current user.
.DESCRIPTION
  Looks for all mainline packaged apps installed in "SystemApp". Re-registers them for the current
  user.
.NOTES
  DEPRECATED

  This script depends on Get-AppxPackage and its Appx module. As such, it won't work in PowerShell
  6 and later.

  This script is no longer necessary, thanks to Windows 10 quality having reached acceptable levels
  after nine years.
.LINK
  None
#>

Get-AppxPackage -AllUsers | Where-Object InstallLocation -Like "*SystemApp*" | ForEach-Object {
    $a=$_
    Format-List -InputObject $a -Property Name,InstallLocation
    Add-AppxPackage -Path "$($a.InstallLocation)\AppxManifest.xml" -Register -DisableDevelopmentMode
}
