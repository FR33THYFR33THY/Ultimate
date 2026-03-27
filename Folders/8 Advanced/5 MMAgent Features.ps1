. $CommonScript

Ensure-Admin

        Write-Host "MMAgent Features:"
        Write-Host "1. Off"
        Write-Host "2. Default`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "MMAgent Features: Off...`n"

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

get-mmagent

Pause

exit

          }
        2 {

Clear-Host

Write-Host "MMAgent Features: Default...`n"

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

# enable pagecombining
Enable-MMAgent -PageCombining -ErrorAction SilentlyContinue | Out-Null

get-mmagent

Pause

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
