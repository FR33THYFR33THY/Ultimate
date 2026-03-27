. $CommonScript

Ensure-Admin

        Write-Host "Multiplane Overlay & Optimizations For Windowed Games:"
        Write-Host "1. On (Default)"
        Write-Host "2. Off`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

# enable multiplane overlay
cmd /c "reg delete `"HKLM\SOFTWARE\Microsoft\Windows\Dwm`" /v `"OverlayTestMode`" /f >nul 2>&1"

# enable optimizations for windowed games
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "VRROptimizeEnable=0;SwapEffectUpgradeEnable=1;" /f | Out-Null

exit

         }
       2 {

Clear-Host

# disable multiplane overlay
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d "5" /f | Out-Null

# disable optimizations for windowed games
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "VRROptimizeEnable=0;SwapEffectUpgradeEnable=0;" /f | Out-Null

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
