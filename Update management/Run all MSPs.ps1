<#  ATTENTION:

    YOU. WILL. FAIL...
    ...if you try to run this script by the following methods:
    1. PowerShell.exe ScriptName.ps1
    2. Right-clicking, selecting Open With..., choosing PowerShell

    Reason: PowerShell's script execution syntax is:
    powershell.exe -File <ScriptName.ps1> <args>
#>

param (
    [parameter(mandatory=$false)][Switch]$BypassAdminPrompt
)
Try
{
  Clear-Host

  # Get script name
  $ScriptName=(Split-Path $PSCommandPath -Leaf)

  # Load Windows Forms and initialize visual styles
  [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
  [System.Windows.Forms.Application]::EnableVisualStyles()

  # Is the script holding administrative privileges?
  If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    if (!$BypassAdminPrompt) {
      Start-Process "powershell.exe" -ArgumentList "-NoExit -File `"$PSCommandPath`" -BypassAdminPrompt" -Verb RunAs
    } else {
      [System.Windows.Forms.MessageBox]::Show("This script requires administrative privileges, which are absent.", $ScriptName, "OK", "Error") | Out-Null
    }
    break;
  }

  # Install...
  Set-Location $PSScriptRoot
  $MSP_list = Get-ChildItem *.msp -Recurse
  if ($null -eq $MSP_list) {
    [System.Windows.Forms.MessageBox]::Show("Nothing found to install.`rSearch path was "+$PSScriptRoot, $ScriptName, "OK", "Error") | Out-Null
  }
  else
  {
    $MSP_list | ForEach-Object {
      $filename = $_.FullName
      Output $filename
      $a=Start-Process msiexec.exe -ArgumentList "/p `"$filename`" /passive /norestart" -Wait -PassThru
      Write-Output "Exit code: $($a.ExitCode)"
    }
    Remove-Variable filename
    Pause
  }
  Remove-Variable MSP_list
}
Catch
{
  [System.Windows.Forms.MessageBox]::Show("Error!`r`r"+$Error[0], $ScriptName, "OK", "Error") | Out-Null
  break;
}
