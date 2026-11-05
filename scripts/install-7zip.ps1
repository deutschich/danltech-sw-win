curl.exe -L `
  "https://github.com/ip7z/7zip/releases/download/26.05/7z2605-x64.msi" `
  -o "$env:TEMP\setup.msi"

Start-Process msiexec.exe `
  -ArgumentList '/i',"$env:TEMP\setup.msi",'/quiet','/norestart' `
  -Wait
