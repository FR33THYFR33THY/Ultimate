        # SCRIPT RUN AS ADMIN
        If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
        {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit}
        $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
        $Host.UI.RawUI.BackgroundColor = "Black"
        $Host.PrivateData.ProgressBackgroundColor = "Black"
        $Host.PrivateData.ProgressForegroundColor = "White"
        Clear-Host

		Write-Host "TEMPORARILY DISABLE CPU THREADS FOR TESTING PER APP/GAME`n"
        Write-Host "SMT/HT:"
        Write-Host "1. Off: Already Running"
        Write-Host "2. Off: Startup`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

# get number of logical processors
$NOLP = (Get-WmiObject Win32_ComputerSystem).NumberOfLogicalProcessors

# convert input to integer
$NOLP = [int]$NOLP

# convert input to binary value with smt/ht off
$binary = ""
for ($i = 0; $i -lt $NOLP; $i++) {
if ($i % 2 -eq 0) {
$binary += "0"
} else {
$binary += "1"
}
}

# ensure binary length is multiple of 4 padding with leading zeros if needed
$binary = $binary.PadLeft([math]::Ceiling($binary.Length / 4) * 4, "0")

# convert binary to hexadecimal
$hexadecimal = ""
for ($i = 0; $i -lt $binary.Length; $i += 4) {
$binchunk = $binary.Substring($i, 4)
$hexadecimal += [Convert]::ToString([Convert]::ToInt32($binchunk, 2), 16)
}

# convert hexadecimal to an integer
$hexadecimal = [Convert]::ToInt32($hexadecimal, 16)

# copy game exe id
(Get-Process | Where-Object {$_.WorkingSet64 -gt 500MB} | Select-Object Name, Id) | Format-Table -AutoSize
$exeid = Read-Host -Prompt "ENTER GAME EXE ID"

Clear-Host

# set game exe smt/ht off
$smthtoff = Get-Process -Id $exeid
$smthtoff.ProcessorAffinity = $hexadecimal

# check new value
$reloadexeid = Get-Process -Id $exeid

# show new value
$showvalue = [Convert]::ToString([int]$reloadexeid.ProcessorAffinity, 2).PadLeft($NOLP, '0')
Write-Host "ID - $exeid = $showvalue`n"

Pause

exit

          }
        2 {

Clear-Host

# stop game launchers running
$stop = "Battle.net", "BsgLauncher", "EADesktop", "EpicGamesLauncher", "GalaxyClient", "RobloxPlayerBeta", "RiotClientServices", "Launcher", "steam", "upc"
$stop | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }

# get number of logical processors
$NOLP = (Get-WmiObject Win32_ComputerSystem).NumberOfLogicalProcessors

# convert input to integer
$NOLP = [int]$NOLP

# convert input to binary value with smt/ht off
$binary = ""
for ($i = 0; $i -lt $NOLP; $i++) {
if ($i % 2 -eq 0) {
$binary += "0"
} else {
$binary += "1"
}
}

# ensure binary length is multiple of 4 padding with leading zeros if needed
$binary = $binary.PadLeft([math]::Ceiling($binary.Length / 4) * 4, "0")

# convert binary to hexadecimal
$hexadecimal = ""
for ($i = 0; $i -lt $binary.Length; $i += 4) {
$binchunk = $binary.Substring($i, 4)
$hexadecimal += [Convert]::ToString([Convert]::ToInt32($binchunk, 2), 16)
}

# select game launcher lnk or exe
Write-Host "SELECT LAUNCHER/GAME/SHORTCUT/EXE:"
Add-Type -AssemblyName System.Windows.Forms
$Dialog = New-Object System.Windows.Forms.OpenFileDialog
$Dialog.Filter = "All Files (*.*)|*.*"
$Dialog.ShowDialog() | Out-Null
$gamelauncher = $Dialog.FileName

Clear-Host

# start game launcher lnk or exe with smt/ht off
cmd /c "start `"`" /affinity $hexadecimal `"$gamelauncher`""
Write-Host "GETTING VALUE..."

Start-Sleep -Seconds 10

# convert directory to file name without exe
$gamelauncher = [System.IO.Path]::GetFileNameWithoutExtension($gamelauncher)

# check value
$reloadgamelauncher = (Get-Process -Name "$gamelauncher").ProcessorAffinity

# convert value
$showvalue = [Convert]::ToString([int]$reloadgamelauncher, 2)

Clear-Host

# show new value
$NOLPlength = $NOLP
$showvalue = $showvalue.PadLeft($NOLPlength, "0")
Write-Host "EXE - $gamelauncher = $showvalue`n"

Pause

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }