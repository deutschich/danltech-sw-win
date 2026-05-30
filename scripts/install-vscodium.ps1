curl.exe -L `
  "https://github.com/VSCodium/vscodium/releases/download/1.121.03429/VSCodium-x64-updates-disabled-1.121.03429.msi" `
  -o "$env:TEMP\setup.msi"

Start-Process msiexec.exe `
  -ArgumentList '/i',"$env:TEMP\setup.msi",'/quiet','/norestart' `
  -Wait
