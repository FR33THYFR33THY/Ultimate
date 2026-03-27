. $CommonScript

Ensure-Admin

        # SCRIPT SILENT
        $progresspreference = 'silentlycontinue'

        # ALLOW PASSWORD SIGN IN
        cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device`" /v `"DevicePasswordLessBuildVersion`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

        function show-menu {
	    Clear-Host
        Write-Host " 1. Exit"
	    Write-Host " 2. Remove : All Bloatware (Recommended)"
        Write-Host " 3. Install: Store"
	    Write-Host " 4. Install: All UWP Apps"
        Write-Host " 5. Install: UWP Features"
        Write-Host " 6. Install: Legacy Features"
	    Write-Host " 7. Install: One Drive"
        Write-Host " 8. Install: Remote Desktop Connection"
        Write-Host " 9. Install: Snipping Tool`n"
	    	              }
	    show-menu
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-9]$') {
        switch ($choice) {
        1 {

Clear-Host

exit

          }
        2 {

Clear-Host

Write-Host "Uninstalling: UWP Apps. Please wait..`n"

Get-AppXPackage -AllUsers | Where-Object {
# breaks file explorer
$_.Name -notlike '*CBS*' -and
$_.Name -notlike '*Microsoft.AV1VideoExtension*' -and
$_.Name -notlike '*Microsoft.AVCEncoderVideoExtension*' -and
$_.Name -notlike '*Microsoft.HEIFImageExtension*' -and
$_.Name -notlike '*Microsoft.HEVCVideoExtension*' -and
$_.Name -notlike '*Microsoft.MPEG2VideoExtension*' -and
$_.Name -notlike '*Microsoft.Paint*' -and
$_.Name -notlike '*Microsoft.RawImageExtension*' -and
# breaks windows server defender
$_.Name -notlike '*Microsoft.SecHealthUI*' -and
$_.Name -notlike '*Microsoft.VP9VideoExtensions*' -and
$_.Name -notlike '*Microsoft.WebMediaExtensions*' -and
$_.Name -notlike '*Microsoft.WebpImageExtension*' -and
$_.Name -notlike '*Microsoft.Windows.Photos*' -and
# breaks windows server task bar
$_.Name -notlike '*Microsoft.Windows.ShellExperienceHost*' -and
# breaks windows server start menu
$_.Name -notlike '*Microsoft.Windows.StartMenuExperienceHost*' -and
$_.Name -notlike '*Microsoft.WindowsNotepad*' -and
$_.Name -notlike '*NVIDIACorp.NVIDIAControlPanel*' -and
# breaks windows server immersive control panel
$_.Name -notlike '*windows.immersivecontrolpanel*'
} | Remove-AppxPackage -ErrorAction SilentlyContinue

Clear-Host

Write-Host "Uninstalling: UWP Features. Please wait..`n"

Get-WindowsCapability -Online | Where-Object {
$_.Name -notlike '*Microsoft.Windows.Ethernet*' -and
# windows 10
$_.Name -notlike '*Microsoft.Windows.MSPaint*' -and
# windows 10
$_.Name -notlike '*Microsoft.Windows.Notepad*' -and
$_.Name -notlike '*Microsoft.Windows.Notepad.System*' -and
$_.Name -notlike '*Microsoft.Windows.Wifi*' -and
$_.Name -notlike '*NetFX3*' -and
# windows 11 breaks msi installers if removed
$_.Name -notlike '*VBSCRIPT*' -and
# breaks monitoring programs
$_.Name -notlike '*WMIC*' -and
# windows 10 breaks uwp snippingtool if removed
$_.Name -notlike '*Windows.Client.ShellComponents*'
} | ForEach-Object {
try {
Remove-WindowsCapability -Online -Name $_.Name | Out-Null
} catch { }
}

Clear-Host

Write-Host "Uninstalling: Legacy Features. Please wait..`n"

Get-WindowsOptionalFeature -Online | Where-Object {
$_.FeatureName -notlike '*DirectPlay*' -and
$_.FeatureName -notlike '*LegacyComponents*' -and
$_.FeatureName -notlike '*NetFx3*' -and
# breaks windows server turn windows features on or off
$_.FeatureName -notlike '*NetFx4*' -and
$_.FeatureName -notlike '*NetFx4-AdvSrvs*' -and
# breaks windows server turn windows features on or off
$_.FeatureName -notlike '*NetFx4ServerFeatures*' -and
# breaks search
$_.FeatureName -notlike '*SearchEngine-Client-Package*' -and
# breaks windows server desktop
$_.FeatureName -notlike '*Server-Shell*' -and
# breaks windows server defender
$_.FeatureName -notlike '*Windows-Defender*' -and
# breaks windows server internet
$_.FeatureName -notlike '*Server-Drivers-General*' -and
# breaks windows server internet
$_.FeatureName -notlike '*ServerCore-Drivers-General*' -and
# breaks windows server internet
$_.FeatureName -notlike '*ServerCore-Drivers-General-WOW64*' -and
# breaks windows server turn windows features on or off
$_.FeatureName -notlike '*Server-Gui-Mgmt*' -and
# breaks windows server nvidia app
$_.FeatureName -notlike '*WirelessNetworking*'
} | ForEach-Object {
try {
Disable-WindowsOptionalFeature -Online -FeatureName $_.FeatureName -NoRestart -WarningAction SilentlyContinue | Out-Null
} catch { }
}

Clear-Host

Write-Host "Uninstalling: Legacy Apps. Please wait..`n"

# uninstall microsoft gameinput
$findmicrosoftgameinput = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
$microsoftgameinput = Get-ItemProperty $findmicrosoftgameinput -ErrorAction SilentlyContinue |
Where-Object { $_.DisplayName -like "*Microsoft GameInput*" }
if ($microsoftgameinput) {
$guid = $microsoftgameinput.PSChildName
Start-Process "msiexec.exe" -ArgumentList "/x $guid /qn /norestart" -Wait -NoNewWindow
}

# stop onedrive running
Stop-Process -Force -Name OneDrive -ErrorAction SilentlyContinue | Out-Null

# uninstall onedrive
cmd /c "C:\Windows\System32\OneDriveSetup.exe -uninstall >nul 2>&1"
# uninstall office 365 onedrive
Get-ChildItem -Path "C:\Program Files*\Microsoft OneDrive", "$env:LOCALAPPDATA\Microsoft\OneDrive" -Filter "OneDriveSetup.exe" -Recurse -ErrorAction SilentlyContinue |
ForEach-Object { Start-Process -Wait $_.FullName -ArgumentList "/uninstall /allusers" -WindowStyle Hidden -ErrorAction SilentlyContinue }
# windows 10 uninstall onedrive
cmd /c "C:\Windows\SysWOW64\OneDriveSetup.exe -uninstall >nul 2>&1"
# windows 10 remove onedrive scheduled tasks
Get-ScheduledTask | Where-Object {$_.Taskname -match 'OneDrive'} | Unregister-ScheduledTask -Confirm:$false

# uninstall remote desktop connection
try {
Start-Process "mstsc" -ArgumentList "/Uninstall" -ErrorAction SilentlyContinue
} catch { }
# silent window for remote desktop connection
$processExists = Get-Process -Name mstsc -ErrorAction SilentlyContinue
if ($processExists) {
$running = $true
$timeout = 0
do {
$mstscProcess = Get-Process -Name mstsc -ErrorAction SilentlyContinue
if ($mstscProcess -and $mstscProcess.MainWindowHandle -ne 0) {
Stop-Process -Force -Name mstsc -ErrorAction SilentlyContinue | Out-Null
$running = $false
}
Start-Sleep -Milliseconds 100
$timeout++
if ($timeout -gt 100) {
Stop-Process -Name mstsc -Force -ErrorAction SilentlyContinue
$running = $false
}
} while ($running)
}
Start-Sleep -Seconds 1

# windows 10 uninstall old snipping tool
try {
Start-Process "C:\Windows\System32\SnippingTool.exe" -ArgumentList "/Uninstall" -ErrorAction SilentlyContinue
} catch { }
# silent window for uninstall old snipping tool
$processExists = Get-Process -Name SnippingTool -ErrorAction SilentlyContinue
if ($processExists) {
$running = $true
$timeout = 0
do {
$snipProcess = Get-Process -Name SnippingTool -ErrorAction SilentlyContinue
if ($snipProcess -and $snipProcess.MainWindowHandle -ne 0) {
Stop-Process -Force -Name SnippingTool -ErrorAction SilentlyContinue | Out-Null
$running = $false
}
Start-Sleep -Milliseconds 100
$timeout++
if ($timeout -gt 100) {
Stop-Process -Name SnippingTool -Force -ErrorAction SilentlyContinue
$running = $false
}
} while ($running)
}
Start-Sleep -Seconds 1

# windows 10 uninstall update for windows 10 for x64-based systems
$findupdateforwindows = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
$updateforwindows = Get-ItemProperty $findupdateforwindows -ErrorAction SilentlyContinue |
Where-Object { $_.DisplayName -like "*Update for x64-based Windows Systems*" }
if ($updateforwindows) {
$guid = $updateforwindows.PSChildName
Start-Process "msiexec.exe" -ArgumentList "/x $guid /qn /norestart" -Wait -NoNewWindow
}

# windows 10 uninstall microsoft update health tools
$findupdatehealthtools = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
$updatehealthtools = Get-ItemProperty $findupdatehealthtools -ErrorAction SilentlyContinue |
Where-Object { $_.DisplayName -like "*Microsoft Update Health Tools*" }
if ($updatehealthtools) {
$guid = $updatehealthtools.PSChildName
Start-Process "msiexec.exe" -ArgumentList "/x $guid /qn /norestart" -Wait -NoNewWindow
}
cmd /c "reg delete `"HKLM\SYSTEM\ControlSet001\Services\uhssvc`" /f >nul 2>&1"
Unregister-ScheduledTask -TaskName PLUGScheduler -Confirm:$false -ErrorAction SilentlyContinue | Out-Null

show-menu

          }
        3 {

Clear-Host

Write-Host "Installing: Store. Please wait..."

# install store
Get-AppXPackage -AllUsers | Where-Object {
$_.Name -like '*Store*'
} | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register -ErrorAction SilentlyContinue "$($_.InstallLocation)\AppXManifest.xml"}

Start-Sleep -Seconds 5

Clear-Host

Write-Host "Store Settings: Optimize..."

# open store settings page so disable personalized experiences on ms account sticks
try {
Start-Process "ms-windows-store:settings"
} catch { }
Start-Sleep -Seconds 5

# stop store running
$stop = "WinStore.App", "backgroundTaskHost", "StoreDesktopExtension"
$stop | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }
Start-Sleep -Seconds 2

# disable apps updates
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate`" /v `"AutoDownload`" /t REG_DWORD /d `"2`" /f >nul 2>&1"

# create reg file
$storesettings = @'
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\Settings\LocalState]
; disable video autoplay
"VideoAutoplay"=hex(5f5e10b):00,96,9d,69,8d,cd,93,dc,01
; disable notifications for app installations
"EnableAppInstallNotifications"=hex(5f5e10b):00,36,d0,88,8e,cd,93,dc,01

[HKEY_LOCAL_MACHINE\Settings\LocalState\PersistentSettings]
; disable personalized experiences
"PersonalizationEnabled"=hex(5f5e10b):00,0d,56,a1,8a,cd,93,dc,01
'@
Set-Content -Path "$env:SystemRoot\Temp\WindowsStore.reg" -Value $storesettings -Force
$settingsdat = "$env:LocalAppData\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\Settings\settings.dat"
$regfilewindowsstore = "$env:SystemRoot\Temp\WindowsStore.reg"

# load hive
reg load "HKLM\Settings" $settingsdat >$null 2>&1

# import reg file
if ($LASTEXITCODE -eq 0) {
reg import $regfilewindowsstore >$null 2>&1

# unload hive
[gc]::Collect()
Start-Sleep -Seconds 2
reg unload "HKLM\Settings" >$null 2>&1
}
Start-Sleep -Seconds 2

# open store settings
Start-Process "ms-windows-store:settings"

show-menu

          }
        4 {

Clear-Host

Write-Host "Installing: All UWP Apps. Please wait..."

# install all uwp apps
Get-AppxPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register -ErrorAction SilentlyContinue "$($_.InstallLocation)\AppXManifest.xml"} 2>$null

