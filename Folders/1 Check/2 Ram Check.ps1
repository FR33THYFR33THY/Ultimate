. $CommonScript

Ensure-Admin
Testing-Connection

Write-Host "Downloading: Cpu Z..."

# download cpuz
Get-FileFromWeb -URL "https://github.com/FR33THYFR33THY/files/raw/main/Cpu%20Z.exe" -File "$env:SystemRoot\Temp\Cpu Z.exe"

# start cpuz
Start-Process "$env:SystemRoot\Temp\Cpu Z.exe"

Clear-Host
Write-Host "- Check (XMP DOCP EXPO) is enabled"
Write-Host "- Verify RAM is in the correct slots"
Write-Host "- Confirm there is no mismatch in RAM modules"
Write-Host "- At least two RAM sticks (dual channel) is ideal`n"

Pause
