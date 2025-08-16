@echo off
:: Check for admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This tool requires Administrator rights.
    echo Relaunching as Administrator...
    powershell -Command "Start-Process -Verb runAs -FilePath '%~f0'"
    exit
    exit /b
)
setlocal enabledelayedexpansion

:MAIN_MENU
cls
echo.
set /p target="Enter Server (e.g., 192.168.11.254): "
set /p username="Enter Username: "

:: Secure password input (hidden typing)
echo Enter Password (hidden, loading...) 
set "psCommand=powershell -Command "$p=read-host 'Password' -AsSecureString; ^
$BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($p); ^
[System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set password=%%p

:: Add credential

cmdkey /delete:Domain:target=%target%
cmdkey /add:%target% /user:%username% /pass:%password%
explorer.exe /restart
set password=
echo.
echo Credential added successfully!
pause
