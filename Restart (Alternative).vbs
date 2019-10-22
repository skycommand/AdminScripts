Const EVENT_SUCCESS = 0
Set objShell = Wscript.CreateObject("Wscript.Shell")
objShell.LogEvent EVENT_SUCCESS, "Shutdown via script"


strComputer = "."
Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate,(Shutdown)}!\\" & strComputer & "\root\cimv2")
Set colOperatingSystems = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")
For Each objOperatingSystem in colOperatingSystems
    ObjOperatingSystem.Reboot()
Next
