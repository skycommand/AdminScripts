Option Explicit
Dim objWMIService, colItems, WshNetwork, strComputer
Dim objUser, objItem, dtmLastLogin, strLogonInfo
Set WshNetwork = CreateObject("Wscript.Network")
strComputer = WshNetwork.ComputerName

Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery _
("Select * from Win32_UserAccount Where Domain = '" & strComputer & "'")

For Each objItem in colItems
	dtmLastLogin = ""
	On Error Resume Next
	Set objUser = GetObject("WinNT://" & strComputer _
    	& "/" & objItem.Name & ",user")
	dtmLastLogin = objUser.lastLogin
	On Error Goto 0

	strLogonInfo = strLogonInfo & vbCrLf & objItem.Name & ": " & dtmLastLogin
Next
MsgBox strLogonInfo, vbOKOnly + vbInformation, "Last Logon Information for Local Users"