curl.exe -L `
  "https://de.libreoffice.org/donate/dl/win-x86_64/26.2.3/de/LibreOffice_26.2.3_Win_x86-64.msi" `
  -o "$env:TEMP\setup.msi"

Start-Process msiexec.exe `
  -ArgumentList '/i',"$env:TEMP\setup.msi",'/quiet','/norestart' `
  -Wait
