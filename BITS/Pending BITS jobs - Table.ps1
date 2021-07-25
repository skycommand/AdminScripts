#Requires -RunAsAdministrator

Get-BitsTransfer -AllUsers | Where-Object {$_.JobState -ne 'Transferred'} | Format-Table -Autosize -Property DisplayName,BytesTotal,BytesTransferred,FileList
