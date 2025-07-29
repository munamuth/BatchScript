@echo off

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this tool as Administrator.
    powershell -Command "Start-Process -Verb runAs -FilePath '%~f0'"
    exit
    exit /b
)
echo Starting System File Checker...
:: Run System File Checker to repair system files
sfc /scannow