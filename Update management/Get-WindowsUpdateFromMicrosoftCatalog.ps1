#Requires -Version 5.1
using namespace System.Management.Automation

function Public_Void_Main {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]
        $Query
    )
        
    Set-StrictMode -Version Latest

    # Encode the query
    <# WebUtility.UrlEncode() is superior to HttpUtility.UrlEncode() and Uri.EscapeUriString()
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

Public_Void_Main @args
