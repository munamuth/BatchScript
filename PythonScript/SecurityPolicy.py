class SecurityPolicy:
    """
    Example class for handling security policy related actions.
    You can expand this class with real security checks or policy management.
    """
    def __init__(self):
        self.policies = [
            "Password must be at least 8 characters.",
            "Account lockout after 5 failed attempts.",
            "Antivirus must be enabled.",
        ]

    def get_policies(self):
        return "\n".join(self.policies)