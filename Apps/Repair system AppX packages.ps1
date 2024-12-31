#Requires -Version 5.1
#Requires -RunAsAdministrator

<#
.SYNOPSIS
  Re-registers all AppX packages in the "SystemApp" folder.
.DESCRIPTION
  This script looks for  packages installed in "SystemApp" and re-registers them for the current
  user account.
.NOTES
  DEPRECATED. I strongly recommend not to use it.

  This script requires administrative privileges.

  This script depends on Get-AppxPackage and its Appx module. As such, it won't work in PowerShell
  6 and later, and returns an error (System.PlatformNotSupportedException).
.LINK
  None
#>

Import-Module -Name Appx -ErrorAction "Stop"

Get-AppxPackage -AllUsers | Where-Object InstallLocation -Like "*SystemApp*" | ForEach-Object {
  $a=$_
  Format-List -InputObject $a -Property Name,InstallLocation
  Add-AppxPackage -Path "$($a.InstallLocation)\AppxManifest.xml" -Register -DisableDevelopmentMode
}
