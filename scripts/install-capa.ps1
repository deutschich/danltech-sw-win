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

Write-Host "[*] Downloading capa ..."
curl.exe -L -o "capa.zip" "https://github.com/mandiant/capa/releases/latest/download/capa-v9.1.0-windows.zip"

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
if ($envPath -notlike "*$InstallDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$envPath;$($Exe.DirectoryName)", "Machine")
}

Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
Write-Host "[+] capa installed to $InstallDir"
