#Requires -Version 7.0
[CmdletBinding()]
param (
)

function ExtractServiceExePath {
  <#
  .SYNOPSIS
    Extracts the .exe path from the BinaryPathName property of a System.ServiceProcess.ServiceController object
  #>
  param (
    # Supply a valid service invocation string, preferably from the BinaryPathName property of a System.ServiceProcess.ServiceController object.
    [Parameter(Position = 0, Mandatory)]
    [ValidateNotNullOrEmpty()]
    [String]
    $Expression
  )
  switch ($Expression[0]) {
    '"' { return ($Expression -match '^"(.+?)"') ? $Matches.1 : $Null }
    "'" { return ($Expression -match '^''(.+?)''') ? $Matches.1 : $Null }
    default { return ($Expression -match '^(.+?\.exe)') ? $Matches.1 : $Null }
  }
}

function Get-ServicePath {
  <#
  .SYNOPSIS
    Generates a list of Windows services consisting of their names, display names, command-line invocations, and binary file paths.
  #>
  [CmdletBinding()]
  param (
  )

  $PriorErrors = $Error.Count

  <#
  Get-Service -ErrorAction SilentlyContinue | Select-Object -Property @(
    "Name",
    "DisplayName",
    @{ label = "CommandLine"; e = { $_.BinaryPathName ?? "" } },
    @{ label = "Path"; e = {  } }
  )
  #>
  $ServiceList = [System.ServiceProcess.ServiceController]::GetServices() | Select-Object "Name","DisplayName"
  $ServiceList | ForEach-Object {
    $CommandLine = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SYSTEM\CurrentControlSet\Services\$($PSItem.Name)").GetValue("ImagePath") ?? [string]::Empty
    $Path = if ([string]::Empty -ne $CommandLine) { ExtractServiceExePath ($CommandLine) } else { $CommandLine }
    $PSItem | Add-Member -MemberType NoteProperty -Name "CommandLine" -Value $CommandLine
    $PSItem | Add-Member -MemberType NoteProperty -Name "Path"        -Value $Path
  }

  $ErrorCount = $Error.Count - $PriorErrors
  if ($ErrorCount -ge 1) {
    Write-Warning -Message "Errors occurred during service enumeration: $ErrorCount`r`n    Please use ""Get-Error"" to investigate."
  }
}

function Find-BrokenService {
  <#
  .SYNOPSIS
    Generates a list of broken Windows services whose binary file path is invalid.
  #>
  [CmdletBinding()]
  param (
  )

  $a = $null
  Get-ServicePath | Group-Object -Property Path | ForEach-Object {
    if (Test-Path -LiteralPath $_.Name) {
      Write-Verbose -Message "Valid path: ““$($_.Name)””"
    } else {
      if ($PSItem.Count -gt 1) {
        Write-Warning -Message "$($PSItem.Count) services have an invalid path: ““$($_.Name)””"
      } else {
        Write-Warning -Message "““$($PSItem.Group[0].Name)”” has an invalid path: ““$($_.Name)””"
      }
      $a += $_.Group
    }
  }
  return $a
}

function PublicStaticVoidMain {

  Push-Location -Path $PSScriptRoot

  $a = Find-BrokenService -Verbose:$VerbosePreference

  if ($null -ne $a) {
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