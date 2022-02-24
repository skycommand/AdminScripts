$ServiceManager = (New-Object -ComObject "Microsoft.Update.ServiceManager")
$ServiceManager.ClientApplicationID = "My App"
$ServiceManager.RemoveService("7971f918-a847-4430-9279-4a52d1efe18d")