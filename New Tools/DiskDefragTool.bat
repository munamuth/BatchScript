@echo off

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this tool as Administrator.
    powershell -Command "Start-Process -Verb runAs -FilePath '%~f0'"
    exit
    exit /b
)
set /p drive=Enter drive letter to defragment (e.g., C):
echo Starting Disk Defragmentation...
defrag %drive%: /U /V
pause