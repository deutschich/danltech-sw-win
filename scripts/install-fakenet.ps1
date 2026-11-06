#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "FakeNet-NG"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Tools\FakeNet-NG"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\FakeNet-NG"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null
Set-Location $TmpDir

# Defender often flags FakeNet – add temporary exclusion
Write-Host "[*] Adding Defender exclusion for $InstallDir (FakeNet is flagged as PUA) ..."
try {
    Add-MpPreference -ExclusionPath $InstallDir -ErrorAction SilentlyContinue
    Add-MpPreference -ExclusionPath $TmpDir -ErrorAction SilentlyContinue
} catch {}

Write-Host "[*] Downloading FakeNet-NG 3.5 ..."
curl.exe -f -L -o "fakenet.zip" "https://github.com/mandiant/flare-fakenet-ng/releases/download/v3.5/fakenet3.5.zip"
if ((Get-Item "fakenet.zip").Length -lt 5MB) { throw "Download too small / failed" }

Write-Host "[*] Extracting ..."
Expand-Archive -Path "fakenet.zip" -DestinationPath $InstallDir -Force
$Exe = Get-ChildItem $InstallDir -Recurse -Filter "fakenet.exe" | Select-Object -First 1

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Desktop\FakeNet-NG.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()
$Shortcut = $WshShell.CreateShortcut("$StartMenu\FakeNet-NG.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] FakeNet-NG installed to $InstallDir"
Write-Host "    NOTE: Run as Admin. Defender exclusion was added for the install folder."
