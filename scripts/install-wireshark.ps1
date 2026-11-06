curl.exe -L `
  "https://www.wireshark.org/download/win64/Wireshark-4.6.9-x64.msi" `
  -o "$env:TEMP\setup.msi"

Start-Process msiexec.exe `
  -ArgumentList '/i',"$env:TEMP\setup.msi",'/qn','/norestart' `
  -Wait
