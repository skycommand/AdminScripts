#Requires -Version 5.1
[CmdletBinding()]
param (
  # Specifies a path to a location. The value of the LiteralPath parameter is used exactly as it
  # is typed. No characters are interpreted as wildcards. If the path includes escape characters,
  # enclose it in single quotation marks. Single quotation marks tell PowerShell not to interpret
  # any characters as escape sequences.
  [Parameter(Mandatory = $false,
    Position = 0,
    ParameterSetName = "LiteralPath",
    HelpMessage = "Literal path to the location.")]
  [Alias("PSPath")]
  [String]
  $LiteralPath
)
If ($LiteralPath -notin ($null, '')) {
  $FilesToAnalyze = Get-Item $LiteralPath -ErrorAction Stop
} else {
  $FilesToAnalyze = Get-ChildItem *.ps1, *.psm1 -Recurse
}

Import-Module -Name PSScriptAnalyzer -MinimumVersion '1.19.1' -ErrorAction Stop
Push-Location $PSScriptRoot
$Settings = @{
  Rules = @{
    PSUseCompatibleSyntax = @{
      # This turns the rule on (setting it to false will turn it off)
      Enable         = $true

      # List the targeted versions of PowerShell here
      TargetVersions = @(
        '5.1',
        '6.2',
        '7.0'
      )
    }
  }
}
$FilesToAnalyze | ForEach-Object {
  Invoke-ScriptAnalyzer -Path $_ -Settings $Settings
} | Format-Table -AutoSize
Pop-Location
