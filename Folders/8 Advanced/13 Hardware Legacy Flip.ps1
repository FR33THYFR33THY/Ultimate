. $CommonScript

Ensure-Admin

        Write-Host "1. Fullscreen Optimizations - Hardware Independent Flip: FSO (Default)"
        Write-Host "2. Fullscreen Exclusive - Hardware Legacy Flip: FSE`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

# fullscreen optimizations fso
reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "0" /f | Out-Null
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "0" /f | Out-Null
cmd /c "reg delete `"HKCU\System\GameConfigStore`" /v `"GameDVR_FSEBehavior`" /f >nul 2>&1"
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "0" /f | Out-Null

exit

          }
        2 {

Clear-Host

# fullscreen exclusive fse
reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f | Out-Null
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f | Out-Null
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f | Out-Null
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f | Out-Null

Write-Host "May also be required:`n"
Write-Host "- game.exe"
Write-Host "- properties"
Write-Host "- compatibility"
Write-Host "- disable fullscreen optimizations"
Write-Host "- apply`n"
Write-Host "DX12 does not support fullscreen exclusive mode`n"

Pause

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
