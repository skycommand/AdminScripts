#Requires -Version 5.1

<#
.SYNOPSIS
Reveals the "device path" (\Device\HarddiskVolume##) for each Windows partition.
Device paths are internal kernel conventions. Windows rarely exposes them, but
when it does, the user needs to figure to what they're referring.

.DESCRIPTION
Enumerates all Windows volumes and list their "mount point," "volume name," and
"device path." These terms are defined as follows:

- "MOUNT POINT": Usually appears as "X:\", where "X" is a letter. NTFS volumes
  could be mounted in the directory structure of another NTFS volume, e.g.,
  "C:\Mount Points\WIM1"

- "VOLUME NAME": Appears as "\\?\Volume{########-####-####-####-############}\"
  where "#" is a hexadecimal digit (0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F).

- "DEVICE PATH": Appears "\Device\HarddiskVolume[#]", where "[#]" is one or more
  digits. Finding this item is the purpose of this script. Other items provide
  context. Windows rarely exposes device paths, but when it does, the user needs
  to figure to what they're referring. For example, `PowerCfg.exe /Requests` and
  `BCDEdit.exe` commands show device paths in their output.

.EXAMPLE
PS C:\>& '.\List all HarddiskVolume objects.ps1' | Sort-Object -Property Index

Index MountPoint VolumeName                                        DevicePath
----- ---------- ----------                                        ----------
1                \\?\Volume{34e03429-954c-11e7-ab29-96e5d74c0547}\ \Device\HarddiskVolume1
3     C:\        \\?\Volume{34e03428-954c-11e7-ab29-96e5d74c0547}\ \Device\HarddiskVolume3
4                \\?\Volume{e9066cf1-a410-4a8b-a5ca-e14405115dc7}\ \Device\HarddiskVolume4
5     D:\        \\?\Volume{34e0342a-954c-11e7-ab29-96e5d74c0547}\ \Device\HarddiskVolume5
6     E:\        \\?\Volume{0001ab51-1d10-024a-ef07-d901a2560300}\ \Device\HarddiskVolume6
7     G:\        \\?\Volume{0001ae53-9b30-02bf-ef4f-f975a65c0300}\ \Device\HarddiskVolume7
8     F:\        \\?\Volume{032d0340-07ef-01d9-8081-9681f783ec00}\ \Device\HarddiskVolume8
10    W:\        \\?\Volume{012cec3e-7375-4f45-958b-304c1a5e66bc}\ \Device\HarddiskVolume10

.EXAMPLE
PS D:\>Get-ChildItem "C:\"
PS D:\>Get-ChildItem "\\.\C:\"
PS D:\>Get-ChildItem '\\`?\C:\'
PS D:\>Get-ChildItem "\\``?\C:\"
PS D:\>Get-ChildItem "\\.\HarddiskVolume3\"
PS D:\>Get-ChildItem '\\`?\HarddiskVolume3\'
PS D:\>Get-ChildItem "\\``?\HarddiskVolume3\"
PS D:\>Get-ChildItem "\\.\Harddisk0Partition3\"
PS D:\>Get-ChildItem '\\`?\Harddisk0Partition3\'
PS D:\>Get-ChildItem "\\``?\Harddisk0Partition3\"
PS D:\>Get-ChildItem "\\.\Volume{34e03428-954c-11e7-ab29-96e5d74c0547}\"
PS D:\>Get-ChildItem '\\`?\Volume{34e03428-954c-11e7-ab29-96e5d74c0547}\'
PS D:\>Get-ChildItem "\\``?\Volume{34e03428-954c-11e7-ab29-96e5d74c0547}\"
PS D:\>Get-ChildItem "\\.\BootPartition\"
PS D:\>Get-ChildItem '\\`?\BootPartition\'
PS D:\>Get-ChildItem "\\``?\BootPartition\"

Trailing backslashes ara MANDATORY.

All of the above generate similar output, although through different code paths:

    Directory: \\.\HarddiskVolume3\

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-r--          2025-09-20    00:56                Program Files
d-r--          2025-09-22    15:14                Program Files (x86)
d----          2025-07-09    03:34                Recovery
d-r--          2024-09-14    23:56                Users
d----          2025-09-22    18:08                Windows

.NOTES
This script runs only on Microsoft Windows, and finds volumes via Windows API,
which deliberately skips MSR partitions. As result, "Index" values might not
form a contiguous subset of natural numbers. In Example #1, you can see that "2"
doesn't appear in the Index column.

Windows uses `\Device\HarddiskVolume[#]` and `\Device\CdRom[#]` kernel objects
to represents disk partitions and read-only discs respectively, thus abstracting
their differences and exposing them as "file system volumes". `[#]` starts at 1.

However, most Windows API functions that deal files and disks don't consume said
kernel objects directly. They can only consume one of the following items in the
"\GLOBAL??" directory via the `\?\\` or `\.\\` Win32 conventions:

- \GLOBAL??\HarddiskVolume[#]

  Points to the corresponding `\Device\HarddiskVolume[#]`. The code merely needs
  to replace `\Device\`  with `\?\\` or `\.\\`.

- \GLOBAL??\Harddisk[#]Partition[#]

  You could use the Get-Partition command and this script's output to discover
  the correct disk and partition numbers. Disk numbers start at zero, while
  partition numbers start at 1.

- \GLOBAL??\X:

  X is a letter. This item is called a DOS device.

- \GLOBAL??\Volume{########-####-####-####-############}

  This appears in the script's output, but its too cumbersome for widespread use.

- \GLOBAL??\BootPartition

  Points to the partition that contains the Windows folder (not boot loader).
  This partition is almost always linked to the "C:" DOS device. (Windows 7 and
  later insist on registering this DOS device with the Windows partition.)

- \GLOBAL??\SystemPartition

  Points to the partition that contains the boot loader (not %SystemRoot%). On
  modern PCs, this is frequently the EFI System Partition (ESP). Accessing ESP
  requires administrative privileges.

The `\GLOBAL??` directory is better known as "Win32 Namespace" and exclusively
contains symbolic links to other parts of the NT namespace.
#>

using namespace System.Management.Automation
using namespace System.Text

[CmdletBinding()]
param()

if (($PSVersionTable.PSVersion.Major -gt 5) -and
  ($PSVersionTable.Platform -ne 'WIN32NT')) {
  $PSCmdlet.ThrowTerminatingError(
    [ErrorRecord]::new(
      [PSInvalidOperationException]::new('This operating system is not supported.'),
      'OSNotSupported',
      [ErrorCategory]::InvalidOperation,
      [System.Environment]::OSVersion
    )
  )
}

$CSharp1 = @'
[DllImport("kernel32.dll", SetLastError = true)]
public static extern IntPtr FindFirstVolume(
  [Out] StringBuilder VolumeName,
  UInt32 BufferLength
);

[DllImport("kernel32.dll", SetLastError = true)]
public static extern bool FindNextVolume(
  IntPtr FindVolume,
  [Out] StringBuilder VolumeName,
  UInt32 BufferLength
);

[DllImport("kernel32.dll", SetLastError = true)]
public static extern bool FindVolumeClose(
  IntPtr FindVolume
);

[DllImport("kernel32.dll", SetLastError=true)]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool GetVolumePathNamesForVolumeNameW(
  [MarshalAs(UnmanagedType.LPWStr)] string VolumeName,
  [MarshalAs(UnmanagedType.LPWStr)] [Out] StringBuilder VolumeNamePaths,
  UInt32 BufferLength,
  ref UInt32 ReturnLength
);

[DllImport("kernel32.dll", SetLastError = true)]
public static extern uint QueryDosDevice(
  string DeviceName,
  StringBuilder TargetPath,
  UInt32 BufferLength
);

'@
Add-Type -MemberDefinition $CSharp1 -Name Win32Utils -Namespace PInvoke -Using PInvoke, System.Text

[UInt32] $ReturnLength     = 0
[UInt32] $MountPointLength = 260 # 260 = MAX_PATH
[UInt32] $VolumeNameLength = 50  # 50 = 49 characters plus 1 for the null
[UInt32] $DevicePathLength = 30  # 30 = 22 for "\Device\HarddiskVolume", 1 for the null, 7 for index

# The StringBuilder's constructor has several overloads. If you call the constructor with o single
# parameter, PowerShell will ALWAYS invoke `new([string] value)`. To invoke `new ([int] capacity)`,
# explicitly cast the parameter to Int.
$MountPoint = [StringBuilder]::new([Int]$MountPointLength)
$VolumeName = [StringBuilder]::new([Int]$VolumeNameLength)
$DevicePath = [StringBuilder]::new([Int]$DevicePathLength)

# Populate $VolumeName
[IntPtr] $VolumeHandle = [PInvoke.Win32Utils]::FindFirstVolume($VolumeName, $VolumeNameLength)
# TO DO: Check $VolumeHandle isn't INVALID_HANDLE_VALUE.
try {
  do {
    # Populate $MountPoint from $VolumeName
    [void][PInvoke.Win32Utils]::GetVolumePathNamesForVolumeNameW(
      $VolumeName.ToString(),
      $MountPoint,
      $MountPointLength,
      [Ref] $ReturnLength)

    # Populate $DevicePath from $VolumeName
    [void][PInvoke.Win32Utils]::QueryDosDevice(
      $VolumeName.ToString(4, $VolumeName.Length - 5),
      $DevicePath,
      $DevicePathLength)

    # Build the results
    $o = [PSCustomObject]@{
      Index = [Int]-1
      MountPoint = $MountPoint.ToString()
      VolumeName = $VolumeName.ToString()
      DevicePath = $DevicePath.ToString()
    }
    If ($o.DevicePath -match '\\Device\\HarddiskVolume(\d+)') {
      $o.Index = [Int]$Matches[1]
    }

    # Return the results
    $o
  } while ([PInvoke.Win32Utils]::FindNextVolume([IntPtr] $VolumeHandle, $VolumeName, $VolumeNameLength))
}
finally {
  [void][PInvoke.Win32Utils]::FindVolumeClose([IntPtr] $VolumeHandle)
}