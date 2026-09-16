        # SCRIPT RUN AS ADMIN
        If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
        {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit}
        $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
        $Host.UI.RawUI.BackgroundColor = "Black"
        $Host.PrivateData.ProgressBackgroundColor = "Black"
        $Host.PrivateData.ProgressForegroundColor = "White"
        Clear-Host

        # SCRIPT CHECK INTERNET
        if (!(Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
        Write-Host "Internet Connection Required`n" -ForegroundColor Red
        Pause
        exit
        }

        # SCRIPT SILENT
        $progresspreference = 'silentlycontinue'

Write-Host "Installing: Mouse Movement Recorder...`n"

# new folder
New-Item -Path "$env:SystemDrive\Program Files (x86)\Mouse Movement Recorder" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

# download mouse movement recorder
IWR "https://github.com/FR33THYFR33THY/Ultimate/releases/download/Files/mousemovementrecorder.exe" -OutFile "$env:SystemDrive\Program Files (x86)\Mouse Movement Recorder\Mouse Movement Recorder.exe"

# create desktop shortcut
$WshShell = New-Object -comObject WScript.Shell
$Desktop = (New-Object -ComObject Shell.Application).Namespace('shell:Desktop').Self.Path
$Shortcut = $WshShell.CreateShortcut("$Desktop\Mouse Movement Recorder.lnk")
$Shortcut.TargetPath = "$env:SystemDrive\Program Files (x86)\Mouse Movement Recorder\Mouse Movement Recorder.exe"
$Shortcut.WorkingDirectory = "$env:SystemDrive\Program Files (x86)\Mouse Movement Recorder"
$Shortcut.IconLocation = "%SystemRoot%\System32\shell32.dll,248"
$Shortcut.Save()

# create start menu shortcut
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Mouse Movement Recorder.lnk")
$Shortcut.TargetPath = "$env:SystemDrive\Program Files (x86)\Mouse Movement Recorder\Mouse Movement Recorder.exe"
$Shortcut.WorkingDirectory = "$env:SystemDrive\Program Files (x86)\Mouse Movement Recorder"
$Shortcut.IconLocation = "%SystemRoot%\System32\shell32.dll,248"
$Shortcut.Save()

# open mouse movement recorder
Start-Process "$env:SystemDrive\Program Files (x86)\Mouse Movement Recorder\Mouse Movement Recorder.exe"

Clear-Host
Write-Host "Mouse optimizations:`n"
Write-Host "- Turn off motion sync"
Write-Host "- Keep dongle close to mouse"
Write-Host "- Disable angle snapping"
Write-Host "- Set lowest debounce time"
Write-Host "- Use maximum polling rate"
Write-Host "- USB port closest to the CPU`n"
Write-Host "Extreme polling may affect lower end CPU's & certain game engine framerates`n"
Write-Host "Set a comfortable DPI"
Write-Host "Increased DPI reduces pixel skipping & latency`n"
Write-Host "Suggested minimal DPI to reduce pixel skipping:`n"
Write-Host "- 400dpi for 1080p"
Write-Host "- 800dpi for 1440p"
Write-Host "- 1600dpi for 4k`n"
Write-Host "To prevent mouse acceleration when gaming:`n"
Write-Host "- Use 100% scaling"
Write-Host "- Set 6/11 & pointer precision off"
Write-Host "- Enable raw input in games when possible`n"
Write-Host "Some game engines may override 100% scaling for 4K, higher resolutions & laptops"
Write-Host "Scaling may need to manually locked at 100% through Advanced Scaling Settings`n"
Write-Host "For higher scaling with no acceleration see 'Scaling Higher No Accel.ps1'`n"

Pause