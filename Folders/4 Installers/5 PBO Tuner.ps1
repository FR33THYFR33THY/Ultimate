. $CommonScript

Ensure-Admin
Testing-Connection

# SCRIPT SILENT
$progresspreference = 'silentlycontinue'


## explorer "https://www.overclock.net/threads/corecycler-tool-for-testing-single-core-stability-e-g-curve-optimizer-settings.1777398/page-45#post-28999750"
Write-Host "Installing: PBO2 Tuner..."
Write-Host "AM4 CPUS only, 5000 series and below`n" -ForegroundColor Red

# download pbo2 tuner
Get-FileFromWeb -URL "https://github.com/FR33THYFR33THY/files/raw/refs/heads/main/PBO2%20Tuner.zip" -File "$env:SystemRoot\Temp\PBO2 Tuner.zip"

# extract file
Expand-Archive -Path "$env:SystemRoot\Temp\PBO2 Tuner.zip" -DestinationPath "$env:SystemDrive\Program Files (x86)\PBO2 Tuner" -Force

# create desktop shortcut
$WshShell = New-Object -comObject WScript.Shell
$Desktop = (New-Object -ComObject Shell.Application).Namespace('shell:Desktop').Self.Path
$Shortcut = $WshShell.CreateShortcut("$Desktop\PBO2 Tuner.lnk")
$Shortcut.TargetPath = "$env:SystemDrive\Program Files (x86)\PBO2 Tuner\PBO2 Tuner.exe"
$Shortcut.Save()

# create start menu shortcut
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:ProgramData\Microsoft\Windows\Start Menu\Programs\PBO2 Tuner.lnk")
$Shortcut.TargetPath = "$env:SystemDrive\Program Files (x86)\PBO2 Tuner\PBO2 Tuner.exe"
$Shortcut.Save()

# create pbo2 tuner (-10 undervolt startup) shortcut
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\PBO2 Tuner (-10 UNDERVOLT STARTUP).lnk")
$Shortcut.TargetPath = "$env:SystemDrive\Program Files (x86)\PBO2 Tuner\PBO2 Tuner.exe"
$Shortcut.Arguments = "-10 -10 -10 -10 -10 -10 -10 -10"
$Shortcut.Save()
