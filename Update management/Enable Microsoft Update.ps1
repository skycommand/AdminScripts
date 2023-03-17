#Requires -Version 5.1
#Requires -RunAsAdministrator
#I discovered the hard way that even though the following syntax is valid in PowerShell 2.0, it does
#nothing.

$ServiceManager = (New-Object -ComObject "Microsoft.Update.ServiceManager")
$ServiceManager.ClientApplicationID = "My App"
$NewUpdateService = $ServiceManager.AddService2("7971f918-a847-4430-9279-4a52d1efe18d",7,"")
Write-Output $NewUpdateService