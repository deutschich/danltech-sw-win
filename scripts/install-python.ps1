#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "Python"
$Version = "3.15.2"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Python315"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading Python $Version ..."
curl.exe -L -o "python-setup.exe" "https://www.python.org/ftp/python/3.15.2/python-3.15.2-amd64.exe"

Write-Host "[*] Installing Python silently (Add to PATH, pip, etc.) ..."
Start-Process -FilePath ".\python-setup.exe" -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 Include_test=0 Include_doc=0 Include_launcher=1 Include_pip=1" -Wait

# Cleanup
Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue

Write-Host "[+] Python $Version installed."
Write-Host "    Restart shell or logoff/login for PATH to take effect."
