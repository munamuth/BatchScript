import psutil
import subprocess
import tkinter as tk
import os
import sys
import ctypes
import shutil
from tkinter import simpledialog, messagebox

# Check for admin rights
def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

if not is_admin():
    ctypes.windll.shell32.ShellExecuteW(
        None, "runas", sys.executable, " ".join(sys.argv), None, 1)
    sys.exit()

# Kill process function
def killProcess():
    processName = simpledialog.askstring("Kill Process", "Process name (e.g., notepad.exe):")
    if processName:
        found = False
        for process in psutil.process_iter(['name']):
            try:
                if process.info['name'] and process.info['name'].lower() == processName.lower():
                    process.kill()
                    found = True
                    messagebox.showinfo("Success", f"Killed process: {processName}")
                    break
            except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
                continue
        if not found:
            messagebox.showwarning("Not Found", f"No process named {processName} found.")

# Add admin user
def fnAddUser():
    username = "ITAdmin"
    password = "admin@IT"
    cmd = f'net user "{username}" "{password}" /add'
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.returncode == 0:
        cmd2 = f'net localgroup administrators {username} /add'
        result2 = subprocess.run(cmd2, shell=True, capture_output=True, text=True)
        if result2.returncode == 0:
            messagebox.showinfo("Success", f"User '{username}' added successfully.")
        else:
            messagebox.showerror("Error", f"User created but failed to add to administrators.\n{result2.stderr}")
    else:
        messagebox.showerror("Error", f"Failed to add user.\n{result.stderr}")

# Apply security policies
def fnSetLocalPolicy():
    inf_path = os.path.join(os.path.dirname(__file__), "complexity.inf")
    commands = [
        r'reg add "HKCU\Control Panel\Desktop" /v ScreenSaveTimeOut /t REG_SZ /d 180 /f',
        r'reg add "HKCU\Control Panel\Desktop" /v ScreenSaveActive /t REG_SZ /d 1 /f',
        r'reg add "HKCU\Control Panel\Desktop" /v SCRNSAVE.EXE /t REG_SZ /d "C:\Windows\System32\scrnsave.scr" /f',
        "net accounts /lockoutthreshold:3",
        "net accounts /lockoutduration:3",
        "net accounts /lockoutwindow:3",
        "net accounts /maxpwage:90",
        "net accounts /minpwage:1",
        "net accounts /uniquepw:0",
        f'secedit /configure /db secedit.sdb /cfg "{inf_path}" /quiet'
    ]

    errors = []
    for cmd in commands:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        if result.returncode != 0:
            errors.append(f"Command failed:\n{cmd}\nError: {result.stderr.strip()}")

    if errors:
        messagebox.showerror("Policy Errors", "\n\n".join(errors))
    else:
        messagebox.showinfo("Success", "Local account security policies applied.")
def fnCleanTemp():
    temp_dirs = [
        os.environ.get("TEMP", ""),
        r"C:\Windows\Temp"
    ]

    errors = []

    for temp_dir in temp_dirs:
        if os.path.exists(temp_dir):
            for root, dirs, files in os.walk(temp_dir, topdown=False):
                for name in files:
                    try:
                        os.remove(os.path.join(root, name))
                    except Exception as e:
                        errors.append(str(e))
                for name in dirs:
                    try:
                        shutil.rmtree(os.path.join(root, name), ignore_errors=True)
                    except Exception as e:
                        errors.append(str(e))

    if errors:
        messagebox.showerror("Cleanup Errors", f"Some files could not be deleted:\n{len(errors)} issues")
    else:
        messagebox.showinfo("Success", "Temporary files cleaned successfully.")


def fnDisableWindowUpdate():
    try:
        cmds = [
            "sc stop wuauserv",
            "sc config wuauserv start= disabled"
        ]

        errors = []
        for cmd in cmds:
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            if result.returncode != 0:
                errors.append(f"Command failed: {cmd}\n{result.stderr.strip()}")

        if errors:
            messagebox.showerror("Windows Update", "\n\n".join(errors))
        else:
            messagebox.showinfo("Success", "Windows Update has been disabled.")
    except Exception as e:
        messagebox.showerror("Error", str(e))
# GUI Setup
app = tk.Tk()
app.title("IT Toolkits")
app.geometry("490x250")

btnKillProcess = tk.Button(app, text="Kill Process", command=killProcess, font=("Arial", 12))
btnKillProcess.place(x=10, y=10, width=150)

btnAddUser = tk.Button(app, text="Add User", command=fnAddUser, font=("Arial", 12))
btnAddUser.place(x=170, y=10, width=150)

btnApplyPolicy = tk.Button(app, text="Security Policies", command=fnSetLocalPolicy, font=("Arial", 12))
btnApplyPolicy.place(x=330, y=10, width=150)

btnCleanTemp = tk.Button(app, text="Clean Temp", command=fnCleanTemp, font=("Arial", 12), width=15)
btnCleanTemp.place(x=10, y=45, width=150)


btnDisableWindowsUpdate = tk.Button(app, text="Disable WinUpdate", command=fnDisableWindowUpdate, font=("Arial", 12))
btnDisableWindowsUpdate.place(x=170, y=45, width=150)

btnDisableWindowsUpdate = tk.Button(app, text="Enable WinUpdate", command=fnDisableWindowUpdate, font=("Arial", 12))
btnDisableWindowsUpdate.place(x=330, y=45, width=150)



app.mainloop()
