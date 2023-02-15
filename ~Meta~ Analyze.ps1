<#
.SYNOPSIS
  A controller script that runs PSScriptAnalyzer on this repo.
.DESCRIPTION
  Place this script at the root of your repo. Once run, it'll generates a list
  of all .ps1 and .psm1 files in your repo and runs PSScriptAnalyzer on them one
  by one.
.EXAMPLE
  PS C:\> & '.\~Meta~ Analyze.ps1' -Verbose
  Runs the script, enabling verbose output.
#>

#Requires -Version 7.1

using namespace System.Management.Automation

[CmdletBinding()]
param()

function PublicStaticVoidMain {
  [CmdletBinding()]
  param ()

  Import-Module -Name PSScriptAnalyzer -MinimumVersion '1.21.0' -ErrorAction Stop

  $FilesToAnalyze = Get-ChildItem -Path $PSScriptRoot -Include '*.ps1', '*.psm1' -Recurse
  $Settings = @{
    Rules = @{
      PSUseCompatibleSyntax = @{
        # This turns the rule on (setting it to false will turn it off)
        Enable         = $true

        # List the targeted versions of PowerShell here
        TargetVersions = @(
          '5.1',
          '7.0',
          '7.2'
        )
      }
    }
  }
  $FilesToAnalyze | ForEach-Object {
    Write-Verbose -Message $_
    Invoke-ScriptAnalyzer -Path $_ -Settings $Settings
  } | Format-Table -AutoSize
}

PublicStaticVoidMain @args
