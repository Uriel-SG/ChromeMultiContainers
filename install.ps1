# Configurazione
$repoUrl = "https://raw.githubusercontent.com/TUO_UTENTE/TUO_REPO/main"
$installDir = "C:\ChromeMulticontainer"
$desktopPath = [ELementPath]::Combine([Environment]::GetFolderPath("Desktop"), "ChromeContainers.lnk")

Write-Host "--- Inizio Installazione Chrome Containers ---" -ForegroundColor Cyan

# 1. Controllo Python
if (!(Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Installazione Python in corso..." -ForegroundColor Yellow
    winget install Python.Python.3.11 --silent --accept-package-agreements --accept-source-agreements
}

# 2. Creazione cartelle
if (!(Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir }

# 3. Download files (Python script + Icona)
Invoke-WebRequest -Uri "$repoUrl/multi_container.py" -OutFile "$installDir\multi_container.py"
Invoke-WebRequest -Uri "$repoUrl/ChromeContainers.ico" -OutFile "$installDir\ChromeContainers.ico"

# 4. Installazione Requirements
Write-Host "Installazione librerie Python..." -ForegroundColor Yellow
& python -m pip install customtkinter pillow

# 5. Creazione VBS (Silenzioso)
$vbsContent = "Set WshShell = CreateObject(""WScript.Shell"")`nWshShell.Run ""pythonw.exe """"$installDir\multi_container.py"""""", 0, False"
$vbsContent | Out-File -FilePath "$installDir\launcher.vbs" -Encoding ASCII

# 6. Creazione collegamento sul Desktop
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($desktopPath)
$Shortcut.TargetPath = "wscript.exe"
$Shortcut.Arguments = """$installDir\launcher.vbs"""
$Shortcut.WorkingDirectory = $installDir
$Shortcut.IconLocation = "$installDir\ChromeContainers.ico"
$Shortcut.Save()

Write-Host "--- INSTALLAZIONE COMPLETATA! ---" -ForegroundColor Green
Write-Host "Trovi l'icona sul Desktop." -ForegroundColor Green