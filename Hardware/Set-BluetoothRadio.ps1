#Requires -Version 5.1

[CmdletBinding()]
Param (
  [Parameter(Mandatory = $true)]
  [ValidateSet('Off', 'On')]
  [String]$BluetoothStatus
)

If ($PSVersionTable.PSVersion.Major -ne 5) {
  Write-Error -Message "This script only runs on PowerShell 5.x because of limitations that Microsoft has put in place." -ErrorAction 'Stop'
  return
}

if ([Environment]::OSVersion.Version.Build -lt 10240) {
  Write-Error -Message "This script requires Windows 10 or later, or their Windows Server equivalents." -Exception 'Stop'
}

# The following line is NOT necessary. The Bluetooth service is a trigger-start service and doesn't
# need an explicit start command. Said command need administrative privileges anyway.
#
# If ((Get-Service bthserv).Status -eq 'Stopped') { Start-Service bthserv }

Add-Type -AssemblyName System.Runtime.WindowsRuntime

$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]

Function Await($WinRtTask, $ResultType) {
  $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
  $netTask = $asTask.Invoke($null, @($WinRtTask))
  $netTask.Wait(-1) | Out-Null
  $netTask.Result
}

[Windows.Devices.Radios.Radio, Windows.System.Devices, ContentType = WindowsRuntime] | Out-Null
[Windows.Devices.Radios.RadioAccessStatus, Windows.System.Devices, ContentType = WindowsRuntime] | Out-Null
Await ([Windows.Devices.Radios.Radio]::RequestAccessAsync()) ([Windows.Devices.Radios.RadioAccessStatus]) | Out-Null
$radios = Await ([Windows.Devices.Radios.Radio]::GetRadiosAsync()) ([System.Collections.Generic.IReadOnlyList[Windows.Devices.Radios.Radio]])
$bluetooth = $radios | Where-Object { $_.Kind -eq 'Bluetooth' }
[Windows.Devices.Radios.RadioState, Windows.System.Devices, ContentType = WindowsRuntime] | Out-Null
Await ($bluetooth.SetStateAsync($BluetoothStatus)) ([Windows.Devices.Radios.RadioAccessStatus]) | Out-Null