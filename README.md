# ChromeMultiContainers
Multi Containers for Chrome

<img width="313" height="319" alt="ChromeContainers" src="https://github.com/user-attachments/assets/28efbbf2-7e58-48f1-b8a7-5c157cb6d7e5" />

### *The "Firefox Containers" experience, finally on Google Chrome.*

[![Python Version](https://img.shields.io/badge/python-3.x-blue.svg)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![UI: CustomTkinter](https://img.shields.io/badge/UI-CustomTkinter-orange.svg)](https://github.com/TomSchimansky/CustomTkinter)

For years, **Firefox** users have held a strategic advantage: *Multi-Account Containers*. The ability to fully isolate tabs and sessions (Social, Work, Banking) within the same browser window is a "killer feature" that Chrome never natively implemented, forcing users to constantly switch profiles or use limited Incognito windows.

**ChromeMultiContainers** is the solution that brings this level of total isolation to Google Chrome, allowing you to manage multiple persistent or volatile sessions with a single click.

---

## ⚖️ A Note on "Intellectual Honesty"
It is important to clarify: **this is not an integrated browser extension** like Firefox Containers. While Firefox manages isolation internally via tab-level containers, Chrome's architecture doesn't allow for the exact same behavior. 

Instead, this tool manages isolation **externally** by launching separate Chrome instances with dedicated data directories. While different in execution, it is **the closest possible experience to Firefox Containers available for Chrome**, and it works flawlessly for seamless multi-account management.

---

## 🚀 How It Works
**ChromeMultiContainers** is a lightweight manager built in Python that acts as an "orchestrator" for Chrome instances. 

It instructs the browser to create and use entirely separate **User Data Directories**. This ensures that each container has its own independent:
* ✅ **Cookies & Sessions:** Log into 5 different Gmail or Social accounts simultaneously.
* ✅ **History & Preferences:** Keep your work searches away from your personal ones.
* ✅ **Browser Cache:** No data leakage between containers.

### 📂 Storage & Installation
To keep your system clean and organized, all persistent session data is stored centrally in:
`C:\ChromeContainers`  
*(The application itself and its launcher are typically located in `C:\ChromeMulticontainers`)*.

---

## 🕵️ The "ANONYMOUS" Container: Beyond Incognito
While standard Chrome Incognito mode still shares some data between all open private windows, the **ANONYMOUS** session in this tool sets a new standard for privacy:

1. **Total Isolation:** Every time you click "Anonymous", the script generates a unique `UUID` (Unique ID).
2. **Infinite Instances:** You can open 10 different Anonymous sessions; each will be a "virgin" browser instance with zero connection to the others.
3. **Self-Destruction:** Data is saved in the system's temporary folder and is automatically discarded, leaving no trace in your main storage folder.

---

## 🛠️ Technical Features
* **CustomTkinter UI:** A modern, dark-themed interface that blends perfectly with Windows 10/11.
* **Subprocess Management:** Advanced handling of Chrome processes using the `--user-data-dir` flag.
* **Dynamic Path Finding:** Automatically locates your Chrome installation, whether it's in Program Files or AppData.
* **VBS Launcher:** Includes a silent launcher to run the app without a messy command-prompt window in the background.

---

## 📦 Quick Start

### Automated Setup
You can use the provided PowerShell installer to set everything up automatically:
1. It checks for **Python 3** (and installs the latest version via Winget if missing).
2. It downloads all necessary files from the repository.
3. It creates a **Desktop Shortcut** with a custom icon for easy access.

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; iwr "https://raw.githubusercontent.com/Uriel-SG/ChromeMultiContainers/main/install.ps1" | iex`
```

### Manual Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/Uriel-SG/ChromeMultiContainers.git
   ```

2. Install dependencies:
   ```bash
   pip install customtkinter pillow
   ```
   
3. Run the application
   ```bash
   python multi_container.py
   ```

N.B. If you want to automate the launch with a single click and/or create a desktop shortcut, you can simply move the repository contents to `C:\ChromeMulticontainers` and use the provided `start.vbs` to launch the app without the console window.
