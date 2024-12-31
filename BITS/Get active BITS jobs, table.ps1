#Requires -Version 5.1
#Requires -RunAsAdministrator

<#
.SYNOPSIS
  Shows a table of active BITS jobs.
.DESCRIPTION
  This script runs `Get-BitsTransfer -AllUsers` and displays jobs whose states are "Transferring" in
  a table.
.EXAMPLE
  PS C:\> & '.\Get active BITS jobs, table.ps1'

  DisplayName                    BytesTotal BytesTransferred FileList
  -----------                    ---------- ---------------- --------
  MozillaUpdate 308046B0AF4A39CB    9777572          9777571 {https://download-installer.cdn.mozill…
  Edge Component Updater            1673976          1673975 {http://msedge.b.tlu.dl.delivery.mp.mi…
.INPUTS
  None
.OUTPUTS
  String
.NOTES
  None
#>

Import-Module -Name BitsTransfer -ErrorAction "Stop"

Get-BitsTransfer -AllUsers | Where-Object {$_.JobState -eq 'Transferring'} | Format-Table -Autosize -Property DisplayName,BytesTotal,BytesTransferred,FileList
