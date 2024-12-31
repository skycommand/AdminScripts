#Requires -RunAsAdministrator
#Requires -Version 5.1

<#
.SYNOPSIS
  Short description
.DESCRIPTION
  Long description
.EXAMPLE
  PS C:\> & '.\Get all BITS jobs, custom.ps1'

  ──────────────────────────────────────────────────────────────────────────────────────────────────
  b8daf1ed-9b93-4feb-bc18-ef16199dec62
  MozillaUpdate 308046B0AF4A39CB
  Download | Transferred | Foreground
  9,777,572 / 9,777,572
  Files:
      Remote Name: https://download-installer.cdn.mozilla.net/pub/firefox/releases/131.0.2/update/wi
      Local Name:  C:\ProgramData\Mozilla-1de4eec8-1241-4177-a864-e594e8d1fb38\updates\308046B0AF4A3
      Progress:    9,777,572 / 9,777,572 (Complete)
  ──────────────────────────────────────────────────────────────────────────────────────────────────
  65d9da80-7b13-4da8-93eb-c7408c9ad597
  Edge Component Updater
  Download | Transferred | Normal
  1,673,976 / 1,673,976
  Files:
      Remote Name: http://msedge.b.tlu.dl.delivery.mp.microsoft.com/filestreamingservice/files/0c12d
      Local Name:  C:\Users\X\AppData\Local\Packages\microsoft.bingweather_8wekyb3d8bbwe\AC\Temp\edg
      Progress:    1,673,976 / 1,673,976 (Complete)
  ──────────────────────────────────────────────────────────────────────────────────────────────────
  05adff0b-36af-4f13-92f1-d798b00e7323
  MozillaUpdate 308046B0AF4A39CB
  Download | Transferred | Foreground
  20,461,606 / 20,461,606
  Files:
      Remote Name: https://download-installer.cdn.mozilla.net/pub/firefox/releases/132.0/update/win6
      Local Name:  C:\ProgramData\Mozilla-1de4eec8-1241-4177-a864-e594e8d1fb38\updates\308046B0AF4A3
      Progress:    20,461,606 / 20,461,606 (Complete)
  ──────────────────────────────────────────────────────────────────────────────────────────────────
  af7a4d77-ef30-4f28-900a-279a47028a9f
  MozillaUpdate 308046B0AF4A39CB
  Download | Transferred | Foreground
  17,754,615 / 17,754,615
  Files:
      Remote Name: https://download-installer.cdn.mozilla.net/pub/firefox/releases/133.0/update/win6
      Local Name:  C:\ProgramData\Mozilla-1de4eec8-1241-4177-a864-e594e8d1fb38\updates\308046B0AF4A3
      Progress:    17,754,615 / 17,754,615 (Complete)
  ──────────────────────────────────────────────────────────────────────────────────────────────────
.INPUTS
  None
.OUTPUTS
  String
.NOTES
  None
#>

function Main {
  $OutputTemplate1 = "{0}`n{1}`n{2} | {3} | {4}`n{5:N0} / {6:N0}`nFiles:"
  $OutputTemplate2 = "    Remote Name: {0}`n    Local Name:  {1}`n    Progress:    {2:N0} / {3:N0} ({4})"
  #OutputTemplate1: JobId, DisplayName, TransferType, JobState, Priority, BytesTransferred, BytesTotal
  #OutputTemplate2: RemoteName, LocalName, BytesTransferred, BytesTotal, "Complete"/"Pending"

  try {
    $BufferWidth = [Console]::BufferWidth
    if ($BufferWidth -lt 10) { $BufferWidth = 110 }
  }
  catch {
    $BufferWidth = 110
  }
  $SplitterLine  = [String]::new([char]0x2500, $BufferWidth)

  # The following only works in PowerShell 7.x:
  # $SplitterLine = [String]::new("`u{2500}", $BufferWidth)

  $a = Get-BitsTransfer -AllUsers -ErrorAction Stop
  if ($null -eq $a) {
    Write-Output "Found no BITS jobs."
    break
  }
  Write-Output $SplitterLine
  $a | ForEach-Object {
    Write-Output $($OutputTemplate1 -f $_.JobId, $_.DisplayName, $_.TransferType, $_.JobState, $_.Priority, $_.BytesTransferred, $_.BytesTotal)
    ForEach-Object -InputObject $_.FileList {
      if ($_.IsTransferComplete) { $b = "Complete" } else { $b = "Pending" }
      Write-Output $($OutputTemplate2 -f $_.RemoteName, $_.LocalName, $_.BytesTransferred, $_.BytesTotal, $b)
    }
    Write-Output $SplitterLine
  }
}

Main
