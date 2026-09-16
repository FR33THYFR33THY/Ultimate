# admin
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
{Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
Exit}

# silent
$progresspreference = 'silentlycontinue'

# download
iwr "https://github.com/FR33THYFR33THY/Ultimate/archive/refs/heads/main.zip" -OutFile "$env:SystemRoot\Temp\Ultimate.zip"

# extract
Expand-Archive -Path "$env:SystemRoot\Temp\Ultimate.zip" -DestinationPath "$env:SystemRoot\Temp\Ultimate" -Force

# rename
Rename-Item -Path "$env:SystemRoot\Temp\Ultimate\Ultimate-main" -NewName "Ultimate" -Force

# move
$Desktop = (New-Object -ComObject Shell.Application).Namespace('shell:Desktop').Self.Path
Move-Item -Path "$env:SystemRoot\Temp\Ultimate\Ultimate" -Destination "$Desktop" -Force

# allow
cmd /c "reg add `"HKCR\Applications\powershell.exe\shell\open\command`" /ve /t REG_SZ /d `"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -ExecutionPolicy unrestricted -File \`"`"%1\`"`"`" /f >nul 2>&1"
cmd /c "reg add `"HKCU\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell`" /v `"ExecutionPolicy`" /t REG_SZ /d `"Unrestricted`" /f >nul 2>&1"
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell`" /v `"ExecutionPolicy`" /t REG_SZ /d `"Unrestricted`" /f >nul 2>&1"

# unblock
Get-ChildItem -Path "$Desktop\Ultimate" -Recurse | Unblock-File

# open
Start-Process "$Desktop\Ultimate"

# exit
exit