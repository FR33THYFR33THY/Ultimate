. $CommonScript

Ensure-Admin
Test-Connection

Write-Host "Downloading: Furmark..."

# download furmark
Get-FileFromWeb -URL "https://github.com/FR33THYFR33THY/files/raw/main/Furmark.zip" -File "$env:SystemRoot\Temp\Furmark.zip"

# extract files
Expand-Archive "$env:SystemRoot\Temp\Furmark.zip" -DestinationPath "$env:SystemRoot\Temp\Furmark" -ErrorAction SilentlyContinue

# start furmark
Start-Process "$env:SystemRoot\Temp\Furmark\Furmark.exe"

Clear-Host
Write-Host "Run a basic GPU stress test"
Write-Host ""
Write-Host "Basic troubleshooting items to monitor:"
Write-Host "- Temps"
Write-Host "- Framerate"
Write-Host "- Artifacts"
Write-Host "- Freezing"
Write-Host "- Driver crashes"
Write-Host "- Shutdowns"
Write-Host "- Blue screens`n"

Pause
