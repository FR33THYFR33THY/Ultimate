. $CommonScript

Ensure-Admin
Testing-Connection

# SCRIPT SILENT
$progresspreference = 'silentlycontinue'

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

       Write-Host "1. NVIDIA Settings: On (Recommended)"
       Write-Host "2. NVIDIA Settings: Default`n"
       while ($true) {
       $choice = Read-Host " "
       if ($choice -match '^[1-2]$') {
       switch ($choice) {
       1 {

Clear-Host

# unblock drs files
$path = "C:\ProgramData\NVIDIA Corporation\Drs"
Get-ChildItem -Path $path -Recurse | Unblock-File

# set physx to gpu
cmd /c "reg add `"HKLM\System\ControlSet001\Services\nvlddmkm\Parameters\Global\NVTweak`" /v `"NvCplPhysxAuto`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# enable developer settings
cmd /c "reg add `"HKLM\System\ControlSet001\Services\nvlddmkm\Parameters\Global\NVTweak`" /v `"NvDevToolsVisible`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

# allow access to the gpu performance counters to all users
$subkeys = Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue
foreach($key in $subkeys){
if ($key -notlike '*Configuration'){
reg add "$key" /v "RmProfilingAdminOnly" /t REG_DWORD /d "0" /f | Out-Null
}
}
cmd /c "reg add `"HKLM\System\ControlSet001\Services\nvlddmkm\Parameters\Global\NVTweak`" /v `"RmProfilingAdminOnly`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# disable show notification tray icon
cmd /c "reg add `"HKCU\Software\NVIDIA Corporation\NvTray`" /v `"StartOnLogin`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# enable nvidia legacy sharpen
cmd /c "reg add `"HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS`" /v `"EnableGR535`" /t REG_DWORD /d `"0`" /f >nul 2>&1"
cmd /c "reg add `"HKLM\SYSTEM\ControlSet001\Services\nvlddmkm\Parameters\FTS`" /v `"EnableGR535`" /t REG_DWORD /d `"0`" /f >nul 2>&1"
cmd /c "reg add `"HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters\FTS`" /v `"EnableGR535`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# download inspector
Get-FileFromWeb -URL "https://github.com/Orbmu2k/nvidiaProfileInspector/releases/download/2.4.0.31/nvidiaProfileInspector.zip" -File "$env:SystemRoot\Temp\Inspector.zip"

# extract inspector with 7zip
& "C:\Program Files\7-Zip\7z.exe" x "$env:SystemRoot\Temp\Inspector.zip" -o"$env:SystemRoot\Temp\Inspector" -y | Out-Null

# set config for inspector
$nipfile = @'
<?xml version="1.0" encoding="utf-16"?>
<ArrayOfProfile>
  <Profile>
    <ProfileName>Base Profile</ProfileName>
    <Executables/>
    <Settings>
      <ProfileSetting>
        <SettingNameInfo>Frame Rate Limiter V3</SettingNameInfo>
        <SettingID>277041154</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>GSYNC - Application Mode</SettingNameInfo>
        <SettingID>294973784</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>GSYNC - Application State</SettingNameInfo>
        <SettingID>279476687</SettingID>
        <SettingValue>4</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>GSYNC - Global Feature</SettingNameInfo>
        <SettingID>278196567</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>GSYNC - Global Mode</SettingNameInfo>
        <SettingID>278196727</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>GSYNC - Indicator Overlay</SettingNameInfo>
        <SettingID>268604728</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Maximum Pre-Rendered Frames</SettingNameInfo>
        <SettingID>8102046</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Preferred Refresh Rate</SettingNameInfo>
        <SettingID>6600001</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Ultra Low Latency - CPL State</SettingNameInfo>
        <SettingID>390467</SettingID>
        <SettingValue>2</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Ultra Low Latency - Enabled</SettingNameInfo>
        <SettingID>277041152</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Vertical Sync</SettingNameInfo>
        <SettingID>11041231</SettingID>
        <SettingValue>138504007</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Vertical Sync - Smooth AFR Behavior</SettingNameInfo>
        <SettingID>270198627</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Vertical Sync - Tear Control</SettingNameInfo>
        <SettingID>5912412</SettingID>
        <SettingValue>2525368439</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Vulkan/OpenGL Present Method</SettingNameInfo>
        <SettingID>550932728</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Antialiasing - Gamma Correction</SettingNameInfo>
        <SettingID>276652957</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Antialiasing - Mode</SettingNameInfo>
        <SettingID>276757595</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Antialiasing - Setting</SettingNameInfo>
        <SettingID>282555346</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Anisotropic Filter - Optimization</SettingNameInfo>
        <SettingID>8703344</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Anisotropic Filter - Sample Optimization</SettingNameInfo>
        <SettingID>15151633</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Anisotropic Filtering - Mode</SettingNameInfo>
        <SettingID>282245910</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Anisotropic Filtering - Setting</SettingNameInfo>
        <SettingID>270426537</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture Filtering - Negative LOD Bias</SettingNameInfo>
        <SettingID>1686376</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture Filtering - Quality</SettingNameInfo>
        <SettingID>13510289</SettingID>
        <SettingValue>20</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture Filtering - Trilinear Optimization</SettingNameInfo>
        <SettingID>3066610</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>CUDA - Force P2 State</SettingNameInfo>
        <SettingID>1343646814</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
	  <ProfileSetting>
        <SettingNameInfo>CUDA - Sysmem Fallback Policy</SettingNameInfo>
        <SettingID>283962569</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Power Management - Mode</SettingNameInfo>
        <SettingID>274197361</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Shader Cache - Cache Size</SettingNameInfo>
        <SettingID>11306135</SettingID>
        <SettingValue>4294967295</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Threaded Optimization</SettingNameInfo>
        <SettingID>549528094</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>OpenGL GDI Compatibility</SettingNameInfo>
        <SettingID>544392611</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Preferred OpenGL GPU</SettingNameInfo>
        <SettingID>550564838</SettingID>
        <SettingValue>id,2.0:268410DE,00000100,GF - (400,2,161,24564) @ (0)</SettingValue>
        <ValueType>String</ValueType>
      </ProfileSetting>
    </Settings>
  </Profile>
</ArrayOfProfile>
'@
Set-Content -Path "$env:SystemRoot\Temp\Inspector.nip" -Value $nipfile -Force

# import nip
Start-Process -wait "$env:SystemRoot\Temp\Inspector\nvidiaProfileInspector.exe" -ArgumentList "-silentImport -silent $env:SystemRoot\Temp\Inspector.nip"

# open nvidiacontrolpanel
Start-Process "shell:appsFolder\NVIDIACorp.NVIDIAControlPanel_56jybvy8sckqj!NVIDIACorp.NVIDIAControlPanel"

exit

         }
       2 {

Clear-Host

# unblock drs files
$path = "C:\ProgramData\NVIDIA Corporation\Drs"
Get-ChildItem -Path $path -Recurse | Unblock-File

# revert set physx to gpu
cmd /c "reg delete `"HKLM\System\ControlSet001\Services\nvlddmkm\Parameters\Global\NVTweak`" /v `"NvCplPhysxAuto`" /f >nul 2>&1"

# revert enable developer settings
cmd /c "reg delete `"HKLM\System\ControlSet001\Services\nvlddmkm\Parameters\Global\NVTweak`" /v `"NvDevToolsVisible`" /f >nul 2>&1"

# revert allow access to the gpu performance counters to all users
$subkeys = Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue
foreach($key in $subkeys){
if ($key -notlike '*Configuration'){
cmd /c "reg delete `"$key`" /v `"RmProfilingAdminOnly`" /f >nul 2>&1"
}
}
cmd /c "reg delete `"HKLM\System\ControlSet001\Services\nvlddmkm\Parameters\Global\NVTweak`" /v `"RmProfilingAdminOnly`" /f >nul 2>&1"

# revert disable show notification tray icon
cmd /c "reg delete `"HKCU\Software\NVIDIA Corporation\NvTray`" /f >nul 2>&1"

# revert enable nvidia legacy sharpen
cmd /c "reg add `"HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS`" /v `"EnableGR535`" /t REG_DWORD /d `"1`" /f >nul 2>&1"
cmd /c "reg add `"HKLM\SYSTEM\ControlSet001\Services\nvlddmkm\Parameters\FTS`" /v `"EnableGR535`" /t REG_DWORD /d `"1`" /f >nul 2>&1"
cmd /c "reg add `"HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters\FTS`" /v `"EnableGR535`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

# download inspector
Get-FileFromWeb -URL "https://github.com/Orbmu2k/nvidiaProfileInspector/releases/download/2.4.0.31/nvidiaProfileInspector.zip" -File "$env:SystemRoot\Temp\Inspector.zip"

# extract inspector with 7zip
& "C:\Program Files\7-Zip\7z.exe" x "$env:SystemRoot\Temp\Inspector.zip" -o"$env:SystemRoot\Temp\Inspector" -y | Out-Null

# set config for inspector
$nipfile = @'
<?xml version="1.0" encoding="utf-16"?>
<ArrayOfProfile>
  <Profile>
    <ProfileName>Base Profile</ProfileName>
    <Executeables />
    <Settings />
  </Profile>
</ArrayOfProfile>
'@
Set-Content -Path "$env:SystemRoot\Temp\Inspector.nip" -Value $nipfile -Force

# import nip
Start-Process -wait "$env:SystemRoot\Temp\Inspector\nvidiaProfileInspector.exe" -ArgumentList "-silentImport -silent $env:SystemRoot\Temp\Inspector.nip"

# open nvidiacontrolpanel
Start-Process "shell:appsFolder\NVIDIACorp.NVIDIAControlPanel_56jybvy8sckqj!NVIDIACorp.NVIDIAControlPanel"

exit

         }
       } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
