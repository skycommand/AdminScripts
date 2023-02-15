<#
.SYNOPSIS
  Finds Windows wallpapers. Intended for legacy versions of Windows.
.DESCRIPTION
  Finds the paths to the currently displayed Windows wallpapers. Once found, the script lists them
  in a message box. You can use Ctrl+C to copy the contents of the message box. Intended for use
  with Windows Vista and Windows 7, as well as their siblings.
.INPUTS
  None
.OUTPUTS
  None
.NOTES
  This script uses PowerShell in the capacity of a generic scripting language.
  Hence, it is not automation-friendly.
#>

#Requires -Version 5.1

using namespace System.Management.Automation

[CmdletBinding()]
param()

function PublicStaticVoidMain {
  Try {
    # Load Windows Forms and initialize visual styles
    Add-Type -AssemblyName 'System.Windows.Forms' -ErrorAction 'Stop'
    [System.Windows.Forms.Application]::EnableVisualStyles()

    # Check Windows verison
    $vers = [System.Environment]::OSVersion.Version
    If (!(($vers.Major -eq 6) -and ($vers.Minor -eq 1))) {
      $result = [System.Windows.Forms.MessageBox]::Show("This operating system is not supported. This script only supports Windows NT 6.1. (i.e. Windows 7 or Windows Server 2008 R2). You seem to be running:`r`r" + [System.Environment]::OSVersion.VersionString, "Script", "OK", "Error");
      break;
    }

    # Access Windows Registry and get wallpaper path
    try {
      $WallpaperSource = (Get-ItemProperty "HKCU:\Software\Microsoft\Internet Explorer\Desktop\General" WallpaperSource -ErrorAction Stop).WallpaperSource
    } catch [System.Management.Automation.ItemNotFoundException], [System.Management.Automation.PSArgumentException] {
      $result = [System.Windows.Forms.MessageBox]::Show("Windows does not seem to be holding a record of a wallpaper at this time.`r`r" + $Error[0].Exception.Message, "Script", "OK", "Error");
      break;
    }

    # Test item's existence
    try {
      Get-Item $WallpaperSource -Force -ErrorAction Stop | Out-Null
    } catch [System.Management.Automation.ItemNotFoundException] {
      $result = [System.Windows.Forms.MessageBox]::Show("Wallpaper is not found at the location Windows believes it is: `r$WallpaperSource", "Script", "OK", "Warning");
      break;
    }

    # Wallpaper should by now have been found.
    # Present it to the user. If he so chooses, launch Explorer to take him were wallpaper is.
    $result = [System.Windows.Forms.MessageBox]::Show("Wallpaper location: `r$WallpaperSource`r`rLaunch Explorer?", "Script", "YesNo", "Asterisk");
    if ($result -eq "Yes") {
      Start-Process explorer.exe -ArgumentList "/select,`"$WallpaperSource`""
    }
  } Catch {
    $result = [System.Windows.Forms.MessageBox]::Show("Error!`r`r" + $Error[0], "Script", "OK", "Error");
    break;
  }

}

PublicStaticVoidMain @args
