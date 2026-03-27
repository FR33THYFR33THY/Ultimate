. $CommonScript

Ensure-Admin

        Write-Host "1. Background Apps: Off (Recommended)"
        Write-Host "2. Background Apps: Default`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

# disable background apps regedit
cmd /c "reg add `"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy`" /v `"LetAppsRunInBackground`" /t REG_DWORD /d `"2`" /f >nul 2>&1"

# open settings
Start-Process ms-settings:privacy-backgroundapps

exit

          }
        2 {

Clear-Host

# background apps regedit
cmd /c "reg delete `"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy`" /v `"LetAppsRunInBackground`" /f >nul 2>&1"

# open settings
Start-Process ms-settings:privacy-backgroundapps

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
