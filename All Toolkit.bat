@echo off
:menu
cls
color 2F
echo ===========================
echo      All Toolkit Menu
echo ===========================
echo 1. System Info
echo 2. Reset Network Stack
echo 3. Windows Update Tool
echo 4. Disk Cleanup Tool
echo 5. Remote Command Execution
echo 6. Local Policy
echo 7. System File Checker
echo 8. Time Sync / NTP Fix
echo 9. Disk Defragmentation
echo 0. Exit
echo.
set /p choice="Select an option (0-9): "
if "%choice%"=="9" goto option9
if "%choice%"=="8" goto option8
if "%choice%"=="7" goto option7
if "%choice%"=="6" goto option6
if "%choice%"=="5" goto option5
if "%choice%"=="4" goto option4
if "%choice%"=="3" goto option3
if "%choice%"=="2" goto option2
if "%choice%"=="1" goto option1
if "%choice%"=="0" goto exit
:option1
    start msinfo32
goto menu

:option2
echo Resetting network stack...
ipconfig /release
ipconfig /flushdns
ipconfig /renew
netsh winsock reset
netsh int ip reset
pause
goto menu

:option3
echo Launching Windows Update Tool...
start "" "WindowsUpdateTool.bat"
pause
goto menu

:option4
echo Launching Disk Cleanup Tool...
start "" "DiskCleanupTool.bat"
pause
goto menu
:option5
cls
color 0F
echo Starting Remote Command Execution...
set /p target=Enter remote computer name or IP: 
set /p command=Enter command to execute remotely:
set /p user=Enter username: 
set /p password=Enter password: 
echo Sending command to %target% 
psexec \\%target% %command% -u %user% -p %password%
echo ✅ Operation completed.
pause
goto menu

:option6
echo Starting Local Policy...
start "" "LocalPolicies.bat"
pause
goto menu

:option7
start "" "sfc.bat"
pause
goto menu

:option8
echo Starting Time Sync / NTP Fix...
net stop w32time
w32tm /unregister
w32tm /register
net start w32time
w32tm /resync
echo Time sync completed.
pause
goto menu

:option9
echo Starting Disk Defragmentation...
start "" "DiskDefragTool.bat"
goto menu


:exit
echo Exiting...
exit /b