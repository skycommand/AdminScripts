Try 
{
  # Get script name
  #$ScriptName=(Get-Item $PSCommandPath).Name

  # Load Windows Forms and initialize visual styles
  # This action is not needed for Windows 8.x
  # But a user might run this script on previous versions, just because 
  [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
  [System.Windows.Forms.Application]::EnableVisualStyles()

  # Check Windows verison
  $vers=[System.Environment]::OSVersion.Version
  If (!(($vers.Major -eq 10) -or (($vers.Major -eq 6) -and ($vers.Minor -ge 2)))) { 
    $result=[System.Windows.Forms.MessageBox]::Show("This operating system is not supported. This script only supports Windows NT 6.2, 6.3 or 10.x. (i.e. Windows 8, Windows Server 2012, Windows 8.1, Windows Server 2012 R2 or Windows 10). You seem to be running:`r`r"+[System.Environment]::OSVersion.VersionString, "Script", "OK", "Error");
    break;
  }

  # Initialize counters
  $Path_Start_Delta=24  #The offset at which the image path starts
  $Path_End_Delta=-1    #The offset at which the image path ends... is still unknown
  
  # First, access Windows Registry and get the property containing wallpaper path
  try {
    $TranscodedImageCache=(Get-ItemProperty 'HKCU:\Control Panel\Desktop' TranscodedImageCache -ErrorAction Stop).TranscodedImageCache
  }
  catch [System.Management.Automation.ItemNotFoundException],[System.Management.Automation.PSArgumentException]  {
    $result=[System.Windows.Forms.MessageBox]::Show("Windows does not seem to be holding a record of a wallpaper at this time.`r`r"+$Error[0].Exception.Message,"Script","OK","Error");
    break;
  }
  
  # Decode the property containing the path
  # First, let's assume the path ends at the last byte of $TranscodedImageCache
  $Path_End_Delta=$TranscodedImageCache.length-1
  
  # A sequence of 0x00 0x00 marks the end of string. Find it.
  # The array that we are searching contains a UTF-16 string. Each character is a little-endian WORD,
  # so we can search the array's even indexes only.
  for ($i = $Path_Start_Delta; $i -lt ($TranscodedImageCache.length); $i += 2) {
    if ($TranscodedImageCache[($i+2)..($i+3)] -eq 0) {
      $Path_End_Delta=$i + 1;
      Break;
    }
  }

  # Convert the bytes holding the wallpaper path to a Unicode string
  $UnicodeObject=New-Object System.Text.UnicodeEncoding
  $WallpaperSource=$UnicodeObject.GetString($TranscodedImageCache[$Path_Start_Delta..$Path_End_Delta]);

  
  # Test item's existence
  try {
    Get-Item $WallpaperSource -Force -ErrorAction Stop | Out-Null
  }
  catch [System.Management.Automation.ItemNotFoundException] {
    $result=[System.Windows.Forms.MessageBox]::Show("Wallpaper is not found at the location Windows believes it is: `r$WallpaperSource", "Script", "OK", "Warning");
    break;
  }  
  
  # Wallpaper should by now have been found.
  # Present it to the user. If he so chooses, launch Explorer to take him were wallpaper is.
  $result=[System.Windows.Forms.MessageBox]::Show("Wallpaper location: `r$WallpaperSource`r`rLaunch Explorer?", "Script", "YesNo", "Asterisk");
  if ($result -eq "Yes")
  {
      Start-Process explorer.exe -ArgumentList "/select,`"$WallpaperSource`""
  }
}
Catch
{
  $result=[System.Windows.Forms.MessageBox]::Show("Error!`r`r"+$Error[0], "Script", "OK", "Error");
  break;
}
