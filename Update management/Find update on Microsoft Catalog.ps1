#Requires -Version 5.1

<#
.SYNOPSIS
    Finds an update package on Microsoft Catalog and returns its ID.
.DESCRIPTION
    This cmdlet queries the Microsoft Catalog website using your query string. The site returns the
    update packages matching your query. This cmdlet display the name and ID of each search result.
    Use the ID to import the package into WSUS.
.EXAMPLE
    PS C:\> Find-MicrosoftUpdate -Query "5003537 2021-07 21H1"

    Name : 2021-07 Cumulative Update for .NET Framework 3.5 and 4.8 for Windows 10 Version 21H1 for x64 (KB5003537)
    ID   : 905a83e1-ec55-4d69-842b-d95ad77a4f56

    Name : 2021-07 Cumulative Update for .NET Framework 3.5 and 4.8 for Windows 10 Version 21H1 for ARM64 (KB5003537)
    ID   : ab9bb3ce-1cab-4aac-8c1f-292fdbe150e8

    Name : 2021-07 Cumulative Update for .NET Framework 3.5 and 4.8 for Windows 10 Version 21H1 (KB5003537)
    ID   : c9435bbf-e563-4feb-b43f-9c9200c6fdea
.EXAMPLE
    PS C:\> Find-MicrosoftUpdate -Query "5003537 2021-07 21H1"
    PS C:\> $wsus = Get-WsusServer
    PS C:\> $wsus.ImportUpdateFromCatalogSite('c9435bbf-e563-4feb-b43f-9c9200c6fdea', 'windows10.0-kb5003537-x64-ndp48.msu')

    To add a .msu file to your WSUS inventory, you need its ID. This script helps you find that ID.
    Once you have both the .msu file and the ID, you can import that package as shown above.
.NOTES
    Special thanks to Wolfgang Sommergut for his educational article.
#>

using namespace System.Management.Automation

[CmdletBinding()]
param()

function Find-MicrosoftUpdate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]
        $Query
    )

    Set-StrictMode -Version Latest

    <# Encode the query
    WebUtility.UrlEncode() is superior to HttpUtility.UrlEncode() and Uri.EscapeUriString()
    See here: https://stackoverflow.com/a/16894322
    Also, try to encode the following: '"David''s armor"'
    #>
    $QueryString = [System.Net.WebUtility]::UrlEncode($Query)

    # Send query to Microsoft Catalog and get the results
    $QueryUrl = "https://www.catalog.update.microsoft.com/Search.aspx?q=$QueryString"
    $uc = Invoke-WebRequest -UseBasicParsing -Uri $QueryUrl -ErrorAction Stop
    if ($null -eq $uc) { break }

    # Parse the results and separate the updates
    $Updates = $uc.Links | Where-Object onClick -Like "*goToDetails*" -ErrorAction Ignore
    if ($null -eq $Updates) {
        $PSCmdlet.ThrowTerminatingError(
            [ErrorRecord]::new(
                [System.Exception]::new("Microsoft Catalog did not find any results for $Query"),
                'FoundNothingMatchingQuery',
                [ErrorCategory]::ObjectNotFound,
                $QueryUrl
            )
        )
    }

    # Extract the name and ID from the updates
    $Updates | ForEach-Object { ($_.outerHTML -replace '(<a id=.*?>|</a>)|\s{2,}', '') + ";" + $_.id -replace '_link', '' } | ConvertFrom-Csv -Delimiter ";" -Header "Name", "ID" | Format-List
}

Find-MicrosoftUpdate @args
