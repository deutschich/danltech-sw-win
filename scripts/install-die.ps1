#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "DetectItEasy"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Tools\DIE"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\DIE"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading Detect It Easy 4.0.0 ..."
curl.exe -L -o "die.zip" "https://github.com/horsicq/DIE-engine/releases/download/4.0.0/die_win64_qt6_4.0.0.zip"

Write-Host "[*] Extracting ..."
Expand-Archive -Path "die.zip" -DestinationPath $InstallDir -Force

$Exe = Get-ChildItem $InstallDir -Recurse -Filter "die.exe" | Select-Object -First 1

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Desktop\Detect It Easy.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

$Shortcut = $WshShell.CreateShortcut("$StartMenu\Detect It Easy.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] DIE installed to $InstallDir"
