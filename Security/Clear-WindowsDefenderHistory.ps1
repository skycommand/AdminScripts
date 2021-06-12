#Requires -RunAsAdministrator

Remove-Item 'C:\ProgramData\Microsoft\Windows Defender\Scans\History\Service' -Recurse -Force

& wevtutil.exe clear-log 'Microsoft-Windows-Windows Defender/Operational' 
