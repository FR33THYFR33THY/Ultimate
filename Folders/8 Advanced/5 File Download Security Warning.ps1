. $CommonScript

Ensure-Admin

        Write-Host "File Download Security Warning:"
        Write-Host "1. Disable"
        Write-Host "2. Enable (Default)`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

# disable file download security warning
cmd /c "reg add `"HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Security`" /v `"DisableSecuritySettingsCheck`" /t REG_DWORD /d `"1`" /f >nul 2>&1"
cmd /c "reg add `"HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3`" /v `"1806`" /t REG_DWORD /d `"0`" /f >nul 2>&1"
cmd /c "reg add `"HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3`" /v `"1806`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

exit

          }
        2 {

Clear-Host

# enable file download security warning
cmd /c "reg delete HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer /f >nul 2>&1"
cmd /c "reg delete `"HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3`" /v `"1806`" /f >nul 2>&1"
cmd /c "reg add `"HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3`" /v `"1806`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
