. $CommonScript

Ensure-Admin
Testing-Connection

        # SCRIPT SILENT
        $progresspreference = 'silentlycontinue'

        Write-Host "1. Edge & WebView: Uninstall (Recommended)"
        Write-Host "2. Edge & WebView: Default`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "Edge & WebView: Uninstall..."

# get region to revert later
$Region = Get-ItemPropertyValue 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\DeviceRegion' -Name DeviceRegion -ErrorAction SilentlyContinue

# set region to us
Copy-Item (Get-Command reg.exe).Source .\reg1.exe -Force -EA 0
& .\reg1.exe add 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\DeviceRegion' /v DeviceRegion /t REG_DWORD /d 244 /f >$null

# stop edge running
$stop = "backgroundTaskHost", "Copilot", "CrossDeviceResume", "GameBar", "MicrosoftEdgeUpdate", "msedge", "msedgewebview2", "OneDrive", "OneDrive.Sync.Service", "OneDriveStandaloneUpdater", "Resume", "RuntimeBroker", "Search", "SearchHost", "Setup", "StoreDesktopExtension", "WidgetService", "Widgets"
$stop | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }
Get-Process | Where-Object { $_.ProcessName -like "*edge*" } | Stop-Process -Force -ErrorAction SilentlyContinue

# find edgeupdate.exe
$edgeupdate = @(); "LocalApplicationData", "ProgramFilesX86", "ProgramFiles" | ForEach-Object {
$folder = [Environment]::GetFolderPath($_)
$edgeupdate += Get-ChildItem "$folder\Microsoft\EdgeUpdate\*.*.*.*\MicrosoftEdgeUpdate.exe" -rec -ea 0
}

# find edgeupdate & allow uninstall regedit
$global:REG = "HKCU:\SOFTWARE", "HKLM:\SOFTWARE", "HKCU:\SOFTWARE\Policies", "HKLM:\SOFTWARE\Policies", "HKCU:\SOFTWARE\WOW6432Node", "HKLM:\SOFTWARE\WOW6432Node", "HKCU:\SOFTWARE\WOW6432Node\Policies", "HKLM:\SOFTWARE\WOW6432Node\Policies"
foreach ($location in $REG) { Remove-Item "$location\Microsoft\EdgeUpdate" -recurse -force -ErrorAction SilentlyContinue }

# uninstall edgeupdate
foreach ($path in $edgeupdate) {
if (Test-Path $path) { Start-Process -Wait $path -Args "/unregsvc" | Out-Null }
do { Start-Sleep 3 } while ((Get-Process -Name "setup", "MicrosoftEdge*" -ErrorAction SilentlyContinue).Path -like "*\Microsoft\Edge*")
if (Test-Path $path) { Start-Process -Wait $path -Args "/uninstall" | Out-Null }
do { Start-Sleep 3 } while ((Get-Process -Name "setup", "MicrosoftEdge*" -ErrorAction SilentlyContinue).Path -like "*\Microsoft\Edge*")
}

# new folder to uninstall edge
New-Item -Path "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

# new file to uninstall edge
New-Item -Path "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -ItemType File -Name "MicrosoftEdge.exe" -ErrorAction SilentlyContinue | Out-Null

# find edge uninstall string
$regview = [Microsoft.Win32.RegistryView]::Registry32
$microsoft = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $regview).
OpenSubKey("SOFTWARE\Microsoft", $true)
$uninstallregkey = $microsoft.OpenSubKey("Windows\CurrentVersion\Uninstall\Microsoft Edge")
try {
$uninstallstring = $uninstallregkey.GetValue("UninstallString") + " --force-uninstall"
} catch {
}

# uninstall edge
Start-Process cmd.exe "/c $uninstallstring" -WindowStyle Hidden -Wait

# clean folder file
Remove-Item -Recurse -Force "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -ErrorAction SilentlyContinue | Out-Null

# remove edgewebview uninstaller
cmd /c "reg delete `"HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView`" /f >nul 2>&1"

# remove edge shortcut
Remove-Item -Recurse -Force "$env:SystemDrive\Windows\System32\config\systemprofile\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk" -ErrorAction SilentlyContinue | Out-Null

# remove edge folders
Remove-Item -Recurse -Force "$env:SystemDrive\Program Files (x86)\Microsoft" -ErrorAction SilentlyContinue | Out-Null

# remove edge services
$services = Get-Service | Where-Object { $_.Name -match 'Edge' }
foreach ($service in $services) {
cmd /c "sc stop `"$($service.Name)`" >nul 2>&1"
cmd /c "sc delete `"$($service.Name)`" >nul 2>&1"
}

# windows 10 remove microsoft edge legacy package
$EdgeLegacyPackage = (Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" -ErrorAction SilentlyContinue |
Where-Object { $_.PSChildName -like "*Microsoft-Windows-Internet-Browser-Package*~~*" }).PSChildName
if ($EdgeLegacyPackage) {
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\$EdgeLegacyPackage"
cmd /c "reg add `"$($regPath.Replace('HKLM:\', 'HKLM\'))`" /v Visibility /t REG_DWORD /d 1 /f >nul 2>&1"
cmd /c "reg delete `"$($regPath.Replace('HKLM:\', 'HKLM\'))\Owners`" /va /f >nul 2>&1"
dism /online /Remove-Package /PackageName:$EdgeLegacyPackage /quiet /norestart 2>$null | Out-Null
}

# revert region
if ($Region) {
& .\reg1.exe add 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\DeviceRegion' /v DeviceRegion /t REG_DWORD /d $Region /f >$null
}
Remove-Item .\reg1.exe -ErrorAction SilentlyContinue

exit

          }
        2 {

Clear-Host

Write-Host "Edge & WebView: Default..."

# stop edge running
$stop = "backgroundTaskHost", "Copilot", "CrossDeviceResume", "GameBar", "MicrosoftEdgeUpdate", "msedge", "msedgewebview2", "OneDrive", "OneDrive.Sync.Service", "OneDriveStandaloneUpdater", "Resume", "RuntimeBroker", "Search", "SearchHost", "Setup", "StoreDesktopExtension", "WidgetService", "Widgets"
$stop | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }
Get-Process | Where-Object { $_.ProcessName -like "*edge*" } | Stop-Process -Force -ErrorAction SilentlyContinue

