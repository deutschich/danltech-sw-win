#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "PE-bear"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Tools\PE-bear"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\PE-bear"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading PE-bear 0.7.2 ..."
curl.exe -L -o "pebear.zip" "https://github.com/hasherezade/pe-bear/releases/download/v0.7.2/PE-bear_0.7.2_qt6_x64_win_vs22.zip"

Write-Host "[*] Extracting ..."
Expand-Archive -Path "pebear.zip" -DestinationPath $InstallDir -Force

$Exe = Get-ChildItem $InstallDir -Recurse -Filter "PE-bear.exe" | Select-Object -First 1

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Desktop\PE-bear.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

$Shortcut = $WshShell.CreateShortcut("$StartMenu\PE-bear.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] PE-bear installed to $InstallDir"
