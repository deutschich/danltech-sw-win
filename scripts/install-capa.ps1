#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ToolName = "capa"
$TmpDir = "$env:TEMP\setup-$ToolName"
$InstallDir = "C:\Tools\capa"
$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\capa"

New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path $StartMenu | Out-Null
Set-Location $TmpDir

Write-Host "[*] Downloading capa v10.0.0 ..."
curl.exe -f -L -o "capa.zip" "https://github.com/mandiant/capa/releases/download/v10.0.0/capa-v10.0.0-windows.zip"
if ((Get-Item "capa.zip").Length -lt 5MB) { throw "Download too small / failed" }

Write-Host "[*] Extracting ..."
Expand-Archive -Path "capa.zip" -DestinationPath $InstallDir -Force
$Exe = Get-ChildItem $InstallDir -Recurse -Filter "capa.exe" | Select-Object -First 1

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Desktop\capa.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()
$Shortcut = $WshShell.CreateShortcut("$StartMenu\capa.lnk")
$Shortcut.TargetPath = $Exe.FullName
$Shortcut.WorkingDirectory = $Exe.DirectoryName
$Shortcut.Save()

$envPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($envPath -notlike "*$($Exe.DirectoryName)*") {
    [Environment]::SetEnvironmentVariable("Path", "$envPath;$($Exe.DirectoryName)", "Machine")
}

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] capa installed to $InstallDir"
