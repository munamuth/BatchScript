import tkinter as tk

def fnCleanUpTemp():
    # Simulate list of temp files
    files = [
        "C:/Temp/file1.tmp",
        "C:/Temp/log.txt",
        "C:/Windows/Temp/data.cache"
    ]

    # Clear previous widgets in right container
    for widget in rightContainer.winfo_children():
        widget.destroy()

    # Add a title label
    tk.Label(rightContainer, text="Files to Delete:", font=("Arial", 12, "bold")).pack(anchor="w", padx=10, pady=5)

    # Show each file
    for file in files:
        tk.Label(rightContainer, text=file, anchor="w").pack(fill="x", padx=15)

# Create window
root = tk.Tk()
root.title("IT Toolkit")
root.geometry("600x400")

# Left container with fixed width
leftContainer = tk.Frame(root, bg="lightblue", width=200)
leftContainer.pack(side=tk.LEFT, fill=tk.Y)
leftContainer.pack_propagate(False)

# Menu buttons
btnLocalSecurity = tk.Button(leftContainer, text="Local Security Policy", width=20)
btnLocalSecurity.pack(pady=5, padx=5)
btnCleanUpTemp = tk.Button(leftContainer, text="Clean Up Temporary Files", command=fnCleanUpTemp, width=20)
btnCleanUpTemp.pack(pady=5, padx=5)

# Right container (dynamic content)
rightContainer = tk.Frame(root, bg="white")
rightContainer.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

root.mainloop()
