        # SCRIPT RUN AS ADMIN
        If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
        {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit}
        $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
        $Host.UI.RawUI.BackgroundColor = "Black"
        $Host.PrivateData.ProgressBackgroundColor = "Black"
        $Host.PrivateData.ProgressForegroundColor = "White"
        Clear-Host

        Write-Host "1. AMD Settings: On (Recommended)"
        Write-Host "2. AMD Settings: Default`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

# open & close amd software adrenalin edition settings page so settings stick
Start-Process "$env:SystemDrive\Program Files\AMD\CNext\CNext\RadeonSoftware.exe"
Start-Sleep -Seconds 30
Stop-Process -Name "RadeonSoftware" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# import amd software adrenalin edition settings
# system
# manual check for updates
cmd /c "reg add `"HKCU\Software\AMD\CN`" /v `"AutoUpdate`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# disable issue detection
cmd /c "reg add `"HKCU\Software\AMD\AIM`" /v `"LaunchBugTool`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# hotkeys
# disable use hotkeys
cmd /c "reg add `"HKCU\Software\AMD\DVR`" /v `"HotkeysDisabled`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

# preferences
# disable system tray menu
cmd /c "reg add `"HKCU\Software\AMD\CN`" /v `"SystemTray`" /t REG_SZ /d `"false`" /f >nul 2>&1"

# disable in game overlay
cmd /c "reg add `"HKCU\Software\AMD\DVR`" /v `"ShowRSOverlay`" /t REG_SZ /d `"false`" /f >nul 2>&1"

# disable web browser
cmd /c "reg add `"HKCU\Software\AMD\CN`" /v `"RSXBrowserUnavailable`" /t REG_SZ /d `"true`" /f >nul 2>&1"

# disable advertisements
cmd /c "reg add `"HKCU\Software\AMD\CN`" /v `"AllowWebContent`" /t REG_SZ /d `"false`" /f >nul 2>&1"

# disable toast notifications
cmd /c "reg add `"HKCU\Software\AMD\CN`" /v `"CN_Hide_Toast_Notification`" /t REG_SZ /d `"true`" /f >nul 2>&1"

# disable animation & effects
cmd /c "reg add `"HKCU\Software\AMD\CN`" /v `"AnimationEffect`" /t REG_SZ /d `"false`" /f >nul 2>&1"

# graphics
# graphics profile - custom
cmd /c "reg add `"HKCU\Software\AMD\CN`" /v `"WizardProfile`" /t REG_SZ /d `"PROFILE_CUSTOM`" /f >nul 2>&1"

# wait for vertical refresh - always off
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
$allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
$optionKeys = $allKeys | Where-Object { $_.PSChildName -eq "UMD" }
foreach ($key in $optionKeys) {
$regPath = $key.Name
cmd /c "reg add `"$regPath`" /v `"VSyncControl`" /t REG_BINARY /d `"3000`" /f >nul 2>&1"
}

# texture filtering quality - performance
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
$allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
$optionKeys = $allKeys | Where-Object { $_.PSChildName -eq "UMD" }
foreach ($key in $optionKeys) {
$regPath = $key.Name
cmd /c "reg add `"$regPath`" /v `"TFQ`" /t REG_BINARY /d `"3200`" /f >nul 2>&1"
}

# tessellation mode - override application settings
# maximum tessellation level - off
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
$allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
$optionKeys = $allKeys | Where-Object { $_.PSChildName -eq "UMD" }
foreach ($key in $optionKeys) {
$regPath = $key.Name
cmd /c "reg add `"$regPath`" /v `"Tessellation`" /t REG_BINARY /d `"3100`" /f >nul 2>&1"
cmd /c "reg add `"$regPath`" /v `"Tessellation_OPTION`" /t REG_BINARY /d `"3200`" /f >nul 2>&1"
}

# display
# accept custom resolution eula
cmd /c "reg add `"HKCU\Software\AMD\CN\CustomResolutions`" /v `"EulaAccepted`" /t REG_SZ /d `"true`" /f >nul 2>&1"

# accept overrides eula
cmd /c "reg add `"HKCU\Software\AMD\CN\DisplayOverride`" /v `"EulaAccepted`" /t REG_SZ /d `"true`" /f >nul 2>&1"

# vari-bright - maximize brightness
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
$allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
$optionKeys = $allKeys | Where-Object { $_.PSChildName -eq "power_v1" }
foreach ($key in $optionKeys) {
$regPath = $key.Name
cmd /c "reg add `"$regPath`" /v `"abmlevel`" /t REG_BINARY /d `"00000000`" /f >nul 2>&1"
}

# performance
# tuning
# manual tuning - custom
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
$adapterKeys = Get-ChildItem -Path $basePath -ErrorAction SilentlyContinue
foreach ($key in $adapterKeys) {
if ($key.PSChildName -match '^\d{4}$') {
$regPath = $key.Name
cmd /c "reg add `"$regPath`" /v `"IsAutoDefault`" /t REG_BINARY /d `"00000000`" /f >nul 2>&1"
}
}

# gpu tuning - enabled
# fan tuning - enabled
# vram tuning - enabled
# power tuning - enabled
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
$adapterKeys = Get-ChildItem -Path $basePath -ErrorAction SilentlyContinue
foreach ($key in $adapterKeys) {
if ($key.PSChildName -match '^\d{4}$') {
$regPath = $key.Name
cmd /c "reg add `"$regPath`" /v `"IsComponentControl`" /t REG_BINARY /d `"0f000000`" /f >nul 2>&1"
}
}

