@echo off

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this tool as Administrator.
    powershell -Command "Start-Process -Verb runAs -FilePath '%~f0'"
    exit
)
:: Auto-lock screen after 3 minutes
reg add "HKCU\Control Panel\Desktop" /v ScreenSaveTimeOut /t REG_SZ /d 180 /f
reg add "HKCU\Control Panel\Desktop" /v ScreenSaveActive /t REG_SZ /d 1 /f
reg add "HKCU\Control Panel\Desktop" /v SCRNSAVE.EXE /t REG_SZ /d "C:\Windows\System32\scrnsave.scr" /f

:: Lock account after 3 failed logins
net accounts /lockoutthreshold:3
net accounts /lockoutduration:3
net accounts /lockoutwindow:3
net accounts /minpwlen:8

:: Password policy - change every 3 months
net accounts /maxpwage:90
net accounts /minpwage:1
net accounts /uniquepw:0

:: Create temp INF file to enforce password complexity and min length
echo Creating password policy...
> "%~dp0complexity.inf" (
    echo [System Access]
    echo PasswordComplexity = 1
    echo MinimumPasswordLength = 8
)

:: Apply password policy
secedit /configure /db "%~dp0secedit.sdb" /cfg "%~dp0complexity.inf" /quiet

:: Optional: delete temp INF file
del /f /q "%~dp0complexity.inf"

:: Create secure admin account
net user ITAdmin admin@IT /add
net localgroup administrators ITAdmin /add

echo Local account security policies applied.
pause
