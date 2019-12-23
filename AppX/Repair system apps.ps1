Invoke-Expression "dism /online /Cleanup-Image /RestoreHealth"
Invoke-Expression "sfc /scannow"
Get-AppxPackage -AllUsers | Where-Object InstallLocation -Like "*SystemApp*" | ForEach-Object {
    $a=$_
    Format-List -InputObject $a -Property Name,InstallLocation
    Add-AppxPackage -Path "$($a.InstallLocation)\AppxManifest.xml" -Register -DisableDevelopmentMode
}