import sys
from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QLabel, QVBoxLayout, QWidget, QAction, QMenuBar, QMdiArea, QMdiSubWindow
)

class SecurityWidget(QWidget):
    def __init__(self):
        super().__init__()
        layout = QVBoxLayout()
        label = QLabel("Security Policy Details:\n\n- Policy 1: ...\n- Policy 2: ...")
        layout.addWidget(label)
        self.setLayout(layout)

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("PyQt5 MDI Example")
        self.resize(600, 400)

        # MDI Area
        self.mdi_area = QMdiArea()
        self.setCentralWidget(self.mdi_area)

        # Menu bar
        menubar = self.menuBar()
        file_menu = menubar.addMenu("File")

        exit_action = QAction("Exit", self)
        exit_action.triggered.connect(self.close)
        file_menu.addAction(exit_action)

        # Security menu with Security Policy submenu
        security_menu = menubar.addMenu("Security")
        security_policy_menu = security_menu.addMenu("Security Policy")

        # Example submenu action
        view_policy_action = QAction("View Policy", self)
        view_policy_action.triggered.connect(self.show_security_policy_mdi)
        security_policy_menu.addAction(view_policy_action)

    def show_security_policy_mdi(self):
        sub = QMdiSubWindow()
        sub.setWidget(SecurityWidget())
        sub.setWindowTitle("Security Policy")
        self.mdi_area.addSubWindow(sub)
        sub.show()

def main():
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())

if __name__ == "__main__":
    main()