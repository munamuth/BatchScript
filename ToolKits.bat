@echo off
title IT Support Toolkit
color 2F

:MENU
cls
echo ================================================
echo             WELCOME TO MY TOOLKITS
echo ================================================
echo 1. Computer Policies
echo 2. Run Disk Cleanup
echo 3. Defragment Drive
echo 4. Windows Update
echo 5. Install Anydesk
echo 0. Exit 
echo ================================================
set /p choice=Enter your choice: 

if %choice%==1 goto ComputerPolicies
if %choice%==2 goto DiskCleanup
if %choice%==3 goto DefragmentDrive
if %choice%==4 goto WindowsUpdate
if %choice%==5 goto Anydesk

:ComputerPolicies
echo Starting Computer Policies
start  "" "%~dp0LocalPolicies.bat
pause
goto MENU
:DiskCleanup
echo Starting Disk Cleanup
cleanmgr
pause
goto MENU

:DefragmentDrive
echo Starting Defragment Drive
wmic logicaldisk get name
set /p drive=Enter drive letter (e.g., C): 
defrag %drive%: /U /V
pause
goto MENU

:WindowsUpdate
start  "" "%~dp0WindowsUpdate.bat
pause
goto MENU

:Anydesk
echo Installing AnyDesk silently...

:: Install AnyDesk silently and wait for it to finish
"%~dp0AnydeskV5.exe" --install --silent

:: Optional: wait a few seconds to ensure installation completes
timeout /t 5 /nobreak >nul

:: Start AnyDesk after installation
start "" "C:\Program Files (x86)\AnyDesk\AnyDesk.exe"

pause
goto MENU

pause