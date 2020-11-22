#Requires -Version 5.1
using namespace System.Management.Automation

param (
    [Parameter(Mandatory)]
    [string]
    $RssUrl,

    [Parameter()]
    [switch]
    $Download,
    
    [Parameter()]
    [ValidateScript({Test-Path -Path $_ -PathType 'Container'})] 
    [string]
    $Path = ".\"
)

# Open the specified download folder
Push-Location $Path

# Initialize the downloader
$WebClient = New-Object System.Net.WebClient

# Download the RSS
# If the download failed, raise a terminating error
Write-Output 'Downloading RSS feed...'
try {
    # $RSSWebObject = ([xml]($WebClient).downloadstring($RssUrl))
    $RSSWebObject = [xml]($WebClient.DownloadString($RssUrl))
}
catch {
    $PSCmdlet.ThrowTerminatingError(
        [ErrorRecord]::new(
            $_,
            'CouldNotGetRssFeed',
            [ErrorCategory]::ResourceUnavailable,
            $RssUrl
        )
    )
}

Write-Output 'Enumerating downloadable files...'
$counter=0;
foreach ($item in $RSSWebObject.rss.channel.item) {
    $counter++

    # Channel 9 isn't perfect. Some RSS feeds are missing an enclosure or a URL.
    if ($null -eq $item.enclosure.url) {
        Write-Output $('{0:D2}: This item contains no download URL)' -f $counter)
        continue
    }
    $url = New-Object System.Uri($item.enclosure.url) -ErrorAction Stop
    if ($Download) {
        $FileName = '{0:D2}. {1}' -f $counter,$url.Segments[-1]
        if (!(Test-Path $FileName)) {
            Write-Output "`"$FileName`": Downloading..."
            Invoke-WebRequest -Uri $url -OutFile $FileName
        } else {
            Write-Output "`"$FileName`": Already exists; won't download"
        }
    } else {
        Write-Output ('{0:D2}. {1}' -f $counter,$url)
    }
}

Pop-Location
