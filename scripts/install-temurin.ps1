#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "TemurinJDK25"
$TmpDir = "$env:TEMP\setup-$ToolName"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading Eclipse Temurin JDK 25.0.5 (x64 MSI) ..."
curl.exe -L -o "temurin25.msi" "https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.5%2B8/OpenJDK25U-jdk_x64_windows_hotspot_25.0.5_8.msi"

Write-Host "[*] Installing Temurin JDK 25 silently (adds to PATH + JAVA_HOME) ..."
Start-Process msiexec.exe -ArgumentList "/i `"$TmpDir\temurin25.msi`" ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome /qn /norestart" -Wait

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] Eclipse Temurin JDK 25 installed."
Write-Host "    Restart shell or logoff/login for PATH / JAVA_HOME to take effect."
