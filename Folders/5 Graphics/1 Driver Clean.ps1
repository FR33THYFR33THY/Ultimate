. $CommonScript

Ensure-Admin
Testing-Connection

        # SCRIPT SILENT
        $progresspreference = 'silentlycontinue'


        Write-Host "1. DDU: Auto"
        Write-Host "2. DDU: Manual`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

        Clear-Host

## explorer "https://www.7-zip.org"
Write-Host "Installing: 7-Zip File Manager`n"

# download 7zip
Get-FileFromWeb -URL "https://www.7-zip.org/a/7z2301-x64.exe" -File "$env:SystemRoot\Temp\7 Zip.exe"

# install 7zip
Start-Process -Wait "$env:SystemRoot\Temp\7 Zip.exe" -ArgumentList "/S"

# set config for 7zip
cmd /c "reg add `"HKEY_CURRENT_USER\Software\7-Zip\Options`" /v `"ContextMenu`" /t REG_DWORD /d `"259`" /f >nul 2>&1"
cmd /c "reg add `"HKEY_CURRENT_USER\Software\7-Zip\Options`" /v `"CascadedMenu`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# cleaner 7zip start menu shortcut path
Move-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip\7-Zip File Manager.lnk" -Destination "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Force -ErrorAction SilentlyContinue | Out-Null
Remove-Item "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

## explorer "https://www.wagnardsoft.com/display-driver-uninstaller-ddu"
Write-Host "Downloading: Display Driver Uninstaller`n"
        
# download ddu
Get-FileFromWeb -URL "https://www.wagnardsoft.com/DDU/download/DDU%20v18.1.4.2_setup.exe" -File "$env:SystemRoot\Temp\DDU.exe"

# extract ddu with 7zip
& "C:\Program Files\7-Zip\7z.exe" x "$env:SystemRoot\Temp\DDU.exe" -o"$env:SystemRoot\Temp\DDU" -y | Out-Null

# set config for ddu
$DduConfig = @'
<?xml version="1.0" encoding="utf-8"?>
<DisplayDriverUninstaller Version="18.1.4.2">
	<Settings>
		<SelectedLanguage>en-US</SelectedLanguage>
		<RemoveMonitors>True</RemoveMonitors>
		<RemoveCrimsonCache>True</RemoveCrimsonCache>
		<RemoveAMDDirs>True</RemoveAMDDirs>
		<RemoveAudioBus>True</RemoveAudioBus>
		<RemoveAMDKMPFD>True</RemoveAMDKMPFD>
		<RemoveNvidiaDirs>True</RemoveNvidiaDirs>
		<RemovePhysX>True</RemovePhysX>
		<Remove3DTVPlay>True</Remove3DTVPlay>
		<RemoveGFE>True</RemoveGFE>
		<RemoveNVBROADCAST>True</RemoveNVBROADCAST>
		<RemoveNVCP>True</RemoveNVCP>
		<RemoveINTELCP>True</RemoveINTELCP>
		<RemoveINTELIGS>True</RemoveINTELIGS>
		<RemoveOneAPI>True</RemoveOneAPI>
		<RemoveEnduranceGaming>True</RemoveEnduranceGaming>
		<RemoveIntelNpu>True</RemoveIntelNpu>
		<RemoveAMDCP>True</RemoveAMDCP>
		<UseRoamingConfig>False</UseRoamingConfig>
		<CheckUpdates>False</CheckUpdates>
		<CreateRestorePoint>False</CreateRestorePoint>
		<SaveLogs>False</SaveLogs>
		<RemoveVulkan>True</RemoveVulkan>
		<ShowOffer>False</ShowOffer>
		<EnableSafeModeDialog>False</EnableSafeModeDialog>
		<PreventWinUpdate>True</PreventWinUpdate>
		<UsedBCD>False</UsedBCD>
		<KeepNVCPopt>False</KeepNVCPopt>
		<RememberLastChoice>False</RememberLastChoice>
		<LastSelectedGPUIndex>0</LastSelectedGPUIndex>
		<LastSelectedTypeIndex>0</LastSelectedTypeIndex>
	</Settings>
