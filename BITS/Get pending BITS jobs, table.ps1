#Requires -Version 5.1
#Requires -RunAsAdministrator

<#
.SYNOPSIS
  Shows a table of pending BITS jobs.
.DESCRIPTION
  This script runs `Get-BitsTransfer -AllUsers` and displays all jobs except "Transferred" job in
  a table.
.EXAMPLE
  PS C:\> & '.\Get pending BITS jobs, table.ps1'

  DisplayName                    BytesTotal BytesTransferred FileList
  -----------                    ---------- ---------------- --------
  MozillaUpdate 308046B0AF4A39CB   17754615         14615777 {https://download-installer.cdn.mozill…
  MozillaUpdate 308046B0AF4A39CB   17754615         14615777 {https://download-installer.cdn.mozill…
.INPUTS
  None
.OUTPUTS
  String
.NOTES
  None
#>

Import-Module -Name BitsTransfer -ErrorAction "Stop"

Get-BitsTransfer -AllUsers | Where-Object {$_.JobState -ne 'Transferred'} | Format-Table -Autosize -Property DisplayName,BytesTotal,BytesTransferred,FileList
