. $CommonScript

Ensure-Admin
Testing-Connection

# SCRIPT SILENT
$progresspreference = 'silentlycontinue'

## explorer "https://www.monitortests.com/forum/Thread-Custom-Resolution-Utility-CRU"
Write-Host "Installing: Custom Resolution Utility..."

# download custom resolution utility
Get-FileFromWeb -URL "https://github.com/FR33THYFR33THY/files/raw/refs/heads/main/CRU.zip" -File "$env:SystemRoot\Temp\CRU.zip"

# extract file
Expand-Archive -Path "$env:SystemRoot\Temp\CRU.zip" -DestinationPath "$env:SystemDrive\Program Files (x86)\CRU" -Force

# create desktop shortcut
$WshShell = New-Object -comObject WScript.Shell
$Desktop = (New-Object -ComObject Shell.Application).Namespace('shell:Desktop').Self.Path
$Shortcut = $WshShell.CreateShortcut("$Desktop\Custom Resolution Utility.lnk")
$Shortcut.TargetPath = "$env:SystemDrive\Program Files (x86)\CRU\CRU.exe"
$Shortcut.Save()

# create start menu shortcut
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Custom Resolution Utility.lnk")
$Shortcut.TargetPath = "$env:SystemDrive\Program Files (x86)\CRU\CRU.exe"
$Shortcut.Save()