</DisplayDriverUninstaller>
'@
Set-Content -Path "$env:SystemRoot\Temp\DDU\Settings\Settings.xml" -Value $DduConfig -Force

# set ddu config to read only
Set-ItemProperty -Path "$env:SystemRoot\Temp\DDU\Settings\Settings.xml" -Name IsReadOnly -Value $true

# prevent downloads of drivers from windows update
cmd /c "reg add `"HKLM\Software\Microsoft\Windows\CurrentVersion\DriverSearching`" /v `"SearchOrderConfig`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# create ddu ps1 file
$DDU = @'
	    # REMOVE WINLOGON STEPONE PS1 FILE
        cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`" /v `"Userinit`" /t REG_SZ /d `"C:\WINDOWS\system32\userinit.exe,`" /f >nul 2>&1"

# start explorer
Start-Process explorer

# remove safe mode boot
cmd /c "bcdedit /deletevalue {current} safeboot >nul 2>&1"

Write-Host "DDU & RESTARTING`n" -ForegroundColor Red

# uninstall soundblaster realtek intel amd nvidia drivers & restart
Start-Process "$env:SystemRoot\Temp\DDU\Display Driver Uninstaller.exe" -ArgumentList "-CleanSoundBlaster -CleanRealtek -CleanAllGpus -Restart" -Wait
'@
Set-Content -Path "$env:SystemRoot\Temp\DDU.ps1" -Value $DDU -Force

# install winlogon ddu ps1 file to run in safe boot
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`" /v `"Userinit`" /t REG_SZ /d `"powershell.exe -nop -ep bypass -WindowStyle Maximized -f $env:SystemRoot\Temp\DDU.ps1`" /f >nul 2>&1"

# turn on safe boot
cmd /c "bcdedit /set {current} safeboot minimal >nul 2>&1"

Write-Host "RESTARTING`n" -ForegroundColor Red

# restart
Start-Sleep -Seconds 5
shutdown -r -t 00

