Clear
Get-BitsTransfer -AllUsers -ErrorAction Stop | ForEach-Object {
    $b=""
    $a=$_
    Switch ($a.JobState)
    {
        "Suspended" { $fgc=14; }
        "TransientError" { $fgc=12; }
        "Transferring" { $fgc=10; }
        default { $fgc=15;}
    }
    Write-Host $a.JobId
    Write-Host $a.DisplayName
    Write-Host $a.TransferType -NoNewline
    Write-Host ' | ' -NoNewline
    Write-Host $a.JobState -NoNewline -ForegroundColor $fgc -BackgroundColor Black
    Write-Host ' | ' -NoNewline
    Write-Host $a.Priority
    $b="{0:N0}" -f $a.BytesTransferred+" / "+"{0:N0}" -f $a.BytesTotal
    Write-Host $b
    Write-Host "Files:"
    ForEach-Object -InputObject $a.FileList {
        Write-Host "  Remote Name: "$_.RemoteName
        Write-Host "  Local Name:  "$_.LocalName
        $b="{0:N0}" -f $_.BytesTransferred+" / "+"{0:N0}" -f $_.BytesTotal
        Write-Host "  Progress:    "$b -NoNewline
        if ($_.IsTransferComplete) { Write-Host " (Complete)"} else { Write-Host " (Pending)" }
        Write-Host " "
    }
    Write-Host "─────────────────────────────────────────────────────────────────────────────────────────────────────────────"
}
