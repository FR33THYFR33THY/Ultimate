. $CommonScript

Ensure-Admin

        Write-Host "Data Execution Prevention:"
        Write-Host "1. Disable"
        Write-Host "2. Enable (Default)`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

# disable data execution prevention
cmd /c "bcdedit /set nx AlwaysOff >nul 2>&1"

exit

          }
        2 {

Clear-Host

# enable data execution prevention
cmd /c "bcdedit /deletevalue nx >nul 2>&1"

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
