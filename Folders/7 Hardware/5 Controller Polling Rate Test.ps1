. $CommonScript

Ensure-Admin
Testing-Connection

Write-Host "Installing: Polling..."

# download gamepadla
Get-FileFromWeb -URL "https://github.com/FR33THYFR33THY/files/raw/refs/heads/main/Polling.exe" -File "$env:SystemDrive\Program Files (x86)\Polling\Polling.exe"

# create desktop shortcut
$WshShell = New-Object -comObject WScript.Shell
$Desktop = (New-Object -ComObject Shell.Application).Namespace('shell:Desktop').Self.Path
$Shortcut = $WshShell.CreateShortcut("$Desktop\Polling.lnk")
$Shortcut.TargetPath = "$env:SystemDrive\Program Files (x86)\Polling\Polling.exe"
$Shortcut.Save()

# create start menu shortcut
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Polling.lnk")
$Shortcut.TargetPath = "$env:SystemDrive\Program Files (x86)\Polling\Polling.exe"
$Shortcut.Save()

# open gamepadla
Start-Process "$env:SystemDrive\Program Files (x86)\Polling\Polling.exe"
