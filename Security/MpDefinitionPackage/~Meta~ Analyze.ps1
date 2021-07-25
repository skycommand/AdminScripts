#Requires -Version 5.1
Import-Module -Name PSScriptAnalyzer -ErrorAction Stop
Push-Location $PSScriptRoot
$Settings = @{
    Rules = @{
        PSUseCompatibleSyntax = @{
            # This turns the rule on (setting it to false will turn it off)
            Enable = $true

            # List the targeted versions of PowerShell here
            TargetVersions = @(
                '5.1',
                '6.2',
                '7.0'
            )
        }
    }
}
Get-ChildItem *.ps1,*.psm1 | ForEach-Object {
    Invoke-ScriptAnalyzer -Path $_ -Settings $Settings
} | Format-Table -AutoSize
Pop-Location
