#Requires -RunAsAdministrator

function Get-FixedVolume {
    Get-Volume | Where-Object DriveType -EQ Fixed | Sort-Object DriveLetter
}

$Volumes = Get-FixedVolume

Write-Output "Pre-scan status:"
Write-Output $Volumes

Write-Output "Scanning..."
foreach ($Volume in $Volumes) {
  Format-List -InputObject $Volume -Property DriveLetter,Path,UniqueID,FileSystemLabel,FileSystemType,Size,SizeRemaining
  $Volume | Repair-Volume -Scan # -Verbose
}

Write-Output "`nPost-scan status:"
Write-Output $(Get-FixedVolume)
