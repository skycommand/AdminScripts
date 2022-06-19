Try
{
  # Load Windows Forms and initialize visual styles
  [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
  [System.Windows.Forms.Application]::EnableVisualStyles()

  # Check Windows verison
  $vers=[System.Environment]::OSVersion.Version
  If (!(($vers.Major -eq 6) -and ($vers.Minor -eq 1))) {
    $result=[System.Windows.Forms.MessageBox]::Show("This operating system is not supported. This script only supports Windows NT 6.1. (i.e. Windows 7 or Windows Server 2008 R2). You seem to be running:`r`r"+[System.Environment]::OSVersion.VersionString, "Script", "OK", "Error");
    break;
  }

  # Access Windows Registry and get wallpaper path
  try {
    $WallpaperSource=(Get-ItemProperty "HKCU:\Software\Microsoft\Internet Explorer\Desktop\General" WallpaperSource -ErrorAction Stop).WallpaperSource
  }
  catch [System.Management.Automation.ItemNotFoundException],[System.Management.Automation.PSArgumentException]  {
    $result=[System.Windows.Forms.MessageBox]::Show("Windows does not seem to be holding a record of a wallpaper at this time.`r`r"+$Error[0].Exception.Message,"Script","OK","Error");
    break;
  }

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
