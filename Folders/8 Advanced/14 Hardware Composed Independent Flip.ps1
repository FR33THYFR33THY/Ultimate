. $CommonScript

Ensure-Admin

        Write-Host "1. Hardware Composed Independent Flip"
        Write-Host "2. Hardware Independent Flip (Default)`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

cmd /c "reg add `"HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler`" /v `"ForceFlipTrueImmediateMode`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

exit

          }
        2 {

Clear-Host

cmd /c "reg delete `"HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler`" /f >nul 2>&1"

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
