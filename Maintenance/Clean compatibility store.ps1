#Requires -Version 5.1

<#
.SYNOPSIS
  Remove all local paths from the compatibility store.
.DESCRIPTION
  The application compatibility database can potentially record paths of every .exe file ever run on
  your PC. This is a necessity of the PC ecosystem. However, users ocassionally need to start fresh.
  This script empties the compatibility store.

  Unless you know what you are doing, don't run this script.
#>

using namespace System.Management.Automation

[CmdletBinding(SupportsShouldProcess)]
param()

function PublicStaticVoidMain {
  $CompatStorePath = 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store'
  $(Get-Item -LiteralPath $CompatStorePath).Property -Like '?:\*' | ForEach-Object {
    If (-not (Test-Path -LiteralPath $_)) {
      Write-Verbose $_
      Remove-ItemProperty -Path $CompatStorePath -Name ([WildcardPattern]::Escape($_))
    }
  }
}

PublicStaticVoidMain @args
