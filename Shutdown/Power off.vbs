Const EVENT_SUCCESS = 0
Set objShell = Wscript.CreateObject("Wscript.Shell")
objShell.LogEvent EVENT_SUCCESS, "Shutdown via script"


Const LOGOFF = 0
Const SHUTDOWN = 1
Const REBOOT = 2
Const POWEROFF = 8

Const LOGOFF_FORCE = 4
Const SHUTDOWN_FORCE = 5
Const REBOOT_FORCE = 6
Const POWEROFF_FORCE = 12

strComputer = "."
Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate,(Shutdown)}!\\" & strComputer & "\root\cimv2")
Set colOperatingSystems = objWMIService.ExecQuery ("SELECT * FROM Win32_OperatingSystem")
For Each objOperatingSystem in colOperatingSystems
 ObjOperatingSystem.Win32Shutdown(POWEROFF)
Next
