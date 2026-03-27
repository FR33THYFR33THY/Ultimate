. $CommonScript

Ensure-Admin
Testing-Connection

        # SCRIPT SILENT
        $progresspreference = 'silentlycontinue'

        Write-Host "1. Gamebar Xbox: Off (Recommended)"
        Write-Host "2. Gamebar Xbox: Default`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "Gamebar Xbox: Off..."

# create reg file
$GameBarOff = @"
Windows Registry Editor Version 5.00

; disable game bar
[HKEY_CURRENT_USER\System\GameConfigStore]
"GameDVR_Enabled"=dword:00000000

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\GameDVR]
"AppCaptureEnabled"=dword:00000000

; disable enable open xbox game bar using game controller
[HKEY_CURRENT_USER\Software\Microsoft\GameBar]
"UseNexusForGameBarEnabled"=dword:00000000

; disable use view + menu as guide button in apps
[HKEY_CURRENT_USER\Software\Microsoft\GameBar]
"GamepadNexusChordEnabled"=dword:00000000

; disable ms-gamebar notifications with xbox controller plugged in
[HKEY_CLASSES_ROOT\ms-gamebar]
"(Default)"="URL:ms-gamebar"
"URL Protocol"=""
"NoOpenWith"=""

[HKEY_CLASSES_ROOT\ms-gamebar\shell\open\command]
"(Default)"="%SystemRoot%\\System32\\systray.exe"

[HKEY_CLASSES_ROOT\ms-gamebarservices]
"(Default)"="URL:ms-gamebarservices"
"URL Protocol"=""
"NoOpenWith"=""

[HKEY_CLASSES_ROOT\ms-gamebarservices\shell\open\command]
"(Default)"="%SystemRoot%\\System32\\systray.exe"

[HKEY_CLASSES_ROOT\ms-gamingoverlay]
"(Default)"="URL:ms-gamingoverlay"
"URL Protocol"=""
"NoOpenWith"=""

[HKEY_CLASSES_ROOT\ms-gamingoverlay\shell\open\command]
"(Default)"="%SystemRoot%\\System32\\systray.exe"

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter]
"ActivationType"=dword:00000000
"@
Set-Content -Path "$env:SystemRoot\Temp\GameBarOff.reg" -Value $GameBarOff -Force

# import reg file
Start-Process -Wait "regedit.exe" -ArgumentList "/S `"$env:SystemRoot\Temp\GameBarOff.reg`"" -WindowStyle Hidden

# stop gamebar running
Stop-Process -Force -Name GameBar -ErrorAction SilentlyContinue | Out-Null

# uninstall gamebar & xbox apps
Get-AppXPackage -AllUsers | Where-Object {
$_.Name -like '*Gaming*' -or
$_.Name -like '*Xbox*'
} | Remove-AppxPackage -ErrorAction SilentlyContinue

# stop microsoft gameinput running
cmd /c "sc stop `"GameInputSvc`" >nul 2>&1"
$stop = "gamingservices", "gamingservicesnet", "GameInputRedistService"
$stop | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }
Start-Sleep -Seconds 2

# uninstall microsoft gameinput
$findmicrosoftgameinput = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
$microsoftgameinput = Get-ItemProperty $findmicrosoftgameinput -ErrorAction SilentlyContinue |
Where-Object { $_.DisplayName -like "*Microsoft GameInput*" }
if ($microsoftgameinput) {
$guid = $microsoftgameinput.PSChildName
Start-Process "msiexec.exe" -ArgumentList "/x $guid /qn /norestart" -Wait -NoNewWindow
}

# stop microsoft gameinput running again
cmd /c "sc stop `"GameInputSvc`" >nul 2>&1"
$stop = "gamingservices", "gamingservicesnet", "GameInputRedistService"
$stop | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }

exit

          }
        2 {

Clear-Host

Write-Host "Gamebar Xbox: Default..."

# create reg file
$GameBarOn = @"
Windows Registry Editor Version 5.00

; game bar
[HKEY_CURRENT_USER\System\GameConfigStore]
"GameDVR_Enabled"=dword:00000000

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\GameDVR]
"AppCaptureEnabled"=-

; enable open xbox game bar using game controller
[HKEY_CURRENT_USER\Software\Microsoft\GameBar]
"UseNexusForGameBarEnabled"=-

; enable use view + menu as guide button in apps
[HKEY_CURRENT_USER\Software\Microsoft\GameBar]
"GamepadNexusChordEnabled"=-

; ms-gamebar notifications with xbox controller plugged in regedit
[-HKEY_CLASSES_ROOT\ms-gamebar]

[HKEY_CLASSES_ROOT\ms-gamebar]
"URL Protocol"=""
@="URL:ms-gamebar"

[-HKEY_CLASSES_ROOT\ms-gamebar\shell\open\command]

[-HKEY_CLASSES_ROOT\ms-gamebarservices]

[-HKEY_CLASSES_ROOT\ms-gamebarservices\shell\open\command]

[-HKEY_CLASSES_ROOT\ms-gamingoverlay]

[HKEY_CLASSES_ROOT\ms-gamingoverlay]
"URL Protocol"=""
@="URL:ms-gamingoverlay"

[-HKEY_CLASSES_ROOT\ms-gamingoverlay\shell\open\command]

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter]
"ActivationType"=dword:00000001

; gameinput service
[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\GameInputSvc]
"Start"=dword:00000003

; gamedvr and broadcast user service
[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BcastDVRUserService]
"Start"=dword:00000003

; xbox accessory management service
[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\XboxGipSvc]
"Start"=dword:00000003

; xbox live auth manager service
[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\XblAuthManager]
"Start"=dword:00000003

; xbox live game save service
[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\XblGameSave]
"Start"=dword:00000003

; xbox live networking service
[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\XboxNetApiSvc]
"Start"=dword:00000003
"@
Set-Content -Path "$env:SystemRoot\Temp\GameBarOn.reg" -Value $GameBarOn -Force

# import reg file
Start-Process -Wait "regedit.exe" -ArgumentList "/S `"$env:SystemRoot\Temp\GameBarOn.reg`"" -WindowStyle Hidden

# install store, gamebar & xbox apps
Get-AppXPackage -AllUsers | Where-Object {
$_.Name -like '*Gaming*' -or
$_.Name -like '*Xbox*' -or
$_.Name -like '*Store*'
} | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register -ErrorAction SilentlyContinue "$($_.InstallLocation)\AppXManifest.xml"}

# download edge webview installer
Get-FileFromWeb -URL "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/79f5276c-391e-481d-9e0f-50d730ae66a9/MicrosoftEdgeWebView2RuntimeInstallerX64.exe" -File "$env:SystemRoot\Temp\EdgeWebView.exe"

# start edge webview installer
Start-Process -Wait "$env:SystemRoot\Temp\EdgeWebView.exe"

# download gamebar repair tool
Get-FileFromWeb -URL "https://aka.ms/GamingRepairTool" -File "$env:SystemRoot\Temp\GamingRepairTool.exe"

# start gamebar repair too
Start-Process "$env:SystemRoot\Temp\GamingRepairTool.exe"

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
