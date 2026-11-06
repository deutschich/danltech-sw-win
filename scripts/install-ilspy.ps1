#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "ILSpy"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Tools\ILSpy"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\ILSpy"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading ILSpy 11.2 x64 ..."
curl.exe -f -L -o "ILSpy.zip" "https://github.com/icsharpcode/ILSpy/releases/download/v11.2/ILSpy_windows_11.2.0.10050-x64.zip"
if ((Get-Item "ILSpy.zip").Length -lt 5MB) { throw "Download too small / failed" }

Write-Host "[*] Extracting ..."
Expand-Archive -Path "ILSpy.zip" -DestinationPath $InstallDir -Force
$Exe = Get-ChildItem $InstallDir -Recurse -Filter "ILSpy.exe" | Select-Object -First 1

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Desktop\ILSpy.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()
$Shortcut = $WshShell.CreateShortcut("$StartMenu\ILSpy.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] ILSpy installed to $InstallDir"
