. $CommonScript

Ensure-Admin

        Write-Host "1. BitLocker: Off (Recommended)"
        Write-Host "2. BitLocker: On`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "BitLocker: Off..."

# disable bitlocker
try {
Get-BitLockerVolume |
Where-Object {
$_.ProtectionStatus -eq "On" -or $_.VolumeStatus -ne "FullyDecrypted"
} |
ForEach-Object {
Disable-BitLocker -MountPoint $_.MountPoint -ErrorAction SilentlyContinue | Out-Null
}
} catch { }

# open settings
Start-Process control.exe -ArgumentList "/name microsoft.bitlockerdriveencryption"

exit

          }
        2 {

Clear-Host

Write-Host "BitLocker: On..."

# open settings
Start-Process control.exe -ArgumentList "/name microsoft.bitlockerdriveencryption"

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
