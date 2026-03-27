. $CommonScript

Ensure-Admin

        Write-Host "NVIDIA Highest Performance Power State"
		Write-Host "Always Force Max Boost Clock`n"
        Write-Host "1. On (Recommended)"
        Write-Host "2. Default`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "P0 State: On..."

# get gpu driver id
$subkeys = (Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue).Name
foreach($key in $subkeys){
if ($key -notlike '*Configuration'){
	
# enable p0 state regedit
reg add "$key" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f | Out-Null
}
}

$subkeys = (Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue).Name
foreach($key in $subkeys){
if ($key -notlike '*Configuration'){

# show regedit value
Get-ItemProperty -Path "Registry::$key" -Name 'DisableDynamicPstate'
}
}

Pause

exit

          }
        2 {

Clear-Host

Write-Host "P0 State: Default.."

# get gpu driver id
$subkeys = (Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue).Name
foreach($key in $subkeys){
if ($key -notlike '*Configuration'){

# disable p0 state regedit
reg add "$key" /v "DisableDynamicPstate" /t REG_DWORD /d "0" /f | Out-Null
}
}

$subkeys = (Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue).Name
foreach($key in $subkeys){
if ($key -notlike '*Configuration'){

# show regedit value
Get-ItemProperty -Path "Registry::$key" -Name 'DisableDynamicPstate'
}
}

Pause

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
