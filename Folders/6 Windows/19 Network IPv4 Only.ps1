. $CommonScript

Ensure-Admin

        # SCRIPT SILENT
        $progresspreference = 'silentlycontinue'

        Write-Host "1. Network IPv4: Only (Recommended)"
        Write-Host "2. Network: Default`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "Network IPv4: Only...`n"

# disable all network adapters except ipv4
$adapterstodisable = @('ms_lldp', 'ms_lltdio', 'ms_implat', 'ms_rspndr', 'ms_tcpip6', 'ms_server', 'ms_msclient', 'ms_pacer')
foreach ($adapterbinding in $adapterstodisable) {
Disable-NetAdapterBinding -Name "*" -ComponentID $adapterbinding -ErrorAction SilentlyContinue
}

# open settings
get-netadapterbinding | select-object name, displayname, componentid, enabled | format-table -autosize

Pause

exit

          }
        2 {

Clear-Host

Write-Host "Network: Default..`n"

# enable all network adapters
$adapterstoenable = @('ms_lldp', 'ms_lltdio', 'ms_implat', 'ms_tcpip', 'ms_rspndr', 'ms_tcpip6', 'ms_server', 'ms_msclient', 'ms_pacer')
foreach ($adapterbinding in $adapterstoenable) {
Enable-NetAdapterBinding -Name "*" -ComponentID $adapterbinding -ErrorAction SilentlyContinue
}

# open settings
get-netadapterbinding | select-object name, displayname, componentid, enabled | format-table -autosize

Pause

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
