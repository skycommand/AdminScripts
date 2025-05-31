#Requires -Version 5.1

<#
.SYNOPSIS
  Finds Windows wallpapers
.DESCRIPTION
  Finds paths of currently displayed Windows wallpapers. Once found, the script
  lists them in a message box. You can use Ctrl+C to copy the contents of the
  message box. Alternatively, the box allows you to launch File Explorer windows
  pointing to each wallpaper's path.
.INPUTS
  None
.OUTPUTS
  None
.NOTES
  This script uses PowerShell in the capacity of a generic scripting language.
  Hence, it is not automation-friendly.
#>

using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Collections.Generic
using namespace System.Text

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
  # Constants
  $RegKeyPath = 'HKCU:\Control Panel\Desktop'
  $RegValue = 'TranscodedImageCache(|_\d\d\d)'
  $PathStartDelta = 24
  $ErrorCountReadValue = 0

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
    # Check Windows version
    If ([Environment]::OSVersion.Version.Build -lt 9200) {
      Write-ErrorMessage "This script only supports Windows 8, 10, and 11, as well as their Windows Server siblings. (They identify themselves as Windows NT 6.2, 6.3 or 10.0.) You seem to be running:`r`r$([Environment]::OSVersion.VersionString)"
      break
    }

    # Read and decode
    [HashSet[String]]$PathList = [HashSet[String]]::new([StringComparer]::CurrentCultureIgnoreCase)
    $RegKey = Get-Item -LiteralPath $RegKeyPath -ErrorAction 'Stop'
    $RegValueList = $RegKey.Property -match $RegValue
    $RegValueList | ForEach-Object {
      try {
        if ($RegKey.GetValueKind($PSItem) -eq 'Binary') {
          [Byte[]]$Encoded = $RegKey.GetValue($PSItem)

          # This part looks for the end of a null-terminated UTF16 string. It checks each element
          # with an even index and its subsequent element for a 0x0000 sequence. Please note that
          # there may be other data after the string.
          $PathLength = $Encoded.Length - $PathStartDelta
          for ($i = $PathStartDelta + 2; $i -lt ($Encoded.length); $i += 2) {
            if (0 -eq $Encoded[$i] -bor $Encoded[($i + 1)]) {
              $PathLength = $i - $PathStartDelta
              break
            }
          }
          $Decoded = [UnicodeEncoding]::Unicode.GetString($Encoded, $PathStartDelta, $PathLength)
          $PathList.Add($Decoded) | Out-Null
        } else {
          $ErrorCountReadValue++
        }
      } catch {
        $ErrorCountReadValue++
      }
    }

    # Compile the results
    $MessageBuilder = [StringBuilder]::new()

    if ($ErrorCountReadValue -eq 0) {
      $MessageIcon = [MessageBoxIcon]::Asterisk
      if ($PathList.Count -gt 0) {
        $MessageButtons = [MessageBoxButtons]::YesNo
        $MessageBuilder.AppendLine('We found the following wallpaper records:') | Out-Null
      } else {
        $MessageButtons = [MessageBoxButtons]::OK
        $MessageBuilder.AppendLine('We found no wallpaper records.') | Out-Null
      }
    } else {
      $MessageIcon = [MessageBoxIcon]::Warning
      $MessageBuilder.AppendFormat('We encountered {0} errors while reading Windows Registry.', $ErrorCountReadValue) | Out-Null
      if ($PathList.Count -gt 0) {
        $MessageButtons = [MessageBoxButtons]::YesNo
        $MessageBuilder.AppendLine() | Out-Null
        $MessageBuilder.AppendLine('Nevertheless, we found the following wallpaper records:') | Out-Null
      } else {
        $MessageButtons = [MessageBoxButtons]::OK
        $MessageBuilder.Append(' As result, we found no wallpaper records.') | Out-Null
      }
    }
    if ($PathList.Count -ne 0) {
      $MessageBuilder.AppendLine() | Out-Null
      foreach ($element in $PathList) {
        $MessageBuilder.AppendLine($element) | Out-Null
      }
    }

    $result = [MessageBox]::Show(
      $MessageBuilder.ToString(),
      (Split-Path -Path $PSScriptRoot -Leaf),
      $MessageButtons,
      $MessageIcon
    )
    if ($result -eq "Yes")
    {
      foreach ($element in $PathList) {
        Start-Process explorer.exe -ArgumentList "/select,`"$element`""
      }
    }

  } catch {
    Write-ErrorMessage -Message "Error!`r`r$($Error[0])"
    break
  }
}

PublicStaticVoidMain @args