exit

          }
        2 {

        Clear-Host

## explorer "https://www.7-zip.org"
Write-Host "Installing: 7-Zip File Manager`n"

# download 7zip
Get-FileFromWeb -URL "https://www.7-zip.org/a/7z2301-x64.exe" -File "$env:SystemRoot\Temp\7 Zip.exe"

# install 7zip
Start-Process -Wait "$env:SystemRoot\Temp\7 Zip.exe" -ArgumentList "/S"

# set config for 7zip
cmd /c "reg add `"HKEY_CURRENT_USER\Software\7-Zip\Options`" /v `"ContextMenu`" /t REG_DWORD /d `"259`" /f >nul 2>&1"
cmd /c "reg add `"HKEY_CURRENT_USER\Software\7-Zip\Options`" /v `"CascadedMenu`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# cleaner 7zip start menu shortcut path
Move-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip\7-Zip File Manager.lnk" -Destination "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Force -ErrorAction SilentlyContinue | Out-Null
Remove-Item "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

## explorer "https://www.wagnardsoft.com/display-driver-uninstaller-ddu"
Write-Host "Downloading: Display Driver Uninstaller`n"

# download ddu
Get-FileFromWeb -URL "https://www.wagnardsoft.com/DDU/download/DDU%20v18.1.4.2_setup.exe" -File "$env:SystemRoot\Temp\DDU.exe"

# extract ddu with 7zip
& "C:\Program Files\7-Zip\7z.exe" x "$env:SystemRoot\Temp\DDU.exe" -o"$env:SystemRoot\Temp\DDU" -y | Out-Null

# set config for ddu
$DduConfig = @'
<?xml version="1.0" encoding="utf-8"?>
<DisplayDriverUninstaller Version="18.1.4.2">
	<Settings>
		<SelectedLanguage>en-US</SelectedLanguage>
		<RemoveMonitors>True</RemoveMonitors>
		<RemoveCrimsonCache>True</RemoveCrimsonCache>
		<RemoveAMDDirs>True</RemoveAMDDirs>
		<RemoveAudioBus>True</RemoveAudioBus>
		<RemoveAMDKMPFD>True</RemoveAMDKMPFD>
		<RemoveNvidiaDirs>True</RemoveNvidiaDirs>
		<RemovePhysX>True</RemovePhysX>
		<Remove3DTVPlay>True</Remove3DTVPlay>
		<RemoveGFE>True</RemoveGFE>
		<RemoveNVBROADCAST>True</RemoveNVBROADCAST>
		<RemoveNVCP>True</RemoveNVCP>
		<RemoveINTELCP>True</RemoveINTELCP>
		<RemoveINTELIGS>True</RemoveINTELIGS>
		<RemoveOneAPI>True</RemoveOneAPI>
		<RemoveEnduranceGaming>True</RemoveEnduranceGaming>
		<RemoveIntelNpu>True</RemoveIntelNpu>
		<RemoveAMDCP>True</RemoveAMDCP>
		<UseRoamingConfig>False</UseRoamingConfig>
		<CheckUpdates>False</CheckUpdates>
		<CreateRestorePoint>False</CreateRestorePoint>
		<SaveLogs>False</SaveLogs>
		<RemoveVulkan>True</RemoveVulkan>
		<ShowOffer>False</ShowOffer>
		<EnableSafeModeDialog>False</EnableSafeModeDialog>
		<PreventWinUpdate>True</PreventWinUpdate>
		<UsedBCD>False</UsedBCD>
		<KeepNVCPopt>False</KeepNVCPopt>
		<RememberLastChoice>False</RememberLastChoice>
		<LastSelectedGPUIndex>0</LastSelectedGPUIndex>
		<LastSelectedTypeIndex>0</LastSelectedTypeIndex>
	</Settings>
</DisplayDriverUninstaller>
'@
Set-Content -Path "$env:SystemRoot\Temp\DDU\Settings\Settings.xml" -Value $DduConfig -Force

# set ddu config to read only
Set-ItemProperty -Path "$env:SystemRoot\Temp\DDU\Settings\Settings.xml" -Name IsReadOnly -Value $true

# prevent downloads of drivers from windows update
cmd /c "reg add `"HKLM\Software\Microsoft\Windows\CurrentVersion\DriverSearching`" /v `"SearchOrderConfig`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# create ddu ps1 file
$DDU = @'
	    # REMOVE WINLOGON STEPONE PS1 FILE
        cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`" /v `"Userinit`" /t REG_SZ /d `"C:\WINDOWS\system32\userinit.exe,`" /f >nul 2>&1"

# start explorer
start-process explorer

# remove safe mode boot
cmd /c "bcdedit /deletevalue {current} safeboot >nul 2>&1"

Write-Host "DDU & MANUAL`n"

# open ddu
Start-Process "$env:SystemRoot\Temp\DDU\Display Driver Uninstaller.exe"
'@
Set-Content -Path "$env:SystemRoot\Temp\DDU.ps1" -Value $DDU -Force

# install winlogon ddu ps1 file to run in safe boot
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`" /v `"Userinit`" /t REG_SZ /d `"powershell.exe -nop -ep bypass -WindowStyle Maximized -f $env:SystemRoot\Temp\DDU.ps1`" /f >nul 2>&1"

# turn on safe boot
cmd /c "bcdedit /set {current} safeboot minimal >nul 2>&1"

Write-Host "RESTARTING`n" -ForegroundColor Red

# restart
Start-Sleep -Seconds 5
shutdown -r -t 00

exit

      }
    } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
