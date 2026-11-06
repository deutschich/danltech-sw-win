curl.exe -L `
  "https://www.python.org/ftp/python/3.15.0/python-3.15.0-amd64.msi" `
  -o "$env:TEMP\setup.msi"

Start-Process msiexec.exe `
  -ArgumentList '/i',"$env:TEMP\setup.msi",'/quiet','InstallAllUsers=1','PrependPath=1','/norestart' `
  -Wait
