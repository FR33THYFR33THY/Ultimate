. $CommonScript

Ensure-Admin

        Write-Host "Background Polling Rate Cap"
        Write-Host "1. Off (Recommended)"
        Write-Host "2. Default (125hz)`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

# unlock background polling rate cap
cmd /c "reg add `"HKCU\Control Panel\Mouse`" /v `"RawMouseThrottleEnabled`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

exit

          }
        2 {

Clear-Host

# revert unlock background polling rate cap
cmd /c "reg delete `"HKCU\Control Panel\Mouse`" /v `"RawMouseThrottleEnabled`" /f >nul 2>&1"

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
