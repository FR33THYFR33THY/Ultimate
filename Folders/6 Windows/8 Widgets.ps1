. $CommonScript

Ensure-Admin

        Write-Host "1. Widgets: Off (Recommended)"
        Write-Host "2. Widgets: Default`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

# disable widgets regedit
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\PolicyManager\default\NewsAndInterests\AllowNewsAndInterests`" /v `"value`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# remove windows widgets from taskbar regedit
cmd /c "reg add `"HKLM\SOFTWARE\Policies\Microsoft\Dsh`" /v `"AllowNewsAndInterests`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# stop widgets running
Stop-Process -Force -Name Widgets -ErrorAction SilentlyContinue | Out-Null
Stop-Process -Force -Name WidgetService -ErrorAction SilentlyContinue | Out-Null

exit

          }
        2 {

Clear-Host

# widgets regedit
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\PolicyManager\default\NewsAndInterests\AllowNewsAndInterests`" /v `"value`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

# windows widgets from taskbar regedit
cmd /c "reg delete `"HKLM\SOFTWARE\Policies\Microsoft\Dsh`" /f >nul 2>&1"

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
