curl.exe -L `
  "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi" `
  -o "$env:TEMP\setup.msi"

Start-Process msiexec.exe `
  -ArgumentList '/i',"$env:TEMP\setup.msi",'/quiet','/norestart' `
  -Wait
