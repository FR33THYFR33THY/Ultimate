        # SCRIPT RUN AS ADMIN
        If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
        {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit}
        $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
        $Host.UI.RawUI.BackgroundColor = "Black"
        $Host.PrivateData.ProgressBackgroundColor = "Black"
        $Host.PrivateData.ProgressForegroundColor = "White"
        Clear-Host

        Write-Host "MMAgent Features:"
        Write-Host "1. Off"
        Write-Host "2. Default"
        Write-Host "3. Check`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-3]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "MMAgent Features: Off"

Pause

# force disable applicationlaunchprefetching & operationapi
cmd /c "reg add `"HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters`" /v `"EnablePrefetcher`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# disable applicationlaunchprefetching
Disable-MMAgent -ApplicationLaunchPrefetching -ErrorAction SilentlyContinue | Out-Null

# disable applicationprelaunch
Disable-MMAgent -ApplicationPreLaunch -ErrorAction SilentlyContinue | Out-Null

# disable maxoperationapifiles
Set-MMAgent -MaxOperationAPIFiles 1 -ErrorAction SilentlyContinue | Out-Null

# disable memorycompression
Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue | Out-Null

# disable operationapi
Disable-MMAgent -OperationAPI -ErrorAction SilentlyContinue | Out-Null

# disable pagecombining
Disable-MMAgent -PageCombining -ErrorAction SilentlyContinue | Out-Null

exit

          }
        2 {

Clear-Host

Write-Host "MMAgent Features: Default"

Pause

# enable applicationlaunchprefetching & operationapi
cmd /c "reg add `"HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters`" /v `"EnablePrefetcher`" /t REG_DWORD /d `"3`" /f >nul 2>&1"

# enable applicationlaunchprefetching
Enable-MMAgent -ApplicationLaunchPrefetching -ErrorAction SilentlyContinue | Out-Null

# enable applicationprelaunch
Enable-MMAgent -ApplicationPreLaunch -ErrorAction SilentlyContinue | Out-Null

# enable maxoperationapifiles
Set-MMAgent -MaxOperationAPIFiles 512 -ErrorAction SilentlyContinue | Out-Null

# disable memorycompression
Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue | Out-Null

# enable operationapi
Enable-MMAgent -OperationAPI -ErrorAction SilentlyContinue | Out-Null

# disable pagecombining
Disable-MMAgent -PageCombining -ErrorAction SilentlyContinue | Out-Null

exit

          }
        3 {

Clear-Host

Write-Host "SETTINGS MAY TAKE A WHILE TO INITIALIZE AFTER REBOOT"
Write-Host "WAIT A SHORT PERIOD BEFORE CHECKING`n"
Write-Host "Check"

# show mmagent
get-mmagent

Pause

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-3)." } }