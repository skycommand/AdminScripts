#Requires -Version 5.1

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
