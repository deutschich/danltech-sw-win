curl.exe -L `
  "https://2.na.dl.wireshark.org/win64/Wireshark-4.6.3-x64.msi" `
  -o "$env:TEMP\wireshark.msi"

Start-Process msiexec.exe `
  -ArgumentList '/i',"$env:TEMP\wireshark.msi",'/qn','/norestart' `
  -Wait
