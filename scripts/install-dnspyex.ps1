#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "dnSpyEx"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Tools\dnSpyEx"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\dnSpyEx"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading dnSpyEx ..."
curl.exe -L -o "dnSpy.zip" "https://github.com/dnSpyEx/dnSpy/releases/latest/download/dnSpy-net-win64.zip"

Write-Host "[*] Extracting ..."
Expand-Archive -Path "dnSpy.zip" -DestinationPath $InstallDir -Force

$Exe = Get-ChildItem $InstallDir -Recurse -Filter "dnSpy.exe" | Select-Object -First 1

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Desktop\dnSpyEx.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

$Shortcut = $WshShell.CreateShortcut("$StartMenu\dnSpyEx.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] dnSpyEx installed to $InstallDir"
