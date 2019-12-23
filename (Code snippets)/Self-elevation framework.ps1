param (
    [parameter(mandatory=$false)][Switch]$BypassAdminCheck
)
cls
$ScriptName=(Get-Item $PSCommandPath).Name

if ($BypassAdminCheck) {
    Write-Host Admin check is bypassed
    pause
} else {
    Write-Host Admin check is needed
    pause
    try {
      Start-Process powershell.exe -ArgumentList "-ExecutionPolicy $env:PSExecutionPolicyPreference -File `"$PSCommandPath`" -BypassAdminCheck" -Verb RunAs
    } catch {
      Write-Host $Error[0]
      Write-Host $Error[0].Exception.GetType()
      pause
    }
}