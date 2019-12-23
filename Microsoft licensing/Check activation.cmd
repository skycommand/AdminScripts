@echo off
set folder=%~dp0
pushd "%~dp0"
chcp 866
color 1F
setLocal EnableDelayedExpansion
if exist "%Windir%\Sysnative\sppsvc.exe" set SysPath=%Windir%\Sysnative
if exist "%Windir%\System32\sppsvc.exe"  set SysPath=%Windir%\System32

cls
echo --------------------------------------------------------------------------
echo Windows Status:
echo --------------------------------------------------------------------------
cscript %SysPath%\slmgr.vbs /dli
pause

cls
echo --------------------------------------------------------------------------
echo Office 2013 Status
echo --------------------------------------------------------------------------
set office=
echo Searching Windows Registry...
FOR /F "tokens=2*" %%a IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\15.0\Common\InstallRoot" /v "Path"') do (SET office=%%b)
if exist "%office%\OSPP.VBS" (
						cd /d "%office%"
						cscript ospp.vbs /dstatus
						cd /d "%~dp0"
						)

echo.
echo.
set office=
echo Searching Windows Registry (WoW64)...
FOR /F "tokens=2*" %%a IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Office\15.0\Common\InstallRoot" /v "Path"') do (SET office=%%b)
if exist "%office%\OSPP.VBS" (
						cd /d "%office%"
						cscript ospp.vbs /dstatus
						cd /d "%~dp0"
						)
pause

cls						
echo --------------------------------------------------------------------------
echo Office 2010 Status:
echo --------------------------------------------------------------------------
set office=
echo Searching Windows Registry...
FOR /F "tokens=2*" %%a IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\14.0\Common\InstallRoot" /v "Path"') do (SET office=%%b)
if exist "%office%\OSPP.VBS" (
						cd /d "%office%"
						cscript ospp.vbs /dstatus
						cd /d "%~dp0"
						)

echo.
echo.
set office=
echo Searching Windows Registry (WoW64)...
FOR /F "tokens=2*" %%a IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Office\14.0\Common\InstallRoot" /v "Path"') do (SET office=%%b)
if exist "%office%\OSPP.VBS" (
						cd /d "%office%"
						cscript ospp.vbs /dstatus
						cd /d "%~dp0"
						)
pause