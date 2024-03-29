#Requires -RunAsAdministrator

Get-BitsTransfer -AllUsers | Where-Object {$_.JobState -eq 'Transferring'} | Format-Table -Autosize -Property DisplayName,BytesTotal,BytesTransferred,FileList
