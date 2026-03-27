. $CommonScript

Ensure-Admin

Write-Host "Creating: Restore Point..."

try {
# allow multiple restore points
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore`" /v `"SystemRestorePointCreationFrequency`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# enable restore point
Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue | Out-Null

# create restore point
Checkpoint-Computer -Description "backup" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue | Out-Null

# revert allow multiple restore points
cmd /c "reg delete `"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore`" /v `"SystemRestorePointCreationFrequency`" /f >nul 2>&1"
} catch { }

# open system protection
Start-Process "$env:SystemRoot\system32\control.exe" -ArgumentList "sysdm.cpl,,4"

# open system restore
Start-Process "rstrui"
