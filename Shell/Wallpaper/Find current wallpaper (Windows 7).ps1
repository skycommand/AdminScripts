<#
.SYNOPSIS
  Finds the Windows wallpaper on Windows 7 and Windows Server 2008 R2.
.DESCRIPTION
  Finds the path to the currently displayed Windows wallpaper, and displays the
  path in a message box. You can use Ctrl+C to copy the contents of the message
  box. Additionally, the message box allows you to direct Windows Explorer to
  the wallpaper's path.
.INPUTS
  None
.OUTPUTS
  None
.NOTES
  This script uses PowerShell in the capacity of a generic scripting language.
  Hence, it is not automation-friendly.
  This script doesn't support multiple monitors.
#>

#Requires -Version 5.1

using namespace System.Management.Automation
using namespace System.Windows.Forms

[CmdletBinding()]
param()

function Write-ErrorMessage {
  param(
    # Error message to write
    [Parameter(Mandatory, Position = 0)]
    [String]
    $Message
  )
  [MessageBox]::Show(
    $Message,
    (Split-Path -Path $PSCommandPath -Leaf),
    "OK",
    "Error"
  ) | Out-Null
}

function PublicStaticVoidMain {
  <#  Load the Windows Forms extension and initialize visual styles
      The correct loading of this assembly is essential for the use of message boxes. So, we cannot
      wrap this code inside a exception handler that shows errors via message boxes. In addition,
      Add-Type is a jerk. It doesn't understand the meaning of -ErrorAction = 'Stop'.
  #>
  $ErrorActionPreference = 'Stop'
  Add-Type -AssemblyName 'System.Windows.Forms'
  [Application]::EnableVisualStyles()
  $ErrorActionPreference = 'Continue'

  try {
    # Check Windows verison
    if ([Environment]::OSVersion.Version -ne [Version]"6.1") {
      Write-ErrorMessage "This script only supports Windows 7 or Windows Server 2008 R2. (They identify themselves as Windows NT 6.1.) You seem to be running:`r`r$([Environment]::OSVersion.VersionString)"
      break
    }

    # Access Windows Registry and get wallpaper path
    try {
      $WallpaperSource = (Get-ItemProperty "HKCU:\Software\Microsoft\Internet Explorer\Desktop\General" WallpaperSource -ErrorAction Stop).WallpaperSource
    } catch [ItemNotFoundException], [PSArgumentException] {
      Write-ErrorMessage  "We could not find the wallpaper's location.`r`r$($Error[0].Exception.Message)"
      break
    }

    # Test item's existence
    try {
      Get-Item $WallpaperSource -Force -ErrorAction Stop | Out-Null
    } catch [ItemNotFoundException] {
      Write-ErrorMessage "We found the wallpaper's location but it seems invalid: `r$WallpaperSource"
      break
    }

    # Show the item
    $result = [MessageBox]::Show(
      "We found a wallpaper at: `r$WallpaperSource`r`rLaunch Explorer?",
      "Script",
      "YesNo",
      "Asterisk"
    )
    if ($result -eq "Yes") {
      Start-Process explorer.exe -ArgumentList "/select,`"$WallpaperSource`""
    }
  } catch {
    Write-ErrorMessage "Error!`r`r$($Error[0])"
    break
  }

}

PublicStaticVoidMain @args
