#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "Sysmon"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Tools\Sysmon"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading Sysmon ..."
curl.exe -L -o "Sysmon.zip" "https://download.sysinternals.com/files/Sysmon.zip"

Write-Host "[*] Extracting ..."
Expand-Archive -Path "Sysmon.zip" -DestinationPath $InstallDir -Force

Write-Host "[*] Installing Sysmon service (default config) ..."
& "$InstallDir\Sysmon64.exe" -accepteula -i

Write-Host "[+] Sysmon installed and running."
Write-Host "    Config location: $InstallDir"
Write-Host "    To update config later: Sysmon64.exe -c <config.xml>"

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
