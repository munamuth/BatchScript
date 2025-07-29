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
title Windows Update Toggle Tool
cls

:menu
cls
echo ==============================
echo     WINDOWS UPDATE TOGGLE
echo ==============================
echo 1. Enable Windows Update
echo 2. Disable Windows Update
echo 0. Exit
echo.

choice /c 120 /n /m "Select an option: "

if errorlevel 3 goto exit
if errorlevel 2 goto disable
if errorlevel 1 goto enable

:enable
echo Enabling Windows Update services...
sc config wuauserv start= auto
sc config bits start= delayed-auto
sc config dosvc start= demand
net start wuauserv
net start bits
net start dosvc
echo Windows Update has been enabled.
pause
goto menu

:disable
echo Disabling Windows Update services...
net stop wuauserv
net stop bits
net stop dosvc
sc config wuauserv start= disabled
sc config bits start= disabled
sc config dosvc start= disabled
echo Windows Update has been disabled.
pause
goto menu

:exit
echo Exiting...
exit /b
