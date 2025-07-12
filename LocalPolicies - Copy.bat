@echo off
:: Auto-lock screen after 3 minutes
reg add "HKCU\Control Panel\Desktop" /v ScreenSaveTimeOut /t REG_SZ /d 180 /f
reg add "HKCU\Control Panel\Desktop" /v ScreenSaveActive /t REG_SZ /d 1 /f
reg add "HKCU\Control Panel\Desktop" /v SCRNSAVE.EXE /t REG_SZ /d "C:\Windows\System32\scrnsave.scr" /f

:: Lock account after 3 failed logins
::Locks the account after 3 incorrect password attempts.
net accounts /lockoutthreshold:3
::Account remains locked for 3 minutes.
net accounts /lockoutduration:3
::Failed login counter resets after 3 minutes without a failed attempt.
net accounts /lockoutwindow:3

:: Password policy - change every 3 months
net accounts /maxpwage:90
net accounts /minpwage:1
net accounts /uniquepw:0

net user ITAdmin admin@IT /add
net localgroup administrators ITAdmin /add
echo Local account security policies applied.
pause
