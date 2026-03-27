. $CommonScript

Ensure-Admin

        Write-Host "OFF NOT RECOMMENDED WITH HAGS:`n" -ForegroundColor Red
        Write-Host "AMD Ultra Low Power Saving:"
        Write-Host "1. On (Default)"
        Write-Host "2. Off`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "AMD ULPS: On Default..."

# get gpu driver id
$subkeys = (Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue).Name
foreach($key in $subkeys){
if ($key -notlike '*Configuration'){

# enable ulps
reg add "$key" /v "EnableUlps" /t REG_DWORD /d "1" /f | Out-Null
}
}

$subkeys = (Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue).Name
foreach($key in $subkeys){
if ($key -notlike '*Configuration'){

# show regedit value
Get-ItemProperty -Path "Registry::$key" -Name 'EnableUlps'
}
}

Pause

exit

          }
        2 {

Clear-Host

Write-Host "AMD ULPS: Off..."

# get gpu driver id
$subkeys = (Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue).Name
foreach($key in $subkeys){
if ($key -notlike '*Configuration'){

# disable ulps
reg add "$key" /v "EnableUlps" /t REG_DWORD /d "0" /f | Out-Null
}
}

$subkeys = (Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue).Name
foreach($key in $subkeys){
if ($key -notlike '*Configuration'){
	
# show regedit value
Get-ItemProperty -Path "Registry::$key" -Name 'EnableUlps'
}
}

Pause

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
