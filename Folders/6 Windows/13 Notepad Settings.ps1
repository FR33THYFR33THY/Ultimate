. $CommonScript

Ensure-Admin

        Write-Host "1. Notepad Settings: On (Recommended)"
        Write-Host "2. Notepad Settings: Default`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "Notepad Settings: On..."

# stop notepad running
Stop-Process -Name "Notepad" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# create reg file
$NotepadSettings = @'
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\Settings\LocalState]
"OpenFile"=hex(5f5e104):01,00,00,00,d1,55,24,57,d1,84,db,01
"GhostFile"=hex(5f5e10b):00,42,60,f1,5a,d1,84,db,01
"RewriteEnabled"=hex(5f5e10b):00,12,4a,7f,5f,d1,84,db,01
'@
Set-Content -Path "$env:SystemRoot\Temp\NotepadSettings.reg" -Value $NotepadSettings -Force
$SettingsDat = "$env:LocalAppData\Packages\Microsoft.WindowsNotepad_8wekyb3d8bbwe\Settings\settings.dat"
$RegFileNotepadSettings = "$env:SystemRoot\Temp\NotepadSettings.reg"

# load hive
reg load "HKLM\Settings" $SettingsDat >$null 2>&1

# import reg file
if ($LASTEXITCODE -eq 0) {
reg import $RegFileNotepadSettings >$null 2>&1

# unload hive
[gc]::Collect()
Start-Sleep -Seconds 2
reg unload "HKLM\Settings" >$null 2>&1
}

exit

          }
        2 {

Clear-Host

Write-Host "Notepad Settings: Default..."

# stop notepad running
Stop-Process -Name "Notepad" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# delete settings.dat
Remove-Item "$env:LocalAppData\Packages\Microsoft.WindowsNotepad_8wekyb3d8bbwe\Settings\settings.dat" -Force

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
