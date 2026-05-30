curl.exe -L `
  "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.9.6.1/npp.8.9.6.1.Installer.x64.msi" `
  -o "$env:TEMP\setup.msi"

Start-Process msiexec.exe `
  -ArgumentList '/i',"$env:TEMP\setup.msi",'/quiet','/norestart' `
  -Wait
