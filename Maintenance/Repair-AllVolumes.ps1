function Get-FixedVolume {
    Get-Volume | Where-Object DriveType -EQ Fixed | Sort-Object DriveLetter
}

$Volumes = Get-FixedVolume
foreach ($Volume in $Volumes) {
  Format-List -InputObject $Volume -Property DriveLetter,Path,UniqueID,FileSystemLabel,FileSystemType,Size,SizeRemaining
  $Volume | Repair-Volume -Scan -Verbose
}
Get-FixedVolume