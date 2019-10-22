Param (
    [Parameter(Mandatory=$true)]
    [string]
    $RssUrl,
    
    [ValidateScript({Test-Path $_ -PathType 'Container'})] 
    [string]
    $DownloadFolder = '.\'
)

Push-Location $DownloadFolder

$WebClient = New-Object System.Net.WebClient

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
