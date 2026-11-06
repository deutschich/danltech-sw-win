#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "Regshot"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Tools\Regshot"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Regshot"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading Regshot ..."
curl.exe -L -o "regshot.7z" "https://sourceforge.net/projects/regshot/files/regshot/1.9.0/Regshot-1.9.0.7z/download"

Write-Host "[*] Extracting (requires 7-Zip) ..."
& "C:\Program Files\7-Zip\7z.exe" x "regshot.7z" -o"$InstallDir" -y

$Exe = Get-ChildItem $InstallDir -Recurse -Filter "Regshot-x64-Unicode.exe" | Select-Object -First 1
if (-not $Exe) { $Exe = Get-ChildItem $InstallDir -Recurse -Filter "Regshot*.exe" | Select-Object -First 1 }

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Desktop\Regshot.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

$Shortcut = $WshShell.CreateShortcut("$StartMenu\Regshot.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] Regshot installed to $InstallDir"
