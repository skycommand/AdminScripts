#Requires -Version 5.1
(New-Object -ComObject Microsoft.Update.ServiceManager).Services | Format-Table -Property Name,IsDefaultAUService