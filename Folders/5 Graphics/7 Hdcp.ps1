. $CommonScript

Ensure-Admin

        Write-Host "NVIDIA/AMD High Bandwidth Digital Content Protection"
        Write-Host "1. Off (Recommended)"
        Write-Host "2. Default`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "HDCP: Off..."

# AMD
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
$allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
$edidKeysWithSuffix = $allKeys | Where-Object { $_.PSChildName -match '^EDID_[A-F0-9]+_[A-F0-9]+_[A-F0-9]+$' }
foreach ($edidKey in $edidKeysWithSuffix) {
if ($edidKey.PSChildName -match '^(EDID_[A-F0-9]+_[A-F0-9]+)_[A-F0-9]+$') {
$baseEdidName = $matches[1]
$parentPath = Split-Path $edidKey.PSPath
$baseEdidPath = Join-Path $parentPath $baseEdidName
if (!(Test-Path $baseEdidPath)) {
New-Item -Path $baseEdidPath -Force -ErrorAction SilentlyContinue | Out-Null
}   
$optionPathNew = Join-Path $baseEdidPath "Option"
if (!(Test-Path $optionPathNew)) {
New-Item -Path $optionPathNew -Force -ErrorAction SilentlyContinue | Out-Null
}
$regPath = $optionPathNew.Replace('Microsoft.PowerShell.Core\Registry::', '').Replace('HKEY_LOCAL_MACHINE', 'HKLM')
cmd /c "reg add `"$regPath`" /v `"All_nodes`" /t REG_BINARY /d `"50726F74656374696F6E436F6E74726F6C00`" /f >nul 2>&1"
cmd /c "reg add `"$regPath`" /v `"default`" /t REG_BINARY /d `"64`" /f >nul 2>&1"
cmd /c "reg add `"$regPath`" /v `"ProtectionControl`" /t REG_BINARY /d `"0100000001000000`" /f >nul 2>&1"
}
}

# NVIDIA
$subkeys = (Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue).Name
foreach($key in $subkeys){
if ($key -notlike '*Configuration'){
reg add "$key" /v "RMHdcpKeyglobZero" /t REG_DWORD /d "1" /f | Out-Null
}
}
$subkeys = (Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue).Name
foreach($key in $subkeys){
if ($key -notlike '*Configuration'){
Get-ItemProperty -Path "Registry::$key" -Name 'RMHdcpKeyglobZero'
}
}

Pause

exit

          }
        2 {

Clear-Host

Write-Host "HDCP: Default..."

# AMD
$basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
$allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
$edidKeysWithSuffix = $allKeys | Where-Object { $_.PSChildName -match '^EDID_[A-F0-9]+_[A-F0-9]+_[A-F0-9]+$' }
foreach ($edidKey in $edidKeysWithSuffix) {
if ($edidKey.PSChildName -match '^(EDID_[A-F0-9]+_[A-F0-9]+)_[A-F0-9]+$') {
$baseEdidName = $matches[1]
$parentPath = Split-Path $edidKey.PSPath
$baseEdidPath = Join-Path $parentPath $baseEdidName
if (!(Test-Path $baseEdidPath)) {
New-Item -Path $baseEdidPath -Force -ErrorAction SilentlyContinue | Out-Null
}   
$optionPathNew = Join-Path $baseEdidPath "Option"
if (!(Test-Path $optionPathNew)) {
New-Item -Path $optionPathNew -Force -ErrorAction SilentlyContinue | Out-Null
}
$regPath = $optionPathNew.Replace('Microsoft.PowerShell.Core\Registry::', '').Replace('HKEY_LOCAL_MACHINE', 'HKLM')
cmd /c "reg delete `"$regPath`" /v `"All_nodes`" /f >nul 2>&1"
cmd /c "reg delete `"$regPath`" /v `"default`" /f >nul 2>&1"
cmd /c "reg delete `"$regPath`" /v `"ProtectionControl`" /f >nul 2>&1"
}
}

# NVIDIA
$subkeys = (Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue).Name
foreach($key in $subkeys){
if ($key -notlike '*Configuration'){
reg add "$key" /v "RMHdcpKeyglobZero" /t REG_DWORD /d "0" /f | Out-Null
}
}
$subkeys = (Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue).Name
foreach($key in $subkeys){
if ($key -notlike '*Configuration'){
Get-ItemProperty -Path "Registry::$key" -Name 'RMHdcpKeyglobZero'
}
}

Pause

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
