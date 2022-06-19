@echo off
set a=%localappdata%\IconCache.db
echo The following file will be scheduled for deletion:
echo   %a%
echo.
set /p prompt=Do you want to continue? (Type 'y' to indicate consent) 
echo.
if "%prompt%"=="y" (
  "C:\Program Files\Microsoft Sysinternals\movefile.exe" %a% ""
  )
pause