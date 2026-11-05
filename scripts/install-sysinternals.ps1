# --- Konfiguration ---
$InstallPath = "C:\Tools\Sysinternals"
$DownloadUrl = "https://download.sysinternals.com/files/SysinternalsSuite.zip"

# Tools, für die Desktop-Verknüpfungen erstellt werden sollen
# Target = Dateiname in der Suite, Name = Anzeigename der Verknüpfung
$ShortcutTools = @(
    @{ Name = "Process Explorer"; Target = "procexp64.exe" }
    @{ Name = "Process Monitor";  Target = "Procmon64.exe" }
    @{ Name = "Autoruns";         Target = "Autoruns64.exe" }
    @{ Name = "TCPView";          Target = "TCPView.exe" }
    @{ Name = "PsExec";           Target = "PsExec64.exe" }
    @{ Name = "Sysinternals Ordner"; Target = $InstallPath; IsFolder = $true }
)

# --- Funktion: "Als Administrator ausführen"-Flag setzen ---
function Set-ShortcutRunAsAdmin {
    param([string]$ShortcutPath)
    try {
        $bytes = [System.IO.File]::ReadAllBytes($ShortcutPath)
        $bytes[0x15] = $bytes[0x15] -bor 0x20  # Bit 0x20 = RunAsAdmin
        [System.IO.File]::WriteAllBytes($ShortcutPath, $bytes)
    } catch {
        Write-Warning "RunAsAdmin-Flag konnte nicht gesetzt werden für '$ShortcutPath': $_"
    }
}

# --- 1. Zielordner erstellen ---
if (-not (Test-Path -Path $InstallPath)) {
    New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
    Write-Host "Ordner '$InstallPath' wurde erstellt."
}

# --- 2. Download ---
$ZipPath = Join-Path $env:TEMP "SysinternalsSuite.zip"
try {
    $ProgressPreference = "SilentlyContinue"
    curl.exe -L --fail -o "$ZipPath" "$DownloadUrl"
    Write-Host "Download erfolgreich nach '$ZipPath'."
} catch {
    Write-Error "Download fehlgeschlagen: $_"
    return
}

# --- 3. Entpacken ---
try {
    Expand-Archive -LiteralPath $ZipPath -DestinationPath $InstallPath -Force -ErrorAction Stop
    Remove-Item -Path $ZipPath -Force
    Write-Host "Sysinternals Suite erfolgreich nach '$InstallPath' entpackt."
} catch {
    Write-Error "Entpacken fehlgeschlagen: $_"
    return
}

# --- 4. Verknüpfungen auf dem gemeinsamen Desktop erstellen ---
$CommonDesktop = [Environment]::GetFolderPath('CommonDesktopDirectory')
if (-not (Test-Path $CommonDesktop)) {
    Write-Warning "Gemeinsamer Desktop nicht gefunden: '$CommonDesktop' – überspringe Verknüpfungen."
} else {
    $WshShell = New-Object -ComObject WScript.Shell
    try {
        foreach ($tool in $ShortcutTools) {
            $targetPath = $tool.Target
            if (-not $tool.IsFolder) {
                $targetPath = Join-Path $InstallPath $tool.Target
                if (-not (Test-Path $targetPath)) {
                    Write-Warning "Zieldatei nicht gefunden: '$targetPath' – überspringe."
                    continue
                }
            }

            $shortcutPath = Join-Path $CommonDesktop ("{0}.lnk" -f $tool.Name)
            $shortcut = $WshShell.CreateShortcut($shortcutPath)
            $shortcut.TargetPath       = $targetPath
            $shortcut.WorkingDirectory = $InstallPath
            $shortcut.Description      = "Sysinternals – " + $tool.Name
            $shortcut.IconLocation     = "$targetPath,0"
            $shortcut.Save()

            # Admin-Recht nur für .exe-Tools, nicht für den Ordner-Shortcut
            if (-not $tool.IsFolder) {
                Set-ShortcutRunAsAdmin -ShortcutPath $shortcutPath
            }

            Write-Host "Verknüpfung erstellt: $shortcutPath"
        }
    } finally {
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($WshShell) | Out-Null
    }
}
