        # SCRIPT RUN AS ADMIN
        If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
        {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit}
        $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
        $Host.UI.RawUI.BackgroundColor = "Black"
        $Host.PrivateData.ProgressBackgroundColor = "Black"
        $Host.PrivateData.ProgressForegroundColor = "White"
        Clear-Host

Write-Host "Unhide: Enhancements Tab`n"
Write-Host "Not working/bugged?"
Write-Host "- Roll back/uninstall audio driver"
Write-Host "- Try a different playback device`n"

Pause

# stop audio services
Stop-Service audiosrv -Force
Stop-Service AudioEndpointBuilder -Force

# unhide enhancements tab for all sound devices
$basePath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render"
$guids = Get-ChildItem -Path $basePath -Force -ErrorAction SilentlyContinue

# create reg file
$regContent = "Windows Registry Editor Version 5.00`n"
foreach ($guid in $guids) {
$regPath = $guid.Name
$regContent += "`n[$regPath\FxProperties]`n"
$regContent += "`"{d04e05a6-594b-4fb6-a80d-01af5eed7d1d},3`"=`"{5860E1C5-F95C-4a7a-8EC8-8AEF24F379A1}`"`n"
}

# save reg file
Set-Content -Path "$env:SystemRoot\Temp\loudnesseq.reg" -Value $regContent -Force

# import reg file
regedit /s "$env:SystemRoot\Temp\loudnesseq.reg"

# start audio services
Start-Service audiosrv
Start-Service AudioEndpointBuilder

# open sound control panel
Start-Process mmsys.cpl