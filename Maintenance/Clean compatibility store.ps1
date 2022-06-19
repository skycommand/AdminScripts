#Requires -Version 5.1

using namespace System.Management.Automation

[CmdletBinding(SupportsShouldProcess)]
param()

Function EscapeWildcards {
  param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [String]$InputString
  )
  return $($InputString -replace '([\[\]*?])','`$1')
}

function PublicStaticVoidMain {
  $CompatStorePath = 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store'
  $(Get-Item -LiteralPath $CompatStorePath).Property -Like '?:\*' | ForEach-Object {
    If (-not (Test-Path -LiteralPath $_)) {
      Remove-ItemProperty -Path $CompatStorePath -Name (EscapeWildcards($_)) -WhatIf
    }
  }
}

PublicStaticVoidMain @args
