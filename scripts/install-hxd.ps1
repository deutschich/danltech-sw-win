#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "HxD"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Tools\HxD"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\HxD"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading HxD ..."
curl.exe -L -o "HxDSetup.zip" "https://mh-nexus.de/downloads/HxDSetup.zip"

Write-Host "[*] Extracting installer ..."
Expand-Archive -Path "HxDSetup.zip" -DestinationPath $TmpDir -Force

Write-Host "[*] Running installer ..."
Start-Process -FilePath ".\HxDSetup.exe" -ArgumentList "/SILENT" -Wait

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] HxD installed (default location)."
