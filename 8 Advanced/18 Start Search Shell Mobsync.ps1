        # SCRIPT RUN AS ADMIN
        If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
        {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit}
        $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
        $Host.UI.RawUI.BackgroundColor = "Black"
        $Host.PrivateData.ProgressBackgroundColor = "Black"
        $Host.PrivateData.ProgressForegroundColor = "White"
        Clear-Host

        Write-Host "Start Search Shell Mobsync:"
        Write-Host "1. Off"
        Write-Host "2. Default`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "Start Search Shell Mobsync: Off...`n"

# takeownership of folders
cmd /c "takeown.exe /f $env:SystemRoot\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy >nul 2>&1"
cmd /c "icacls.exe $env:SystemRoot\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy /grant *S-1-3-4:F /t /q >nul 2>&1"
cmd /c "takeown.exe /f $env:SystemRoot\SystemApps\ShellExperienceHost_cw5n1h2txyewy >nul 2>&1"
cmd /c "icacls.exe $env:SystemRoot\SystemApps\ShellExperienceHost_cw5n1h2txyewy /grant *S-1-3-4:F /t /q >nul 2>&1"
cmd /c "takeown.exe /f $env:SystemRoot\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy >nul 2>&1"
cmd /c "icacls.exe $env:SystemRoot\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy /grant *S-1-3-4:F /t /q >nul 2>&1"
cmd /c "takeown.exe /f $env:SystemRoot\System32\mobsync.exe >nul 2>&1"
cmd /c "icacls.exe $env:SystemRoot\System32\mobsync.exe /grant *S-1-3-4:F /t /q >nul 2>&1"

# stop tasks
$stop = "AccountsServiceProduct",
        "AppActions",
        "Copilot",
        "CrossDeviceResume",
        "DesktopSpotlightProduct",
        "DesktopStickerEditorWin32Exe",
        "DiscoveryHubApp",
        "FESearchHost",
        "GameBar",
        "IrisServiceProduct",
        "LogonWebHostProduct",
        "MicrosoftEdgeUpdate",
        "MiniSearchHost",
        "OneDrive",
        "OneDrive.Sync.Service",
        "OneDriveStandaloneUpdater",
        "Resume",
        "RulesEngineProduct",
        "RuntimeBroker",
        "ScreenClippingHost",
        "Search",
        "SearchApp",
        "SearchHost",
        "Setup",
        "ShellExperienceHost",
        "SoftLandingTask",
        "StartMenuExperienceHost",
        "StoreDesktopExtension",
        "TextInputHost",
        "VisualAssistExe",
        "WebExperienceHostApp",
        "WidgetService",
        "Widgets",
        "WindowsBackupClient",
        "WindowsMigration",
        "backgroundTaskHost",
        "explorer",
        "mobsync",
        "msedge",
        "msedgewebview2",
        "smartscreen"
$stop | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }

# move folders
cmd /c "move /y $env:SystemRoot\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy $env:SystemRoot >nul 2>&1"
cmd /c "move /y $env:SystemRoot\SystemApps\ShellExperienceHost_cw5n1h2txyewy $env:SystemRoot >nul 2>&1"
cmd /c "move /y $env:SystemRoot\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy $env:SystemRoot >nul 2>&1"
cmd /c "move /y $env:SystemRoot\System32\mobsync.exe $env:SystemRoot >nul 2>&1"

# disable uwp search
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\PolicyManager\default\Search\DisableSearch`" /v `"value`" /t REG_DWORD /d `"1`" /f >nul 2>&1"
cmd /c "reg add `"HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search`" /v `"DisableSearch`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

# disable uwp search box taskbar
cmd /c "reg add `"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search`" /v `"SearchboxTaskbarMode`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# disable legacy search service
cmd /c "reg add `"HKLM\SYSTEM\ControlSet001\Services\WSearch`" /v `"Start`" /t REG_DWORD /d `"4`" /f >nul 2>&1"

# stop explorer
cmd /c "taskkill /F /IM explorer.exe >nul 2>&1"

# start explorer
cmd /c "start explorer.exe >nul 2>&1"

# pause so search service will stop
Start-Sleep 15

# stop legacy search service
cmd /c "sc stop WSearch >nul 2>&1"

# reapply for w10 search
cmd /c "takeown.exe /f $env:SystemRoot\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy >nul 2>&1"
cmd /c "icacls.exe $env:SystemRoot\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy /grant *S-1-3-4:F /t /q >nul 2>&1"
cmd /c "taskkill /F /IM SearchApp.exe >nul 2>&1"
cmd /c "taskkill /F /IM SearchHost.exe >nul 2>&1"
cmd /c "move /y $env:SystemRoot\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy $env:SystemRoot >nul 2>&1"

exit

          }
        2 {

Clear-Host

Write-Host "Start Search Shell Mobsync: Default...`n"

# takeownership of folders
cmd /c "takeown.exe /f $env:SystemRoot\Microsoft.Windows.Search_cw5n1h2txyewy >nul 2>&1"
cmd /c "icacls.exe $env:SystemRoot\Microsoft.Windows.Search_cw5n1h2txyewy /grant *S-1-3-4:F /t /q >nul 2>&1"
cmd /c "takeown.exe /f $env:SystemRoot\ShellExperienceHost_cw5n1h2txyewy >nul 2>&1"
cmd /c "icacls.exe $env:SystemRoot\ShellExperienceHost_cw5n1h2txyewy /grant *S-1-3-4:F /t /q >nul 2>&1"
cmd /c "takeown.exe /f $env:SystemRoot\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy >nul 2>&1"
cmd /c "icacls.exe $env:SystemRoot\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy /grant *S-1-3-4:F /t /q >nul 2>&1"
cmd /c "takeown.exe /f $env:SystemRoot\mobsync.exe >nul 2>&1"
cmd /c "icacls.exe $env:SystemRoot\mobsync.exe /grant *S-1-3-4:F /t /q >nul 2>&1"

# move folders
cmd /c "move /y $env:SystemRoot\Microsoft.Windows.Search_cw5n1h2txyewy $env:SystemRoot\SystemApps >nul 2>&1"
cmd /c "move /y $env:SystemRoot\ShellExperienceHost_cw5n1h2txyewy $env:SystemRoot\SystemApps >nul 2>&1"
cmd /c "move /y $env:SystemRoot\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy $env:SystemRoot\SystemApps >nul 2>&1"
cmd /c "move /y $env:SystemRoot\mobsync.exe $env:SystemRoot\System32 >nul 2>&1"

# enable uwp search completely
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\PolicyManager\default\Search\DisableSearch`" /v `"value`" /t REG_DWORD /d `"0`" /f >nul 2>&1"
cmd /c "reg delete `"HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search`" /f >nul 2>&1"

# enable uwp search box taskbar
cmd /c "reg delete `"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search`" /v `"SearchboxTaskbarMode`" /f >nul 2>&1"

# enable legacy search service
cmd /c "reg add `"HKLM\SYSTEM\ControlSet001\Services\WSearch`" /v `"Start`" /t REG_DWORD /d `"2`" /f >nul 2>&1"

# stop explorer
cmd /c "taskkill /F /IM explorer.exe >nul 2>&1"

# start explorer
cmd /c "start explorer.exe >nul 2>&1"

# pause so search service will start
Start-Sleep 15

# start legacy search service
cmd /c "sc stop WSearch >nul 2>&1"

# start explorer
cmd /c "start explorer.exe >nul 2>&1"

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }