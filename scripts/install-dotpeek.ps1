#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "dotPeek"
$TmpDir = "$env:TEMP\setup-$ToolName"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\dotPeek"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading JetBrains dotPeek 2026.2.4.1 ..."
curl.exe -f -L -o "dotPeek64.exe" "https://download.jetbrains.com/resharper/dotUltimate.2026.2.4.1/dotPeek64.2026.2.4.1.exe"
if ((Get-Item "dotPeek64.exe").Length -lt 50MB) { throw "Download too small / failed" }

Write-Host "[*] Installing silently ..."
# JetBrains silent install flags
Start-Process -FilePath ".\dotPeek64.exe" -ArgumentList "/Silent=True", "/SpecificProductNames=dotPeek", "/VsVersion=*" -Wait

# Standard install path after silent install
$InstallPath = "${env:ProgramFiles}\JetBrains\dotPeek 2026.2"
$Exe = Get-ChildItem $InstallPath -Recurse -Filter "dotPeek64.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $Exe) {
    $Exe = Get-ChildItem "${env:LOCALAPPDATA}\JetBrains" -Recurse -Filter "dotPeek64.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
}
if (-not $Exe) {
    $Exe = Get-ChildItem "C:\Program Files\JetBrains" -Recurse -Filter "dotPeek64.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
}

if ($Exe) {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$Desktop\dotPeek.lnk")
    $Shortcut.TargetPath = $Exe.FullName
    $Shortcut.WorkingDirectory = $Exe.DirectoryName
    $Shortcut.Save()

    $Shortcut = $WshShell.CreateShortcut("$StartMenu\dotPeek.lnk")
    $Shortcut.TargetPath = $Exe.FullName
    $Shortcut.WorkingDirectory = $Exe.DirectoryName
    $Shortcut.Save()
    Write-Host "[+] Desktop + Start Menu shortcuts created."
} else {
    Write-Host "[!] Installation finished, but executable not found automatically. Check Start Menu."
}

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] dotPeek installation completed."
