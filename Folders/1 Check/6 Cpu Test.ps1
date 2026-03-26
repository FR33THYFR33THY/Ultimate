. $CommonScript

Ensure-Admin
Test-Connection

Write-Host "Downloading: Prime95..."

# download prime95
Get-FileFromWeb -URL "https://github.com/FR33THYFR33THY/files/raw/main/Prime%2095.zip" -File "$env:SystemRoot\Temp\Prime 95.zip"

# extract files
Expand-Archive "$env:SystemRoot\Temp\Prime 95.zip" -DestinationPath "$env:SystemRoot\Temp\Prime 95" -ErrorAction SilentlyContinue

# start prime95
Start-Process "$env:SystemRoot\Temp\Prime 95\prime95.exe"

Clear-Host
Write-Host "Run a basic CPU stress test to check for errors"
Write-Host "Check temps and WHEA errors in Hw Info during this test"
Write-Host "In Prime95, click 'Window' and select 'Merge All Workers'"
Write-Host ""
Write-Host "CPU and RAM errors should not be ignored as they can lead to:"
Write-Host "- Corrupted Windows"
Write-Host "- Corrupted files"
Write-Host "- Stutters and hitches"
Write-Host "- Poor performance"
Write-Host "- Input lag"
Write-Host "- Shutdowns"
Write-Host "- Blue screens"
Write-Host ""
Write-Host "Basic troubleshooting for errors or issues running XMP DOCP EXPO:"
Write-Host "- BIOS out of date? (update)"
Write-Host "- BIOS bugged out? (clear CMOS)"
Write-Host "- Incompatible RAM? (check QVL)"
Write-Host "- Mismatched RAM? (replace)"
Write-Host "- RAM in wrong slots? (check manual)"
Write-Host "- Unlucky CPU memory controller? (lower RAM speed)"
Write-Host "- Overclock? (turn it off/dial it down)"
Write-Host "- CPU cooler overtightened? (loosen)"
Write-Host "- CPU overheating? (repaste/retighten/RMA cooler)"
Write-Host "- RAM overheating? Typically over 55deg. (fix case flow/ram fan)"
Write-Host "- Faulty RAM stick? (RMA)"
Write-Host "- Faulty motherboard? (RMA)"
Write-Host "- Faulty CPU? (RMA)"
Write-Host "- Bent CPU pin? (RMA)`n"

Pause
