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
  $ScriptPath=(Split-Path $PSCommandPath)

  # Load Windows Forms and initialize visual styles
  [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
  [System.Windows.Forms.Application]::EnableVisualStyles()

  # Is the script holding administrative privileges?
  If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    if (!$BypassAdminPrompt) {
      Start-Process "powershell.exe" -ArgumentList "-NoExit -File `"$PSCommandPath`" -BypassAdminPrompt" -Verb RunAs
    } else {
      $result=[System.Windows.Forms.MessageBox]::Show("This script requires administrative privileges, which are absent.", $ScriptName, "OK", "Error");
    }
    break;
  }

  # Install...
  Set-Location $ScriptPath
  $MSP_list = Get-ChildItem *.msp -Recurse
  if ($MSP_list -eq $null) {
    $result=[System.Windows.Forms.MessageBox]::Show("Nothing found to install.`rSearch path was "+$ScriptPath, $ScriptName, "OK", "Error");
  }
  else
  {
    $MSP_list | ForEach-Object {
      $filename = $_.FullName
      Write-Host $filename
      $a=Start-Process msiexec.exe -ArgumentList "/p `"$filename`" /passive /norestart" -Wait -PassThru
      Write-Host "Exit code: $($a.ExitCode)"
    }
    Remove-Variable filename
    Pause
  }
  Remove-Variable MSP_list
}
Catch
{
  $result=[System.Windows.Forms.MessageBox]::Show("Error!`r`r"+$Error[0], $ScriptName, "OK", "Error");
  break;
}