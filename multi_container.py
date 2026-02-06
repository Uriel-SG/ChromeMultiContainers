import customtkinter as ctk
import subprocess
import os
import uuid
import tempfile

# Configurazione Tema
ctk.set_appearance_mode("dark")
ctk.set_default_color_theme("blue")

class ContainerApp(ctk.CTk):
    def __init__(self):
        super().__init__()

        self.title(" Chrome Container Manager")
        self.geometry("400x550")
        self.resizable(False, False)

        # Percorso dinamico per l'icona
        script_dir = os.path.dirname(os.path.abspath(__file__))
        icon_path = os.path.join(script_dir, "ChromeContainers.ico")
        if os.path.exists(icon_path):
            self.iconbitmap(icon_path)

        self.containers = {
            "Personal": {"color": "#3B8ED0", "dir": "Personal_Session"},
            "Work": {"color": "#2FA572", "dir": "Work_Session"},
            "Developer": {"color": "#1F538D", "dir": "Dev_Session"},
            "Tester": {"color": "#707070", "dir": "Tester_Session"},
            "Anonymous": {"color": "#2B2B2B", "dir": "TEMP"}
        }

        self.label = ctk.CTkLabel(self, text="CHROME CONTAINERS", font=ctk.CTkFont(size=20, weight="bold"))
        self.label.pack(pady=(30, 20))

        for name, info in self.containers.items():
            btn = ctk.CTkButton(
                self, 
                text=name.upper(), 
                command=lambda n=name: self.launch_chrome(n),
                fg_color=info["color"],
                hover_color=self.adjust_color(info["color"], 0.2),
                font=ctk.CTkFont(size=13, weight="bold"),
                height=45, width=280, corner_radius=10
            )
            btn.pack(pady=10)

        self.footer = ctk.CTkLabel(self, text="Storage: C:\\ChromeContainers", font=ctk.CTkFont(size=10, slant="italic"), text_color="gray")
        self.footer.pack(side="bottom", pady=20)

    def adjust_color(self, hex_color, factor):
        hex_color = hex_color.lstrip('#')
        rgb = tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))
        new_rgb = tuple(min(255, int(c + (255 - c) * factor)) for c in rgb)
        return '#%02x%02x%02x' % new_rgb

    def launch_chrome(self, name):
        chrome_path = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
        if not os.path.exists(chrome_path):
            chrome_path = os.path.expanduser(r"~\AppData\Local\Google\Chrome\Application\chrome.exe")
            
        base_dir = r"C:\ChromeContainers"
        
        if name == "Anonymous":
            user_data_dir = os.path.join(tempfile.gettempdir(), f"chrome_anon_{uuid.uuid4().hex[:6]}")
        else:
            user_data_dir = os.path.join(base_dir, self.containers[name]["dir"])
        
        os.makedirs(user_data_dir, exist_ok=True)
        subprocess.Popen([chrome_path, f"--user-data-dir={user_data_dir}", f"--window-name=Chrome {name}", "--no-first-run", "--no-default-browser-check"])

if __name__ == "__main__":
    app = ContainerApp()
    app.mainloop()