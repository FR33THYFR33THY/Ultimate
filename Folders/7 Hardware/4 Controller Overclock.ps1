. $CommonScript

Ensure-Admin
Testing-Connection

# SCRIPT SILENT
$progresspreference = 'silentlycontinue'


Write-Host "Installing: hidusbf..."

# download hidusbf
Get-FileFromWeb -URL "https://github.com/FR33THYFR33THY/files/raw/refs/heads/main/hidusbf.zip" -File "$env:SystemRoot\Temp\hidusbf.zip"

# extract file
Expand-Archive -Path "$env:SystemRoot\Temp\hidusbf.zip" -DestinationPath "$env:SystemDrive\Program Files (x86)\hidusbf" -Force

# create desktop shortcut
$WshShell = New-Object -comObject WScript.Shell
$Desktop = (New-Object -ComObject Shell.Application).Namespace('shell:Desktop').Self.Path
$Shortcut = $WshShell.CreateShortcut("$Desktop\Setup.lnk")
$Shortcut.TargetPath = "$env:SystemDrive\Program Files (x86)\hidusbf\Setup.exe"
$Shortcut.Save()

# create start menu shortcut
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Setup.lnk")
$Shortcut.TargetPath = "$env:SystemDrive\Program Files (x86)\hidusbf\Setup.exe"
$Shortcut.Save()

# start hidusbf
Start-Process "$env:SystemDrive\Program Files (x86)\hidusbf\Setup.exe"
