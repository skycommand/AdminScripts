#Requires -Version 5.1
#Requires -RunAsAdministrator

<#
.SYNOPSIS
  Shows the details of active BITS jobs.
.DESCRIPTION
  This script runs `Get-BitsTransfer -AllUsers` and displays jobs whose states are "Transferring" in
  details.
.EXAMPLE
  PS C:\> & '.\Get active BITS jobs, detailed.ps1'

  class BitsJob
  {
    DisplayName = MozillaUpdate 308046B0AF4A39CB
    BytesTotal = 9777572
    BytesTransferred = 9777571
    FileList =
      [
        class BitsFile
        {
          RemoteName = https://download-installer.cdn.mozilla.net/pub/firefox/releases/131.0.2/upda…
          LocalName = C:\ProgramData\Mozilla-1de4eec8-1241-4177-a864-e594e8d1fb38\updates\308046B0A…
          IsTransferComplete = False
          BytesTotal = 9777572
          BytesTransferred = 9777571
        }
      ]

  }

  class BitsJob
  {
    DisplayName = Edge Component Updater
    BytesTotal = 1673976
    BytesTransferred = 1673975
    FileList =
      [
        class BitsFile
        {
          RemoteName = http://msedge.b.tlu.dl.delivery.mp.microsoft.com/filestreamingservice/files/…
          LocalName = C:\Users\M\AppData\Local\Packages\microsoft.bingweather_8wekyb3d8bbwe\AC\Temp…
          IsTransferComplete = False
          BytesTotal = 1673976
          BytesTransferred = 1673975
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

Get-BitsTransfer -AllUsers | Where-Object {$_.JobState -eq 'Transferring'} | Format-Custom -Property DisplayName,BytesTotal,BytesTransferred,FileList
