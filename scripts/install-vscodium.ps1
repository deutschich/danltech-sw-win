curl.exe -L `
  "https://github.com/VSCodium/vscodium/releases/download/1.143.17232/VSCodium-x64-updates-disabled-1.143.17232.msi" `
  -o "$env:TEMP\setup.msi"

Start-Process msiexec.exe `
  -ArgumentList '/i',"$env:TEMP\setup.msi",'/quiet','/norestart' `
  -Wait
