curl.exe -L `
  "https://github.com/keepassxreboot/keepassxc/releases/download/2.7.12/KeePassXC-2.7.12-Win64.msi" `
  -o "$env:TEMP\setup.msi"

Start-Process msiexec.exe `
  -ArgumentList '/i',"$env:TEMP\setup.msi",'/quiet','/norestart' `
  -Wait
