#Requires -RunAsAdministrator

Get-BitsTransfer -AllUsers | Where-Object {$_.JobState -ne 'Transferred'} | Format-Custom -Property DisplayName,BytesTotal,BytesTransferred,FileList
