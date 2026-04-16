# =================================================================
# SCRIPT DI INSTALLAZIONE: CHROME MULTI CONTAINERS
# =================================================================

# Configurazione
$repoUrl = "https://raw.githubusercontent.com/Uriel-SG/ChromeMultiContainers/main"
$installDir = "C:\ChromeMulticontainers"
$desktopPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "ChromeContainers.lnk")

Write-Host "--- Inizio Installazione Chrome Containers ---" -ForegroundColor Cyan

# 1. Controllo Robusto Python (python, python3, py)
$pythonCmd = $null
$commandsToTry = "python", "python3", "py"

Write-Host "Verifica installazione Python 3 esistente..." -ForegroundColor Gray

foreach ($cmd in $commandsToTry) {
    try {
        # Eseguiamo il check della versione catturando anche eventuali errori
        $check = & $cmd --version 2>$null
        if ($check -match "Python 3") {
            $pythonCmd = $cmd
            Write-Host "Python 3 trovato: $($check) (usando '$pythonCmd')" -ForegroundColor Green
            break
        }
    } catch {
        continue
    }
}

# Se non viene trovato alcun comando valido, installa Python
if ($null -eq $pythonCmd) {
    Write-Host "Python non trovato. Installazione dell'ultima versione tramite Winget..." -ForegroundColor Yellow
    # Python.Python.3 installa automaticamente l'ultima versione stabile disponibile
    winget install Python.Python.3 --silent --accept-package-agreements --accept-source-agreements
    
    # Aggiorna il PATH per la sessione corrente per riconoscere subito il nuovo comando
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    $pythonCmd = "python"
}

# 2. Creazione cartella di installazione
if (!(Test-Path $installDir)) { 
    Write-Host "Creazione cartella in $installDir" -ForegroundColor Gray
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null 
}

# 3. Download files (Python script + Icona)
Write-Host "Download dei componenti dal repository..." -ForegroundColor Gray
try {
    Invoke-WebRequest -Uri "$repoUrl/multi_container.py" -OutFile "$installDir\multi_container.py" -ErrorAction Stop
    Invoke-WebRequest -Uri "$repoUrl/ChromeContainers.ico" -OutFile "$installDir\ChromeContainers.ico" -ErrorAction SilentlyContinue
} catch {
    Write-Host "Errore durante il download dei file. Verifica l'URL del repository." -ForegroundColor Red
    return
}

# 4. Installazione Librerie con il comando trovato
Write-Host "Installazione dipendenze Python (customtkinter, pillow)..." -ForegroundColor Yellow
& $pythonCmd -m pip install --upgrade pip --quiet
& $pythonCmd -m pip install customtkinter pillow --quiet

# 5. Creazione Launcher VBS (per avvio senza finestra DOS)
# Utilizziamo pythonw.exe basandoci sul comando rilevato (es. python -> pythonw)
$pythonW = $pythonCmd + "w.exe"
$vbsContent = "Set WshShell = CreateObject(""WScript.Shell"")`nWshShell.Run ""$pythonW """"$installDir\multi_container.py"""""", 0, False"
$vbsContent | Out-File -FilePath "$installDir\launcher.vbs" -Encoding ASCII

# 6. Creazione collegamento sul Desktop
Write-Host "Creazione collegamento sul Desktop..." -ForegroundColor Gray
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($desktopPath)
$Shortcut.TargetPath = "wscript.exe"
$Shortcut.Arguments = """$installDir\launcher.vbs"""
$Shortcut.WorkingDirectory = $installDir
if (Test-Path "$installDir\ChromeContainers.ico") {
    $Shortcut.IconLocation = "$installDir\ChromeContainers.ico"
}
$Shortcut.Save()

Write-Host "---" -ForegroundColor Cyan
Write-Host "INSTALLAZIONE COMPLETATA!" -ForegroundColor Green
Write-Host "Puoi avviare l'app dall'icona 'ChromeContainers' sul Desktop." -ForegroundColor White
