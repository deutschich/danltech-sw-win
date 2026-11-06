#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "YARA"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Tools\YARA"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\YARA"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading YARA 4.5.5 win64 (last binary release with Windows builds) ..."
curl.exe -f -L -o "yara.zip" "https://github.com/VirusTotal/yara/releases/download/v4.5.5/yara-4.5.5-2368-win64.zip"
if ((Get-Item "yara.zip").Length -lt 1MB) { throw "Download too small / failed" }

Write-Host "[*] Extracting ..."
Expand-Archive -Path "yara.zip" -DestinationPath $InstallDir -Force
$Exe = Get-ChildItem $InstallDir -Recurse -Filter "yara64.exe" | Select-Object -First 1
if (-not $Exe) { $Exe = Get-ChildItem $InstallDir -Recurse -Filter "yara*.exe" | Select-Object -First 1 }

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Desktop\YARA.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()
$Shortcut = $WshShell.CreateShortcut("$StartMenu\YARA.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

$envPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($envPath -notlike "*$($Exe.DirectoryName)*") {
    [Environment]::SetEnvironmentVariable("Path", "$envPath;$($Exe.DirectoryName)", "Machine")
}

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] YARA installed to $InstallDir"
