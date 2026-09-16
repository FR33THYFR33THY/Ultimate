        # SCRIPT RUN AS ADMIN
        If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
        {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit}
        $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
        $Host.UI.RawUI.BackgroundColor = "Black"
        $Host.PrivateData.ProgressBackgroundColor = "Black"
        $Host.PrivateData.ProgressForegroundColor = "White"
        Clear-Host

        Write-Host "1. Network Adapter Power Savings & Wake: Off (Recommended)"
        Write-Host "2. Network Adapter Power Savings & Wake: Default`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "Network Adapter Power Savings & Wake: Off..."

# disable network adapter powersaving & wake on all connected devices
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}"
$adapterKeys = Get-ChildItem -Path $basePath -ErrorAction SilentlyContinue
foreach ($key in $adapterKeys) {
if ($key.PSChildName -match '^\d{4}$') {
$regPath = $key.Name

# disable adapter powersaving & wake
cmd /c "reg add `"$regPath`" /v `"PnPCapabilities`" /t REG_DWORD /d `"24`" /f >nul 2>&1"

# disable advanced energy efficient ethernet
cmd /c "reg add `"$regPath`" /v `"AdvancedEEE`" /t REG_SZ /d `"0`" /f >nul 2>&1"

# disable energy-efficient ethernet
cmd /c "reg add `"$regPath`" /v `"*EEE`" /t REG_SZ /d `"0`" /f >nul 2>&1"
cmd /c "reg add `"$regPath`" /v `"EEELinkAdvertisement`" /t REG_SZ /d `"0`" /f >nul 2>&1"

# system idle power saver
cmd /c "reg add `"$regPath`" /v `"SipsEnabled`" /t REG_SZ /d `"0`" /f >nul 2>&1"

# ultra low power mode
cmd /c "reg add `"$regPath`" /v `"ULPMode`" /t REG_SZ /d `"0`" /f >nul 2>&1"

# disable gigabit lite
cmd /c "reg add `"$regPath`" /v `"GigaLite`" /t REG_SZ /d `"0`" /f >nul 2>&1"

# disable green ethernet
cmd /c "reg add `"$regPath`" /v `"EnableGreenEthernet`" /t REG_SZ /d `"0`" /f >nul 2>&1"

# disable power saving mode
cmd /c "reg add `"$regPath`" /v `"PowerSavingMode`" /t REG_SZ /d `"0`" /f >nul 2>&1"

# disable all wake
cmd /c "reg add `"$regPath`" /v `"S5WakeOnLan`" /t REG_SZ /d `"0`" /f >nul 2>&1"
cmd /c "reg add `"$regPath`" /v `"*WakeOnMagicPacket`" /t REG_SZ /d `"0`" /f >nul 2>&1"
cmd /c "reg add `"$regPath`" /v `"*ModernStandbyWoLMagicPacket`" /t REG_SZ /d `"0`" /f >nul 2>&1"
cmd /c "reg add `"$regPath`" /v `"*WakeOnPattern`" /t REG_SZ /d `"0`" /f >nul 2>&1"
cmd /c "reg add `"$regPath`" /v `"WakeOnLink`" /t REG_SZ /d `"0`" /f >nul 2>&1"
cmd /c "reg add `"$regPath`" /v `"*ModernStandbyWoLMagicPacket`" /t REG_SZ /d `"0`" /f >nul 2>&1"
}
}

exit

          }
        2 {

Clear-Host

Write-Host "Network Adapter Power Savings & Wake: Default..."

# revert disable network adapter powersaving & wake on all connected devices
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}"
$adapterKeys = Get-ChildItem -Path $basePath -ErrorAction SilentlyContinue
foreach ($key in $adapterKeys) {
if ($key.PSChildName -match '^\d{4}$') {
$regPath = $key.Name

# revert disable adapter powersaving & wake
cmd /c "reg delete `"$regPath`" /v `"PnPCapabilities`" /f >nul 2>&1"

# revert disable advanced energy efficient ethernet
cmd /c "reg delete `"$regPath`" /v `"AdvancedEEE`" /f >nul 2>&1"

# revert disable energy-efficient ethernet
cmd /c "reg delete `"$regPath`" /v `"*EEE`" /f >nul 2>&1"
cmd /c "reg delete `"$regPath`" /v `"EEELinkAdvertisement`" /f >nul 2>&1"

# revert system idle power saver
cmd /c "reg delete `"$regPath`" /v `"SipsEnabled`" /f >nul 2>&1"

# revert ultra low power mode
cmd /c "reg delete `"$regPath`" /v `"ULPMode`" /f >nul 2>&1"

# revert disable gigabit lite
cmd /c "reg delete `"$regPath`" /v `"GigaLite`" /f >nul 2>&1"

# revert disable green ethernet
cmd /c "reg delete `"$regPath`" /v `"EnableGreenEthernet`" /f >nul 2>&1"

# revert disable power saving mode
cmd /c "reg delete `"$regPath`" /v `"PowerSavingMode`" /f >nul 2>&1"

# revert disable all wake
cmd /c "reg delete `"$regPath`" /v `"S5WakeOnLan`" /f >nul 2>&1"
cmd /c "reg delete `"$regPath`" /v `"*WakeOnMagicPacket`" /f >nul 2>&1"
cmd /c "reg delete `"$regPath`" /v `"*ModernStandbyWoLMagicPacket`" /f >nul 2>&1"
cmd /c "reg delete `"$regPath`" /v `"*WakeOnPattern`" /f >nul 2>&1"
cmd /c "reg delete `"$regPath`" /v `"WakeOnLink`" /f >nul 2>&1"
cmd /c "reg delete `"$regPath`" /v `"*ModernStandbyWoLMagicPacket`" /f >nul 2>&1"
}
}

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }