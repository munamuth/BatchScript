@echo off
setlocal enabledelayedexpansion

:: Check if script was elevated via UAC prompt for Option 3
if "%~1"=="ELEVATED_OPTION3" goto OPTION3_EXEC

:MENU
cls
echo ============================================================
echo                    NETWORK UTILITY MENU
echo ============================================================
echo [1] Get Local (Private) IP
echo [2] Get Public IP
echo [3] Release and Renew IP (Requires Administrator)
echo [4] Get All IPs (Local + Public)
echo [5] Exit
echo ============================================================
set /p CHOICE="Enter option [1-5]: "

if "%CHOICE%"=="1" goto OPTION1
if "%CHOICE%"=="2" goto OPTION2
if "%CHOICE%"=="3" goto CHECK_ADMIN_OPTION3
if "%CHOICE%"=="4" goto OPTION4
if "%CHOICE%"=="5" exit /b
echo Invalid option, please try again.
timeout /t 2 >nul
goto MENU

:OPTION1
cls
echo ============================================================
echo LOCAL (PRIVATE) IP ADDRESS
echo ============================================================
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set "PRIV_IP=%%A"
    set "PRIV_IP=!PRIV_IP:~1!"
    echo Private IP: !PRIV_IP!
)
echo.
pause
goto MENU

:OPTION2
cls
echo ============================================================
echo PUBLIC IP ADDRESS
echo ============================================================
set "PUB_IP="
for /f "usebackq tokens=*" %%I in (`powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadString('https://api.ipify.org').Trim()"`) do set "PUB_IP=%%I"

if defined PUB_IP (
    echo Public IP: %PUB_IP%
) else (
    echo Public IP: Failed to retrieve (check internet or firewall)
)
echo.
pause
goto MENU

:OPTION4
cls
echo ============================================================
echo NETWORK IP INFORMATION
echo ============================================================
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set "PRIV_IP=%%A"
    set "PRIV_IP=!PRIV_IP:~1!"
    echo Local IP  : !PRIV_IP!
)

set "PUB_IP="
for /f "usebackq tokens=*" %%I in (`powershell -NoProfile -Command "[Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadString('https://api.ipify.org').Trim()"`) do set "PUB_IP=%%I"

if defined PUB_IP (
    echo Public IP : %PUB_IP%
) else (
    echo Public IP : Failed to retrieve
)
echo.
pause
goto MENU

:CHECK_ADMIN_OPTION3
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo Releasing/Renewing IP requires Administrator rights.
    echo Requesting elevation...
    powershell -Command "Start-Process -FilePath '%~f0' -ArgumentList 'ELEVATED_OPTION3' -Verb RunAs"
    goto MENU
)

:OPTION3_EXEC
cls
echo ============================================================
echo RELEASING AND RENEWING IP ADDRESS...
echo ============================================================
echo Releasing current IP leases...
ipconfig /release >nul 2>&1

echo Flushing DNS cache...
ipconfig /flushdns >nul 2>&1

echo Requesting new IP leases...
ipconfig /renew >nul 2>&1

echo.
echo UPDATED LOCAL IP ADDRESS(ES):
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set "NEW_PRIV_IP=%%A"
    set "NEW_PRIV_IP=!NEW_PRIV_IP:~1!"
    echo New Local IP: !NEW_PRIV_IP!
)
echo.
echo Renewal complete.
pause
if "%~1"=="ELEVATED_OPTION3" exit
goto MENU