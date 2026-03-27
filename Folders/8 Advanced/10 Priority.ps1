. $CommonScript

Ensure-Admin

		Write-Host "TEMPORARILY CHANGE PRIORITY FOR TESTING PER APP/GAME:"
        Write-Host "1. Priority: Already Running"
        Write-Host "2. Priority: Startup`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

# show priority options
Write-Host "1. Real Time"
Write-Host "2. High"
Write-Host "3. Above Normal"
Write-Host "4. Normal"
Write-Host "5. Below Normal"
Write-Host "6. Idle`n"

# select priority
$priochoice = Read-Host -Prompt "Priority"

Clear-Host

# map choice to priority
switch ($priochoice) {
"1" {$prio = "RealTime"}
"2" {$prio = "High"}
"3" {$prio = "AboveNormal"}
"4" {$prio = "Normal"}
"5" {$prio = "BelowNormal"}
"6" {$prio = "Idle"}
default {
Write-Host "Invalid input..." -ForegroundColor Red
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit
}
}

# copy game exe id
(Get-Process | Where-Object {$_.WorkingSet64 -gt 500MB} | Select-Object Name, Id) | Format-Table -AutoSize
$exeid = Read-Host -Prompt "ENTER GAME EXE ID"

Clear-Host

# set game exe priority
$processid = Get-Process -Id $exeid -ErrorAction SilentlyContinue
$processid.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::$prio

Write-Host "GETTING VALUE..."

Start-Sleep -Seconds 3

Clear-Host

# show new value
$currentprio = $processid.PriorityClass
Write-Host "ID - $exeid = $currentprio`n"

Pause

exit

          }
        2 {

Clear-Host

# stop game launchers running
$stop = "Battle.net", "BsgLauncher", "EADesktop", "EpicGamesLauncher", "GalaxyClient", "RobloxPlayerBeta", "RiotClientServices", "Launcher", "steam", "upc"
$stop | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }

Clear-Host

# show priority options
Write-Host "1. Real Time"
Write-Host "2. High"
Write-Host "3. Above Normal"
Write-Host "4. Normal"
Write-Host "5. Below Normal"
Write-Host "6. Low`n"

# select priority
$priochoice = Read-Host -Prompt "Priority"

Clear-Host

# map choice to priority
switch ($priochoice) {
"1" {$prio = "realtime"}
"2" {$prio = "high"}
"3" {$prio = "abovenormal"}
"4" {$prio = "normal"}
"5" {$prio = "belownormal"}
"6" {$prio = "low"}
default {
Write-Host "Invalid input..." -ForegroundColor Red
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit
}
}

# select game launcher lnk or exe
Write-Host "SELECT LAUNCHER/GAME/SHORTCUT/EXE:"
$gamelauncher = Show-ModernFilePicker -Mode File

Clear-Host

# set game exe priority
cmd /c "start `"`" /$prio `"$gamelauncher`""

# convert directory to file name without exe
$gamelauncher = [System.IO.Path]::GetFileNameWithoutExtension($gamelauncher)

# check value
$reloadgamelauncher = (Get-Process -Name "$gamelauncher").PriorityClass

Write-Host "GETTING VALUE..."

Start-Sleep -Seconds 3

Clear-Host

# show new value
Write-Host "EXE - $gamelauncher = $reloadgamelauncher`n"

Pause

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
