#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "Ghidra"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Tools\Ghidra"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Ghidra"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading Ghidra 12.2 ..."
curl.exe -f -L -o "ghidra.zip" "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.2_build/ghidra_12.2_PUBLIC_20261016.zip"
if ((Get-Item "ghidra.zip").Length -lt 50MB) { throw "Download too small / failed" }

Write-Host "[*] Extracting ..."
Expand-Archive -Path "ghidra.zip" -DestinationPath $InstallDir -Force
$GhidraRoot = Get-ChildItem $InstallDir -Directory | Select-Object -First 1

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Desktop\Ghidra.lnk")
$Shortcut.TargetPath = "$($GhidraRoot.FullName)\ghidraRun.bat"
$Shortcut.WorkingDirectory = $GhidraRoot.FullName
$Shortcut.Save()
$Shortcut = $WshShell.CreateShortcut("$StartMenu\Ghidra.lnk")
$Shortcut.TargetPath = "$($GhidraRoot.FullName)\ghidraRun.bat"
$Shortcut.WorkingDirectory = $GhidraRoot.FullName
$Shortcut.Save()

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] Ghidra installed to $InstallDir (needs JDK 21+)"
