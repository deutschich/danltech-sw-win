curl.exe -L `
  "https://2.na.dl.wireshark.org/win64/Wireshark-4.6.9-x64.msi" `
  -o "$env:TEMP\setup.msi"

Start-Process msiexec.exe `
  -ArgumentList '/i',"$env:TEMP\setup.msi",'/qn','/norestart' `
  -Wait
