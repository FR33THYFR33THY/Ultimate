. $CommonScript

Ensure-Admin

        Write-Host "1. UAC: Off (Recommended)"
        Write-Host "2. UAC: Default"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

# disable uac
cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System`" /v `"EnableLUA`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

exit

      }
    2 {

Clear-Host

# enable uac
cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System`" /v `"EnableLUA`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

exit

      }
    } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
