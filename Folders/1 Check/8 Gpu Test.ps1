. $CommonScript

Ensure-Admin
Testing-Connection

# SCRIPT SILENT
$progresspreference = 'silentlycontinue'


Write-Host "Downloading: FurMark..."

# download furmark
Get-FileFromWeb -URL "https://github.com/FR33THYFR33THY/files/raw/main/FurMark.zip" -File "$env:SystemRoot\Temp\FurMark.zip"

# extract files
Expand-Archive "$env:SystemRoot\Temp\FurMark.zip" -DestinationPath "$env:SystemRoot\Temp\FurMark" -ErrorAction SilentlyContinue

# start furmark
Start-Process "$env:SystemRoot\Temp\FurMark\FurMark.exe"

Clear-Host
Write-Host "Run a basic GPU stress test`n"
Write-Host "Basic troubleshooting items to monitor:"
Write-Host "- Temps"
Write-Host "- Framerate"
Write-Host "- Artifacts"
Write-Host "- Freezing"
Write-Host "- Driver crashes"
Write-Host "- Shutdowns"
Write-Host "- Blue screens`n"

Pause
