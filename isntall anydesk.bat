echo on
:: 1. Define Variables
set REMOTE_IP=CBK-0400
set LOCAL_INSTALLER=C:\temp\Anydesk.exe
set REMOTE_PATH=\\%REMOTE_IP%\C$\Temp\anydesk.exe

:: 2. Copy installer to remote PC
echo Copying installer to remote PC...
copy "%LOCAL_INSTALLER%" "%REMOTE_PATH%"

:: 3. Run installer silently with admin rights
echo Running silent install via PsExec...
PsExec \\%REMOTE_IP% -h -d "C:\temp\Anydesk.exe" --install

:: 4. (Optional) Check if AnyDesk service is running
echo Checking if AnyDesk installed and service is running...
PsExec \\%REMOTE_IP%  sc query AnyDesk