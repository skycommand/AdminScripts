#Requires -RunAsAdministrator
Get-AppxPackage -AllUsers | Where-Object InstallLocation -Like "*SystemApp*" | ForEach-Object {
    $a=$_
    Format-List -InputObject $a -Property Name,InstallLocation
    Add-AppxPackage -Path "$($a.InstallLocation)\AppxManifest.xml" -Register -DisableDevelopmentMode
}
