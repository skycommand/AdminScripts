#Requires -Version 5.1

<#
.SYNOPSIS
  Re-registers all packaged apps by Microsoft Corporation for the current user.
.DESCRIPTION
  Looks for all mainline packaged apps whose publishers are "cw5n1h2txyewy" (Microsoft apps) or
  "8wekyb3d8bbwe" (Windows components). Re-registers them for the current user.
.NOTES
  DEPRECATED

  This script depends on Get-AppxPackage and its Appx module. As such, it won't work in PowerShell
  6 and later.
.LINK
  None
#>

$MicrosoftPublisherIDs = @(
    "cw5n1h2txyewy", # CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US
    "8wekyb3d8bbwe"  #     CN=Microsoft Windows, O=Microsoft Corporation, L=Redmond, S=Washington, C=US
    )

Get-AppxPackage -PackageTypeFilter Main | Where-Object -Property PublisherId -In $MicrosoftPublisherIDs | ForEach-Object {
    Write-Output ('Processing {0}' -f $_.PackageFullName)
    If ($_.InstallLocation -ne $null)
    {
        $manifest=Join-Path -Path $_.InstallLocation -ChildPath "AppxManifest.xml"
        if (Test-Path $manifest){
            # Is this line even necessary? It removes the app data, but does Add-AppxPackage not?
            # Remove-AppxPackage -Package $_.PackageFullName
            Add-AppxPackage -Register -DisableDevelopmentMode -ForceApplicationShutdown -Path $manifest
        } else
        {
            Write-Verbose 'Could not locate AppxManifest.xml. Package ignored.'
        }
    }
    else
    {
        Write-Verbose 'This package has no installation location. Package ignored.'
    }
}