@echo off
title Disk Cleanup Tool
color 1F

:: Require admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this tool as Administrator.
    powershell -Command "Start-Process -Verb runAs -FilePath '%~f0'"
    exit
)

echo Cleaning temporary files...

:: Delete user temp
del /f /s /q "%temp%\*"
rd /s /q "%temp%"

:: Delete Windows temp
del /f /s /q "C:\Windows\Temp\*"
rd /s /q "C:\Windows\Temp"

:: Delete prefetch files
del /f /s /q "C:\Windows\Prefetch\*"

:: Empty Recycle Bin
echo Emptying Recycle Bin...
powershell -Command "Clear-RecycleBin -Force"

:: Delete Windows Update cache
echo Clearing Windows Update cache...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
rd /s /q "C:\Windows\SoftwareDistribution\Download"
net start wuauserv >nul 2>&1
net start bits >nul 2>&1

:: Launch Disk Cleanup GUI (optional)
echo Launching Disk Cleanup GUI...
cleanmgr /sagerun:1

echo.
echo ✅ Cleanup completed.
pause
exit /b
