#Requires -Version 5.1
#Requires -RunAsAdministrator

function Get-EligibleVolume {
  <#
  Eligible volumes must fit the following criteria:

  - Fixed disks only: Don't scan just any USB flash drive that happens to be plugged in.

  - NTFS only: There are many reasons for this choice.

    1. Only NTFS volumes can be checked with -Scan switch. ReFS volumes cannot be checked at all.
       Repair-Volume returns without doing anything. FAT volumes (FAT12, FAT16, FAT32, and ExFAT)
       do not support volume snapshots, so they can only be checked with -OfflineScanAndFix.

    2. While we CAN check FAT volumes with -OfflineScanAndFix, we mustn't. This switch aggressively
       dismounts them.

  OTHER IMPORTANT FACTS:

  1. If you ask ChkDsk to scan a ReFS volume, it returns with the following message:

    > The ReFS file system does not need to be checked.

  2. If you ask ChkDsk to scan a FAT volume, it returns a confusing error message:

    > Insufficient storage available to create either the shadow copy storage file or other shadow
    > copy data.
    > 
    > A snapshot error occured while scanning this drive. Run an offline scan and fix.
  
  3. PowerShell's Get-Volume lists ExFAT volumes as unknown but Repair-Volume understands them.
  #>

  Get-Volume | Where-Object -FilterScript { ($PSItem.DriveType -eq 'Fixed') -and ($PSItem.FileSystemType -eq 'NTFS') } | Sort-Object DriveLetter
}

$VolumeList = Get-EligibleVolume

Write-Output "Pre-scan status:"
Write-Output $VolumeList

Write-Output "Scanning..."
foreach ($Volume in $VolumeList) {
  Format-List -InputObject $Volume -Property DriveLetter, Path, UniqueID, FileSystemLabel, FileSystemType, Size, SizeRemaining
  $Volume | Repair-Volume -Scan
}

Write-Output "`nPost-scan status:"
Write-Output $(Get-EligibleVolume)