# notifications - remove
cmd /c "reg delete `"HKCU\Software\AMD\CN\Notification`" /f >nul 2>&1"
cmd /c "reg add `"HKCU\Software\AMD\CN\Notification`" /f >nul 2>&1"
cmd /c "reg add `"HKCU\Software\AMD\CN\FreeSync`" /v `"AlreadyNotified`" /t REG_DWORD /d `"1`" /f >nul 2>&1"
cmd /c "reg add `"HKCU\Software\AMD\CN\OverlayNotification`" /v `"AlreadyNotified`" /t REG_DWORD /d `"1`" /f >nul 2>&1"
cmd /c "reg add `"HKCU\Software\AMD\CN\VirtualSuperResolution`" /v `"AlreadyNotified`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

exit

          }
        2 {

Clear-Host

# import amd software adrenalin edition settings
# system
# revert manual check for updates
cmd /c "reg delete `"HKCU\Software\AMD\CN`" /v `"AutoUpdate`" /f >nul 2>&1"

# revert disable issue detection
cmd /c "reg add `"HKCU\Software\AMD\AIM`" /v `"LaunchBugTool`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

# hotkeys
# revert disable use hotkeys
cmd /c "reg delete `"HKCU\Software\AMD\DVR`" /v `"HotkeysDisabled`" /f >nul 2>&1"

# preferences
# revert disable system tray menu
cmd /c "reg delete `"HKCU\Software\AMD\CN`" /v `"SystemTray`" /f >nul 2>&1"

# revert disable in game overlay
cmd /c "reg delete `"HKCU\Software\AMD\DVR`" /v `"ShowRSOverlay`" /f >nul 2>&1"

# revert disable web browser
cmd /c "reg delete `"HKCU\Software\AMD\CN`" /v `"RSXBrowserUnavailable`" /f >nul 2>&1"

# revert disable advertisements
cmd /c "reg delete `"HKCU\Software\AMD\CN`" /v `"AllowWebContent`" /f >nul 2>&1"

# revert disable toast notifications
cmd /c "reg delete `"HKCU\Software\AMD\CN`" /v `"CN_Hide_Toast_Notification`" /f >nul 2>&1"

# revert disable animation & effects
cmd /c "reg delete `"HKCU\Software\AMD\CN`" /v `"AnimationEffect`" /f >nul 2>&1"

# graphics
# revert graphics profile - custom
cmd /c "reg delete `"HKCU\Software\AMD\CN`" /v `"WizardProfile`" /f >nul 2>&1"

# revert wait for vertical refresh - always off
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
$allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
$optionKeys = $allKeys | Where-Object { $_.PSChildName -eq "UMD" }
foreach ($key in $optionKeys) {
$regPath = $key.Name
cmd /c "reg add `"$regPath`" /v `"VSyncControl`" /t REG_BINARY /d `"31000000`" /f >nul 2>&1"
}

# revert texture filtering quality - performance
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
$allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
$optionKeys = $allKeys | Where-Object { $_.PSChildName -eq "UMD" }
foreach ($key in $optionKeys) {
$regPath = $key.Name
cmd /c "reg delete `"$regPath`" /v `"TFQ`" /f >nul 2>&1"
}

# revert tessellation mode - override application settings
# revert maximum tessellation level - off
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
$allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
$optionKeys = $allKeys | Where-Object { $_.PSChildName -eq "UMD" }
foreach ($key in $optionKeys) {
$regPath = $key.Name
cmd /c "reg add `"$regPath`" /v `"Tessellation`" /t REG_BINARY /d `"360034000000`" /f >nul 2>&1"
cmd /c "reg add `"$regPath`" /v `"Tessellation_OPTION`" /t REG_BINARY /d `"30000000`" /f >nul 2>&1"
}

# display
# revert accept custom resolution eula
cmd /c "reg delete `"HKCU\Software\AMD\CN\CustomResolutions`" /f >nul 2>&1"

# revert accept overrides eula
cmd /c "reg delete `"HKCU\Software\AMD\CN\DisplayOverride`" /f >nul 2>&1"

# revert vari-bright - maximize brightness
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
$allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
$optionKeys = $allKeys | Where-Object { $_.PSChildName -eq "power_v1" }
foreach ($key in $optionKeys) {
$regPath = $key.Name
cmd /c "reg delete `"$regPath`" /v `"abmlevel`" /f >nul 2>&1"
}

# performance
# tuning
# revert manual tuning - custom
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
$adapterKeys = Get-ChildItem -Path $basePath -ErrorAction SilentlyContinue
foreach ($key in $adapterKeys) {
if ($key.PSChildName -match '^\d{4}$') {
$regPath = $key.Name
cmd /c "reg add `"$regPath`" /v `"IsAutoDefault`" /t REG_DWORD /d `"1`" /f >nul 2>&1"
}
}

# revert gpu tuning - enabled
# revert fan tuning - enabled
# revert vram tuning - enabled
# revert power tuning - enabled
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
$adapterKeys = Get-ChildItem -Path $basePath -ErrorAction SilentlyContinue
foreach ($key in $adapterKeys) {
if ($key.PSChildName -match '^\d{4}$') {
$regPath = $key.Name
cmd /c "reg add `"$regPath`" /v `"IsComponentControl`" /t REG_BINARY /d `"00000000`" /f >nul 2>&1"
}
}

# revert notifications - remove
cmd /c "reg delete `"HKCU\Software\AMD\CN\Notification`" /f >nul 2>&1"
cmd /c "reg delete `"HKCU\Software\AMD\CN\FreeSync`" /f >nul 2>&1"
cmd /c "reg delete `"HKCU\Software\AMD\CN\OverlayNotification`" /f >nul 2>&1"
cmd /c "reg delete `"HKCU\Software\AMD\CN\VirtualSuperResolution`" /f >nul 2>&1"
exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }