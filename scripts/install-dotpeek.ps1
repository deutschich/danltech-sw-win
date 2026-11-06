#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "dotPeek"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Tools\dotPeek"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\dotPeek"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading JetBrains dotPeek ..."
curl.exe -L -o "dotPeek.zip" "https://download.jetbrains.com/dotnet/dotPeek64.2024.3.zip"

Write-Host "[*] Extracting ..."
Expand-Archive -Path "dotPeek.zip" -DestinationPath $InstallDir -Force

$Exe = Get-ChildItem $InstallDir -Recurse -Filter "dotPeek64.exe" | Select-Object -First 1
if (-not $Exe) { $Exe = Get-ChildItem $InstallDir -Recurse -Filter "dotPeek*.exe" | Select-Object -First 1 }

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Desktop\dotPeek.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

$Shortcut = $WshShell.CreateShortcut("$StartMenu\dotPeek.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] dotPeek installed to $InstallDir"
