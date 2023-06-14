#Requires -Version 7.0
[CmdletBinding()]
param (
)

<#
.SYNOPSIS
  Extracts the .exe path from the BinaryPathName property of a System.ServiceProcess.ServiceController object
#>
function ExtractServiceExePath {
  param (
    # Supply a valid service invocation string, preferrably from the BinaryPathName property of a System.ServiceProcess.ServiceController object.
    [Parameter(Position = 0, Mandatory)]
    [String]
    $Expression
  )
  if ([String]::IsNullOrEmpty($Expression)) { return $Null }
  switch ($Expression[0]) {
    '"' { return ($Expression -match '^"(.+?)"') ? $Matches.1 : $Null }
    "'" { return ($Expression -match '^''(.+?)''') ? $Matches.1 : $Null }
    Default { return ($Expression -match '^(.+?\.exe)') ? $Matches.1 : $Null }
  }
}

<#
.SYNOPSIS
  Generates a list of Windows services consisting of their names, display names, command-line invocations, and binary file paths.
#>
function Get-ServicePath {
  [CmdletBinding()]
  param (
  )

  Get-Service | Select-Object -Property `
    Name,
    DisplayName,
    @{ label = "CommandLine"; e = { $_.BinaryPathName } },
    @{ label = "Path"; e = { ExtractServiceExePath ($_.BinaryPathName) } }
}

<#
.SYNOPSIS
  Generates a list of broken Windows services whose binary file path is invalid.
#>
function Find-BrokenService {
  [CmdletBinding()]
  param (
  )

  $a = $null
  Get-ServicePath | Group-Object -Property Path | ForEach-Object {
    If (Test-Path -LiteralPath $_.Name) {
      Write-Verbose -Message "Valid path: $($_.Name)"
    } else {
      Write-Warning -Message "Invalid path: $($_.Name)"
      $a += $_.Group
    }
  }
  return $a
}

function PublicStaticVoidMain {

  Push-Location -Path $PSScriptRoot

  $a = Find-BrokenService -Verbose:$VerbosePreference

  If ($null -ne $a) {
    $a | Out-GridView -Title "Broken services"
    Write-Output "$($a.Count) broken service(s) were found."
    Write-Output "Check the newly opened window for details."
  } else {
    Write-Output "No broken services were found."
  }

  Pop-Location

}

Set-StrictMode -Version Latest
PublicStaticVoidMain