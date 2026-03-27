. $CommonScript

Ensure-Admin

        Write-Host "1. Spectre Meltdown: Disable"
        Write-Host "2. Spectre Meltdown: Enable (Default)`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

# disable spectre meltdown
cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Memory Management`" /v `"FeatureSettingsOverrideMask`" /t REG_DWORD /d `"3`" /f >nul 2>&1"
cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Memory Management`" /v `"FeatureSettingsOverride`" /t REG_DWORD /d `"3`" /f >nul 2>&1"

exit

          }
        2 {

Clear-Host

# enable spectre meltdown
cmd /c "reg delete `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Memory Management`" /v `"FeatureSettingsOverrideMask`" /f >nul 2>&1"
cmd /c "reg delete `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Memory Management`" /v `"FeatureSettingsOverride`" /f >nul 2>&1"

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
