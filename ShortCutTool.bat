@echo off
:menu
cls
echo ====================================
echo      Windows System Management
echo ====================================
echo 1. Open Classic Devices and Printers
echo 2. Open Device Manager
echo 3. Open Disk Management
echo 4. Open Network Connections
echo 5. Open Credential Manager
echo 6. Open Services
echo 0. Exit
echo ====================================
set /p choice="Select an option (0-6): "

if "%choice%"=="1" start shell:::{A8A91A66-3A7D-4424-8D24-04E180695C7A} & goto menu
if "%choice%"=="2" start devmgmt.msc & goto menu
if "%choice%"=="3" start diskmgmt.msc & goto menu
if "%choice%"=="4" start ncpa.cpl & goto menu
if "%choice%"=="5" start control /name Microsoft.CredentialManager & goto menu
if "%choice%"=="6" start services.msc & goto menu
if "%choice%"=="0" exit

echo Invalid choice, please try again.
pause
goto menu