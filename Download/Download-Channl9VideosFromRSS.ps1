Param (
    [Parameter(Mandatory=$true)]
    [string]
    $RssUrl,
    
    [ValidateScript({Test-Path $_ -PathType 'Container'})] 
    [string]
    $DownloadFolder = '.\'
)

# Open the specified download folder
Push-Location $DownloadFolder

# Initialize the downloader
$WebClient = New-Object System.Net.WebClient

# Download the RSS
# If the download failed, throw the error into the user's face and stop the script.
# That's not an awfully polite thing to say, but that's what "throw" implies.
Write-Output 'Downloading RSS feed...'
try {
    $RSSWebObject = ([xml]($WebClient).downloadstring($RssUrl))
}
catch {
    throw
    break
}

$counter=0;
foreach ($item in $RSSWebObject.rss.channel.item) {
    $counter++

    # Channel 9 isn't perfect. Some RSS feeds are missing an enclosure or a URL.
    if ($null -eq $item.enclosure.url) {
        Write-Output $('{0:D2}: No URL found)' -f $counter)
        continue
    }
    $url = New-Object System.Uri($item.enclosure.url) -ErrorAction Stop
    $FileName = '{0:D2}. {1}' -f $counter,$url.Segments[-1]

    Write-Output $FileName
    if (!(Test-Path $FileName)) {
        # $WebClient.DownloadFile($url, $FileName)
        Invoke-WebRequest -Uri $url -OutFile $FileName -ErrorAction Stop
    }
}

Pop-Location
