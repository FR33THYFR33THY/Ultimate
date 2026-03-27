. $CommonScript

Ensure-Admin

        Write-Host "Driver WHQL Secure Boot Bypass:"
        Write-Host "1. Off (Default)"
        Write-Host "2. On`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

# revert driver whql secure boot bypass
cmd.exe /c "reg delete `"HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy`" /v `"WHQLSettings`" /f >nul 2>&1"

exit

          }
        2 {

Clear-Host

# driver whql secure boot bypass
cmd /c "reg add `"HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy`" /v `"WHQLSettings`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
