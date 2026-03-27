. $CommonScript

Ensure-Admin

Write-Host "Disable: Internet First...`n" -ForegroundColor Red

# copy key to clipboard
Set-Clipboard -Value "VK7JG-NPHTM-C97JM-9MPGT-3V66T"

Write-Host "Enter: VK7JG-NPHTM-C97JM-9MPGT-3V66T (Or Paste From Clipboard)`n"

# open activation screen
Start-Process ms-settings:activation
& "$env:windir\System32\SystemSettingsAdminFlows.exe" 'EnterProductKey'

Pause
