#Requires -RunAsAdministrator

# TO DO: Rewrite using list view

function Main {
  $OutputTemplate1 = "{0}`n{1}`n{2} | {3} | {4}`n{5:N0} / {6:N0}`nFiles:"
  $OutputTemplate2 = "    Remote Name: {0}`n    Local Name:  {1}`n    Progress:    {2:N0} / {3:N0} ({4})"
  $SplitterLine = [String]::new([char]0x2500, 110)

  # The following only works in PowerShell 7.x:
  # $SplitterLine = [String]::new("`u{2500}", 110)

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
