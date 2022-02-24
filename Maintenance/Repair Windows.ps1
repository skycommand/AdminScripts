#Requires -RunAsAdministrator

Push-Location $PSScriptRoot

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

try {
  Write-Information "Starting stage 1, DISM"
  Write-Information $(Get-Date)
  Import-Module -Name Dism
  Repair-WindowsImage -Online -RestoreHealth -LogPath $(Join-Path -Path $PSScriptRoot -ChildPath 'DISM.log')

  Write-Information "Starting stage 2, SFC"
  Write-Information $(Get-Date)
  sfc.exe /ScanNow
  $CbsLogFull = Join-Path -Path $env:windir -ChildPath "logs\cbs\cbs.log"
  Copy-Item -Path $CbsLogFull -Destination $PSScriptRoot
}
finally {
  Pop-Location
}
