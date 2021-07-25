#Requires -RunAsAdministrator

$OutputTemplate1 = @'
{0}
{1}
{2} | {3} | {4}
{5:N0} / {6:N0}
Files:
'@

$OutputTemplate2 =@'

    Remote Name: {0}
    Local Name:  {1}
    Progress:    {2:N0} / {3:N0} ({4})
'@

$SplitterLine = [String]::new([char]0x2500, 110)

# The following only works in PowerShell 7.x:
# $SplitterLine = [String]::new("`u{2500}", 110)

function Public_Static_Void_Main {
  Write-Output $SplitterLine
  Get-BitsTransfer -AllUsers -ErrorAction Stop | ForEach-Object {
      $a=$_
      Write-Output $($OutputTemplate1 -f $a.JobId,$a.DisplayName,$a.TransferType,$a.JobState,$a.Priority,$a.BytesTransferred,$a.BytesTotal)
      ForEach-Object -InputObject $a.FileList {
          if ($_.IsTransferComplete) { $b = "Complete" } else { $b = "Pending" }
          Write-Output $($OutputTemplate2 -f $_.RemoteName,$_.LocalName,$_.BytesTransferred,$_.BytesTotal,$b)
      }
      Write-Output $SplitterLine
  }
}

Public_Static_Void_Main
