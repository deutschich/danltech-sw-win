curl.exe -L `
  "https://get.videolan.org/vlc/3.0.24/win64/vlc-3.0.24-win64.msi" `
  -o "$env:TEMP\setup.msi"

Start-Process msiexec.exe `
  -ArgumentList '/i',"$env:TEMP\setup.msi",'/quiet','/norestart' `
  -Wait
