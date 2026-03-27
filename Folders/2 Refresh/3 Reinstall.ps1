. $CommonScript

Ensure-Admin
Testing-Connection

        Write-Host "1. Reinstall: W10"
        Write-Host "2. Reinstall: W11`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "Downloading: Media Creation Tool Win 10..."

# download media creation tool win 10
Get-FileFromWeb -URL "https://go.microsoft.com/fwlink/?LinkId=2265055" -File "$env:SystemRoot\Temp\Media Creation Tool Win 10.exe"

# start media creation tool win 10
Start-Process "$env:SystemRoot\Temp\Media Creation Tool Win 10.exe"

exit

          }
        2 {

Clear-Host

Write-Host "Downloading: Media Creation Tool Win 11..."

# download media creation tool win 11
Get-FileFromWeb -URL "https://go.microsoft.com/fwlink/?linkid=2156295" -File "$env:SystemRoot\Temp\Media Creation Tool Win 11.exe"

# start media creation tool win 11
Start-Process "$env:SystemRoot\Temp\Media Creation Tool Win 11.exe"

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
