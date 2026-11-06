#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "FLOSS"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Tools\FLOSS"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\FLOSS"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading FLOSS v3.2.0 ..."
curl.exe -f -L -o "floss.zip" "https://github.com/mandiant/flare-floss/releases/download/v3.2.0/floss-v3.2.0-windows.zip"
if ((Get-Item "floss.zip").Length -lt 5MB) { throw "Download too small / failed" }

Write-Host "[*] Extracting ..."
Expand-Archive -Path "floss.zip" -DestinationPath $InstallDir -Force
$Exe = Get-ChildItem $InstallDir -Recurse -Filter "floss.exe" | Select-Object -First 1

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Desktop\FLOSS.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()
$Shortcut = $WshShell.CreateShortcut("$StartMenu\FLOSS.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

$envPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($envPath -notlike "*$($Exe.DirectoryName)*") {
    [Environment]::SetEnvironmentVariable("Path", "$envPath;$($Exe.DirectoryName)", "Machine")
}

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] FLOSS installed to $InstallDir"
