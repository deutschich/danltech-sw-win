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

Write-Host "[*] Downloading HxDSetup.zip ..."
curl.exe -f -L -A "Mozilla/5.0" -o "HxDSetup.zip" "https://mh-nexus.de/downloads/HxDSetup.zip"
if ((Get-Item "HxDSetup.zip").Length -lt 1MB) { throw "Download too small / failed" }

Write-Host "[*] Extracting installer ..."
Expand-Archive -Path "HxDSetup.zip" -DestinationPath $TmpDir -Force

$Setup = Get-ChildItem $TmpDir -Filter "HxDSetup.exe" -Recurse | Select-Object -First 1
if (-not $Setup) { throw "HxDSetup.exe not found after extract" }

Write-Host "[*] Running installer silently ..."
Start-Process -FilePath $Setup.FullName -ArgumentList "/SILENT" -Wait

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] HxD installed (default location + Start Menu entry created by installer)."
