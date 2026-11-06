#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "Wireshark"
$TmpDir = "$env:TEMP\setup-$ToolName"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading latest Wireshark (stable) ..."
# Latest stable x64 MSI (check https://www.wireshark.org/download.html for current)
curl.exe -L -o "Wireshark-setup.msi" "https://2.na.dl.wireshark.org/win64/Wireshark-latest-x64.msi"

Write-Host "[*] Installing Wireshark silently ..."
Start-Process msiexec.exe -ArgumentList "/i `"$TmpDir\Wireshark-setup.msi`" /qn /norestart" -Wait

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] Wireshark installed."
