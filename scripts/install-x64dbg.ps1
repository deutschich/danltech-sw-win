#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "x64dbg"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Tools\x64dbg"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\x64dbg"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading x64dbg snapshot ..."
# Latest snapshot from GitHub releases (update URL if needed)
curl.exe -L -o "x64dbg.zip" "https://github.com/x64dbg/x64dbg/releases/download/snapshot/snapshot_2026-05-27_12-11.zip"

Write-Host "[*] Extracting to $InstallDir ..."
Expand-Archive -Path "x64dbg.zip" -DestinationPath $InstallDir -Force

# Create shortcuts
$WshShell = New-Object -ComObject WScript.Shell

$Shortcut = $WshShell.CreateShortcut("$Desktop\x64dbg.lnk")
$Shortcut.TargetPath = "$InstallDir\release\x64\x64dbg.exe"
$Shortcut.WorkingDirectory = "$InstallDir\release\x64"
$Shortcut.Save()

$Shortcut = $WshShell.CreateShortcut("$Desktop\x32dbg.lnk")
$Shortcut.TargetPath = "$InstallDir\release\x32\x32dbg.exe"
$Shortcut.WorkingDirectory = "$InstallDir\release\x32"
$Shortcut.Save()

$Shortcut = $WshShell.CreateShortcut("$StartMenu\x64dbg.lnk")
$Shortcut.TargetPath = "$InstallDir\release\x64\x64dbg.exe"
$Shortcut.WorkingDirectory = "$InstallDir\release\x64"
$Shortcut.Save()

$Shortcut = $WshShell.CreateShortcut("$StartMenu\x32dbg.lnk")
$Shortcut.TargetPath = "$InstallDir\release\x32\x32dbg.exe"
$Shortcut.WorkingDirectory = "$InstallDir\release\x32"
$Shortcut.Save()

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] x64dbg installed to $InstallDir"
Write-Host "    Desktop + Start Menu shortcuts created."
