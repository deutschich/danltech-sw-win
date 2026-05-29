curl.exe -L `
  "https://download.mozilla.org/?product=thunderbird-msi-latest-ssl&os=win64&lang=de" `
  -o "$env:TEMP\setup.msi"

Start-Process msiexec.exe `
  -ArgumentList '/i',"$env:TEMP\setup.msi",'/quiet','/norestart' `
  -Wait
