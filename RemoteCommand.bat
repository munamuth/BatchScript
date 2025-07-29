@echo off
set /p target=Enter remote computer name or IP: 
set /p command=Enter command to execute remotely:
set /p user=Enter username: 
set /p password=Enter password: 
echo Sending command to %target% 
psexec \\172.23.1.101 %command% -u %user% -p %password%
echo ✅ Operation completed.
pause