show-menu

          }
        5 {

Clear-Host

Write-Host "Install: UWP Features...`n"
Write-Host "Installing multiple features at once may fail"
Write-Host "If so, restart PC between each feature install`n"

# open uwp optional features
Start-Process "ms-settings:optionalfeatures"

# uwp list
Write-Host ""
Write-Host "---------------------------------------------"
Write-Host "      Default Windows Install List W11"
Write-Host "---------------------------------------------"
Write-Host ""
Write-Host "- Extended Theme Content"
Write-Host "- Facial Recognition (Windows Hello)"
Write-Host "- Internet Explorer mode"
Write-Host "- Math Recognizer"
Write-Host "- Notepad (system)"
Write-Host "- OpenSSH Client"
Write-Host "- Print Management"
Write-Host "- Steps Recorder"
Write-Host "- WMIC"
Write-Host "- Windows Media Player Legacy (App)"
Write-Host "- Windows PowerShell ISE"
Write-Host "- WordPad"
Write-Host ""
Write-Host "---------------------------------------------"
Write-Host "      Default Windows Install List W10"
Write-Host "---------------------------------------------"
Write-Host ""
Write-Host "- Internet Explorer 11"
Write-Host "- Math Recognizer"
Write-Host "- Microsoft Quick Assist (App)"
Write-Host "- Notepad (system)"
Write-Host "- OpenSSH Client"
Write-Host "- Print Management Console"
Write-Host "- Steps Recorder"
Write-Host "- Windows Fax and Scan"
Write-Host "- Windows Hello Face"
Write-Host "- Windows Media Player Legacy (App)"
Write-Host "- Windows PowerShell Integrated Scripting Environment"
Write-Host "- WordPad"
Write-Host ""

Pause

show-menu

          }
        6 {

Clear-Host

Write-Host "Install: Legacy Features..."

# open legacy optional features
Start-Process "C:\Windows\System32\OptionalFeatures.exe"

# legacy list
Write-Host ""
Write-Host "---------------------------------------------"
Write-Host "      Default Windows Install List W11"
Write-Host "---------------------------------------------"
Write-Host ""
Write-Host "- .Net Framework 4.8 Advanced Services +"
Write-Host "- WCF Services +"
Write-Host "- TCP Port Sharing"
Write-Host "- Media Features +"
Write-Host "- Windows Media Player Legacy (App)"
Write-Host "- Microsoft Print to PDF"
Write-Host "- Print and Document Services +"
Write-Host "- Internet Printing Client"
Write-Host "- Remote Differential Compression API Support"
Write-Host "- SMB Direct"
Write-Host "- Windows PowerShell 2.0 +"
Write-Host "- Windows PowerShell 2.0 Engine"
Write-Host "- Work Folders Client"
Write-Host ""
Write-Host "---------------------------------------------"
Write-Host "      Default Windows Install List W10"
Write-Host "---------------------------------------------"
Write-Host ""
Write-Host "- .Net Framework 4.8 Advanced Services +"
Write-Host "- WCF Services +"
Write-Host "- TCP Port Sharing"
Write-Host "- Internet Explorer 11"
Write-Host "- Media Features +"
Write-Host "- Windows Media Player"
Write-Host "- Microsoft Print to PDF"
Write-Host "- Microsoft XPS Document Writer"
Write-Host "- Print and Document Services +"
Write-Host "- Internet Printing Client"
Write-Host "- Remote Differential Compression API Support"
Write-Host "- SMB 1.0/CIFS File Sharing Support +"
Write-Host "- SMB 1.0/CIFS Automatic Removal"
Write-Host "- SMB 1.0/CIFS Client"
Write-Host "- SMB Direct"
Write-Host "- Windows PowerShell 2.0 +"
Write-Host "- Windows PowerShell 2.0 Engine"
Write-Host "- Work Folders Client"
Write-Host ""

Pause

show-menu

          }
        7 {

Clear-Host

Write-Host "Installing: One Drive. Please wait..."

# install onedrive w10
cmd /c "C:\Windows\SysWOW64\OneDriveSetup.exe >nul 2>&1"

# install onedrive w11
cmd /c "C:\Windows\System32\OneDriveSetup.exe >nul 2>&1"

show-menu

          }
        8 {

Clear-Host

Write-Host "Installing: Remote Desktop Connection. Please wait..."

# download remote desktop connection
Get-FileFromWeb -URL "https://go.microsoft.com/fwlink/?linkid=2247659" -File "$env:SystemRoot\Temp\RemoteDesktopConnection.exe"

# install remote desktop connection 
cmd /c "%SystemRoot%\Temp\RemoteDesktopConnection.exe >nul 2>&1"

show-menu

          }
        9 {

Clear-Host

Write-Host "Installing: Snipping Tool. Please wait..."
Write-Host ""
Write-Host "Ignore installer error W11"
Write-Host "If installer fails on W10, restart PC and rerun script"
Write-Host ""

# download w10 snipping tool
Get-FileFromWeb -URL "https://download.microsoft.com/download/f/4/e/f4e03465-34d1-49b6-af1a-2816ca4a2402/installers_signed/snippingtool_setup_x64.exe" -File "$env:SystemRoot\Temp\SnippingTool.exe"

# install w10 snipping tool
cmd /c "%SystemRoot%\Temp\SnippingTool.exe >nul 2>&1"

# install w11 snipping tool
Get-AppXPackage -AllUsers *Microsoft.ScreenSketch* | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register -ErrorAction SilentlyContinue "$($_.InstallLocation)\AppXManifest.xml"}

show-menu

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-9)." } }
