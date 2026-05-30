curl.exe -L `
  "https://github.com/ip7z/7zip/releases/download/26.01/7z2601-x64.msi" `
  -o "$env:TEMP\setup.msi"

Start-Process msiexec.exe `
  -ArgumentList '/i',"$env:TEMP\setup.msi",'/quiet','/norestart' `
  -Wait
