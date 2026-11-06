#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "PEStudio"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Tools\PEStudio"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\PEStudio"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading PEStudio ..."
curl.exe -L -o "pestudio.zip" "https://www.winitor.com/tools/pestudio/current/pestudio.zip"

Write-Host "[*] Extracting ..."
Expand-Archive -Path "pestudio.zip" -DestinationPath $InstallDir -Force

$Exe = Get-ChildItem $InstallDir -Recurse -Filter "pestudio.exe" | Select-Object -First 1

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Desktop\PEStudio.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

$Shortcut = $WshShell.CreateShortcut("$StartMenu\PEStudio.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] PEStudio installed to $InstallDir"
