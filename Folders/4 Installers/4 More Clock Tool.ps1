. $CommonScript

Ensure-Admin
Testing-Connection

## explorer "https://www.igorslab.de/en/download-area-new-version-of-morepowertool-mpt-and-final-release-of-redbioseditor-rbe"
## explorer "https://www.igorslab.de/installer/MoreClockTool_v1111_2.zip"
Write-Host "Installing: More Clock Tool..."
Write-Host "Navi GPUS only, 5000 series and above" -ForegroundColor Red

# download more clock tool
Get-FileFromWeb -URL "https://github.com/FR33THYFR33THY/files/raw/refs/heads/main/More%20Clock%20Tool.exe" -File "$env:SystemDrive\Program Files (x86)\More Clock Tool\More Clock Tool.exe"

# create desktop shortcut
$WshShell = New-Object -comObject WScript.Shell
$Desktop = (New-Object -ComObject Shell.Application).Namespace('shell:Desktop').Self.Path
$Shortcut = $WshShell.CreateShortcut("$Desktop\More Clock Tool.lnk")
$Shortcut.TargetPath = "$env:SystemDrive\Program Files (x86)\More Clock Tool\More Clock Tool.exe"
$Shortcut.Save()

# create start menu shortcut
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:ProgramData\Microsoft\Windows\Start Menu\Programs\More Clock Tool.lnk")
$Shortcut.TargetPath = "$env:SystemDrive\Program Files (x86)\More Clock Tool\More Clock Tool.exe"
$Shortcut.Save()
