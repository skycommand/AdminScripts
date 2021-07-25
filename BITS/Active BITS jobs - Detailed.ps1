#Requires -RunAsAdministrator

Get-BitsTransfer -AllUsers | Where-Object {$_.JobState -eq 'Transferring'} | Format-Custom -Property DisplayName,BytesTotal,BytesTransferred,FileList
