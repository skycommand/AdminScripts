#Requires -Version 5.1
#Requires -RunAsAdministrator

<#
.SYNOPSIS
  Shows the details of pending BITS jobs.
.DESCRIPTION
  This script runs `Get-BitsTransfer -AllUsers` and displays all jobs except "Transferred" job in
  details.
.EXAMPLE
  PS C:\> & '.\Get pending BITS jobs, detailed.ps1'

  class BitsJob
  {
    DisplayName = MozillaUpdate 308046B0AF4A39CB
    BytesTotal = 17754615
    BytesTransferred = 14615777
    FileList =
      [
        class BitsFile
        {
          RemoteName = https://download-installer.cdn.mozilla.net/pub/firefox/releases/133.0/update…
          LocalName = C:\ProgramData\Mozilla-1de4eec8-1241-4177-a864-e594e8d1fb38\updates\308046B0A…
          IsTransferComplete = False
          BytesTotal = 17754615
          BytesTransferred = 14615777
        }
      ]

  }

  class BitsJob
  {
    DisplayName = MozillaUpdate 308046B0AF4A39CB
    BytesTotal = 17754615
    BytesTransferred = 14615777
    FileList =
      [
        class BitsFile
        {
          RemoteName = https://download-installer.cdn.mozilla.net/pub/firefox/releases/133.0/update…
          LocalName = C:\ProgramData\Mozilla-1de4eec8-1241-4177-a864-e594e8d1fb38\updates\308046B0A…
          IsTransferComplete = False
          BytesTotal = 17754615
          BytesTransferred = 14615777
        }
      ]

  }
.INPUTS
  None
.OUTPUTS
  String
.NOTES
  None
#>

Import-Module -Name BitsTransfer -ErrorAction "Stop"

Get-BitsTransfer -AllUsers | Where-Object {$_.JobState -ne 'Transferred'} | Format-Custom -Property DisplayName,BytesTotal,BytesTransferred,FileList
