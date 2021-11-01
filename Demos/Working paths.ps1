function Public_Static_Void_Main {
  Write-Output "Demonstrating working paths"

  [Ordered]@{
    "Working folder (pwd)"                  =  $((Get-Location).Path)
    "PSScriptRoot"                          =  $PSScriptRoot
    "Parent of PSCommandPath"               =  $(Split-Path $PSCommandPath -Parent)
    "Parent of MyInvocation.PSCommandPath"  =  $(Split-Path $MyInvocation.PSCommandPath -Parent)
  } | Format-Table -AutoSize
}

Public_Static_Void_Main
