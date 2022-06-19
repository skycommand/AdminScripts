#Requires -RunAsAdministrator
using namespace System.Management.Automation

Set-StrictMode -Version Latest

function Exit-BecauseOsIsNotSupported {
  $PSCmdlet.ThrowTerminatingError(
    [ErrorRecord]::new(
      [PSInvalidOperationException]::new('This operating system is not supported.'),
      'OSNotSupported',
      [ErrorCategory]::InvalidOperation,
      [Environment]::OSVersion
    )
  )
}

function Public_Static_Void_Main {
  $SystemRoot = [Environment]::GetFolderPath("Window")
  $ProgramData = [Environment]::GetFolderPath("CommonApplicationData")

  $OSVersion = [Environment]::OSVersion
  if ($OSVersion.Platform -ne 'Win32NT') {
    Exit-BecauseOsIsNotSupported
  }
  $IsWindows10v20H1andLater = (($OSVersion.Version.Major -eq 10) -and ($OSVersion.Version.Revision -gt 19040))


  If ($IsWindows10v20H1andLater) {
    Stop-Service -Name BITS,DoSvc,UsoSvc,WaaSMedicSvc,wuauserv
    Remove-Item "$SystemRoot\Logs\WindowsUpdate\*" -Force
    Remove-Item "$SystemRoot\SoftwareDistribution\DataStore\Logs\edb.log" -Force
    Remove-Item "$ProgramData\USOPrivate\UpdateStore\*" -Force
    Start-Service -Name BITS,DoSvc,UsoSvc,WaaSMedicSvc,wuauserv
    & UsoClient.exe RefreshSettings
  } else {
    Stop-Service -Name wuauserv
    Remove-Item "$SystemRoot\SoftwareDistribution\DataStore\Logs\edb.log" -Force
    Start-Service -Name wuauserv
  }
}

Public_Static_Void_Main