# download edge installer
Get-FileFromWeb -URL "https://go.microsoft.com/fwlink/?linkid=2109047&Channel=Stable&language=en&brand=M100" -File "$env:SystemRoot\Temp\Edge.exe"

# start edge installer
Start-Process -Wait "$env:SystemRoot\Temp\Edge.exe"

# stop edge running
$stop = "backgroundTaskHost", "Copilot", "CrossDeviceResume", "GameBar", "MicrosoftEdgeUpdate", "msedge", "msedgewebview2", "OneDrive", "OneDrive.Sync.Service", "OneDriveStandaloneUpdater", "Resume", "RuntimeBroker", "Search", "SearchHost", "Setup", "StoreDesktopExtension", "WidgetService", "Widgets"
$stop | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }
Get-Process | Where-Object { $_.ProcessName -like "*edge*" } | Stop-Process -Force -ErrorAction SilentlyContinue

# download edge webview installer
Get-FileFromWeb -URL "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/304fddef-b073-4e0a-b1ff-c2ea02584017/MicrosoftEdgeWebview2Setup.exe" -File "$env:SystemRoot\Temp\EdgeWebView.exe"

# start edge webview installer
Start-Process -Wait "$env:SystemRoot\Temp\EdgeWebView.exe"

# stop edge running
$stop = "backgroundTaskHost", "Copilot", "CrossDeviceResume", "GameBar", "MicrosoftEdgeUpdate", "msedge", "msedgewebview2", "OneDrive", "OneDrive.Sync.Service", "OneDriveStandaloneUpdater", "Resume", "RuntimeBroker", "Search", "SearchHost", "Setup", "StoreDesktopExtension", "WidgetService", "Widgets"
$stop | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }
Get-Process | Where-Object { $_.ProcessName -like "*edge*" } | Stop-Process -Force -ErrorAction SilentlyContinue

Clear-Host

Write-Host "Edge Settings: Importing..."

# install ublock origin
cmd /c "reg add `"HKLM\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist`" /v `"1`" /t REG_SZ /d `"odfafepnkmbhccpbejgmiehpchacaeak;https://edge.microsoft.com/extensionwebstorebase/v1/crx`" /f >nul 2>&1"

# add edge policies
cmd /c "reg add `"HKLM\SOFTWARE\Policies\Microsoft\Edge`" /v `"HardwareAccelerationModeEnabled`" /t REG_DWORD /d `"0`" /f >nul 2>&1"
cmd /c "reg add `"HKLM\SOFTWARE\Policies\Microsoft\Edge`" /v `"BackgroundModeEnabled`" /t REG_DWORD /d `"0`" /f >nul 2>&1"
cmd /c "reg add `"HKLM\SOFTWARE\Policies\Microsoft\Edge`" /v `"StartupBoostEnabled`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# remove logon edge
$basePath = "HKLM:\Software\Microsoft\Active Setup\Installed Components"
Get-ChildItem $basePath | ForEach-Object {
$val = (Get-ItemProperty $_.PsPath)."(default)"
if ($val -like "*Edge*") {
Remove-Item $_.PsPath -Force -ErrorAction SilentlyContinue
}
}

# remove runonce edge
$runOncePath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
Get-Item $runOncePath -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Property | Where-Object { $_ -like "*msedge*" } | ForEach-Object {
Remove-ItemProperty -Path $runOncePath -Name $_ -Force -ErrorAction SilentlyContinue
}

# remove edge services
$services = Get-Service | Where-Object { $_.Name -match 'Edge' }
foreach ($service in $services) {
cmd /c "sc stop `"$($service.Name)`" >nul 2>&1"
cmd /c "sc delete `"$($service.Name)`" >nul 2>&1"
}

# remove edge scheduled tasks
Get-ScheduledTask | Where-Object { $_.TaskName -like '*Edge*' } | Unregister-ScheduledTask -Confirm:$false -ErrorAction SilentlyContinue

# remove ietoedge bho
cmd /c "reg delete `"HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{1FD49718-1D00-4B19-AF5F-070AF6D5D54C}`" /f >nul 2>&1"
cmd /c "reg delete `"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{1FD49718-1D00-4B19-AF5F-070AF6D5D54C}`" /f >nul 2>&1"

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
