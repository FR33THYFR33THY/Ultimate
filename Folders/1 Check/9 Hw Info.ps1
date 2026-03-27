. $CommonScript

Ensure-Admin
Testing-Connection

Write-Host "Downloading: Hw Info..."

# download hwinfo
Get-FileFromWeb -URL "https://github.com/FR33THYFR33THY/files/raw/main/Hw%20Info.exe" -File "$env:SystemRoot\Temp\Hw Info.exe"

# start hwinfo
Start-Process "$env:SystemRoot\Temp\Hw Info.exe"
