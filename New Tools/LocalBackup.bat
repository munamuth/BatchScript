@echo off
setlocal

:: === CONFIG ===
set "src=C:\ImportantFiles"
set "dst=D:\Backups\%DATE:/=-%"

:: === CREATE DESTINATION FOLDER ===
if not exist "%dst%" mkdir "%dst%"

:: === RUN BACKUP ===
echo Backing up from %src% to %dst%...
robocopy "%src%" "%dst%" /MIR /Z /XA:H /W:1 /R:2 /TEE /LOG+:BackupLog.txt

echo Backup complete.
pause
exit /b