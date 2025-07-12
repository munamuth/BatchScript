
@echo off
title IT Support Toolkit
color 1F

:MENU
cls
echo ================================================
echo             WELCOME TO MY TOOLKITS
echo ================================================
echo 1. Enable
echo 2. Disable
echo 0. Exit 
echo ================================================
set /p choice=Enter your choice: 

if %choice%==1 goto Enable
if %choice%==2 goto Disable
if %choice%==0 goto Exit
:Disable
echo Disabling Windows Update service...
sc stop wuauserv >nul 2>&1
sc stop wuauserv >nul 2>&1 >> %userprofile%\Documents\ITToolkitsLog.txt
sc config wuauserv start= disabled >nul 2>&1
sc config wuauserv start= disabled >nul 2>&1 >> %userprofile%\Documents\ITToolkitsLog.txt

echo Disabling Windows Update Medic service...
sc stop WaaSMedicSvc >nul 2>&1
sc stop WaaSMedicSvc >nul 2>&1 >> %userprofile%\Documents\ITToolkitsLog.txt
sc config WaaSMedicSvc start= disabled >nul 2>&1
sc config WaaSMedicSvc start= disabled >nul 2>&1 >> %userprofile%\Documents\ITToolkitsLog.txt

echo Disabling update-related scheduled tasks...
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable >nul 2>&1 >> %userprofile%\Documents\ITToolkitsLog.txt
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sih" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sih" /Disable >nul 2>&1 >> %userprofile%\Documents\ITToolkitsLog.txt
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sihboot" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sihboot" /Disable >nul 2>&1 >> %userprofile%\Documents\ITToolkitsLog.txt

echo ✅ Windows Update has been disabled.
pause
goto MENU

:: 8 - Enable Windows Update
:Enable
echo Enabling Windows Update service...
sc config wuauserv start= auto >nul 2>&1
sc config wuauserv start= auto >nul 2>&1 >> %userprofile%\Documents\ITToolkitsLog.txt
sc start wuauserv >nul 2>&1
sc start wuauserv >nul 2>&1 >> %userprofile%\Documents\ITToolkitsLog.txt

echo Enabling Windows Update Medic service...
sc config WaaSMedicSvc start= demand >nul 2>&1
sc config WaaSMedicSvc start= demand >nul 2>&1 >> %userprofile%\Documents\ITToolkitsLog.txt

echo Enabling update-related scheduled tasks...
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /Enable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /Enable >nul 2>&1 >> %userprofile%\Documents\ITToolkitsLog.txt
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sih" /Enable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sih" /Enable >nul 2>&1 >> %userprofile%\Documents\ITToolkitsLog.txt
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sihboot" /Enable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sihboot" /Enable >nul 2>&1 >> %userprofile%\Documents\ITToolkitsLog.txt

echo ✅ Windows Update has been enabled.
pause
:Exit
exit
goto MENU
