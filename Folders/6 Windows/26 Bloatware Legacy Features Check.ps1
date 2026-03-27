. $CommonScript

Ensure-Admin

Start-Process "$env:SystemDrive\Windows\system32\optionalfeatures.exe"

dism /online /get-features /format:table

Write-Host ""

Pause
