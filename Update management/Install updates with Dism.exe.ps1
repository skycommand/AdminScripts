#Requires -Version 5.1

<#
.SYNOPSIS
  Short description
.DESCRIPTION
  Long description
.EXAMPLE
  PS C:\> <example usage>
  Explanation of what the example does
.INPUTS
  Inputs (if any)
.OUTPUTS
  Output (if any)
.NOTES
  General notes
#>

using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Security.Principal

[CmdletBinding()]
[OutputType([void])]
param (
  [parameter(mandatory = $false)][Switch]$BypassAdminPrompt
)

function Initialize {
  [OutputType([void])]
  param()

  <#  Load the Windows Forms extension and initialize visual styles
      The correct loading of this assembly is essential for the use of message boxes. So, we cannot
      wrap this code inside a exception handler that shows errors via message boxes. In addition,
      Add-Type is a jerk. It doesn't understand the meaning of -ErrorAction = 'Stop'.
  #>
  $ErrorActionPreference = 'Stop'
  Add-Type -AssemblyName 'System.Windows.Forms'
  [Application]::EnableVisualStyles()
  $ErrorActionPreference = 'Continue'

  Clear-Host
}

function Write-ErrorMessage {
  [OutputType ([void])]
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

function HaveAdminPrivileges {
  [OutputType([bool])]
  param()

  If (-NOT ([WindowsPrincipal] [WindowsIdentity]::GetCurrent()).IsInRole([WindowsBuiltInRole] "Administrator")) {
    if (!$BypassAdminPrompt) {
      $StartProcessArgs = @{
        FilePath     = [Environment]::ProcessPath
        ArgumentList = "-NoExit -File `"$PSCommandPath`" -BypassAdminPrompt"
        Verb         = 'RunAs'
      }
      Start-Process @StartProcessArgs
    } else {
      Write-ErrorMessage -Message "This script requires administrative privileges, which are absent."
    }
    return $false
  } else {
    return $true
  }
}

function InstallUpdates {
  [OutputType([void])]
  param()

  $ErrorActionPreference = 'Stop'
  Push-Location $PSScriptRoot
  dism.exe /online /add-package /packagepath:.\ /LogPath:`".\DISM $(Get-Date -Format "yyyy-MM-dd HHmm").log`"
  Pop-Location
  $ErrorActionPreference = 'Continue'
}

function Main {
  Initialize
  Try {
    if (HaveAdminPrivileges) { InstallUpdates }
  } Catch {
    Write-ErrorMessage -Message "Error!`r`r$($Error[0])"
  }
}

Main @args