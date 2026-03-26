. $CommonScript

Ensure-Admin

Write-Host "Press Enter to Restart to BIOS" -ForegroundColor Red
Pause

# restart to bios
cmd /c C:\Windows\System32\shutdown.exe /r /fw
