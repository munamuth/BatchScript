import sys
import subprocess
from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QPushButton, QVBoxLayout, QWidget, QTextEdit, QLabel
)
from SecurityPolicy import SecurityPolicy

class ITToolKit(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("IT Tool Kit")
        self.setGeometry(100, 100, 500, 400)

        # Widgets
        self.output = QTextEdit(self)
        self.output.setReadOnly(True)
        self.label = QLabel("Select a tool:", self)

        # Buttons
        self.ping_btn = QPushButton("Ping google.com", self)
        self.ipconfig_btn = QPushButton("Show IP Config", self)
        self.sysinfo_btn = QPushButton("System Info", self)
        self.policy_btn = QPushButton("Show Security Policy", self)

        # Layout
        layout = QVBoxLayout()
        layout.addWidget(self.label)
        layout.addWidget(self.ping_btn)
        layout.addWidget(self.ipconfig_btn)
        layout.addWidget(self.sysinfo_btn)
        layout.addWidget(self.policy_btn)
        layout.addWidget(self.output)

        

        container = QWidget()
        container.setLayout(layout)
        self.setCentralWidget(container)

        # Connections
        self.ping_btn.clicked.connect(self.ping)
        self.ipconfig_btn.clicked.connect(self.show_ipconfig)
        self.sysinfo_btn.clicked.connect(self.show_sysinfo)
        self.policy_btn.clicked.connect(self.show_policy)

        self.security_policy = SecurityPolicy()

    def ping(self):
        result = subprocess.getoutput("ping -n 4 google.com")
        self.output.setText(result)

   
    def show_ipconfig(self):
        result = subprocess.getoutput("ipconfig")
        self.output.setText(result)

    def show_sysinfo(self):
        result = subprocess.getoutput("systeminfo")
        self.output.setText(result)

    def show_policy(self):
        policies = self.security_policy.get_policies()
        self.output.setText("Security Policies:\n" + "\n".join(policies))

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = ITToolKit()
    window.show()
    sys.exit(app.exec_())