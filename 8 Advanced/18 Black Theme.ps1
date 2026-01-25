    If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
    {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit}
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
    $Host.UI.RawUI.BackgroundColor = "Black"
	$Host.PrivateData.ProgressBackgroundColor = "Black"
    $Host.PrivateData.ProgressForegroundColor = "White"
    Clear-Host

    Write-Host "1. Black Theme"
    Write-Host "2. Default Theme"
    while ($true) {
    $choice = Read-Host " "
    if ($choice -match '^[1-2]$') {
    switch ($choice) {
    1 {

Clear-Host
# create reg file
$MultilineComment = @"
Windows Registry Editor Version 5.00

; black theme
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"EnableTransparency"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"AppsUseLightTheme"=dword:00000000
"SystemUsesLightTheme"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"AppsUseLightTheme"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"ColorPrevalence"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent]
"AccentPalette"=hex:64,64,64,00,6b,6b,6b,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00
"StartColorMenu"=dword:00000000
"AccentColorMenu"=dword:00000000

[HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM]
"EnableWindowColorization"=dword:00000001
"AccentColor"=dword:ff191919
"ColorizationColor"=dword:c4191919
"ColorizationAfterglow"=dword:c4191919

[HKEY_CURRENT_USER\Control Panel\Desktop]
"WallPaper"=""

[HKEY_CURRENT_USER\Control Panel\Colors]
"Background"="0 0 0"

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers]
"BackgroundType"=dword:00000001
"@
Set-Content -Path "$env:TEMP\BlackTheme.reg" -Value $MultilineComment -Force
# edit reg file
$path = "$env:TEMP\BlackTheme.reg"
(Get-Content $path) -replace "\?","$" | Out-File $path
# import reg file
Regedit.exe /S "$env:TEMP\BlackTheme.reg"
Clear-Host
Write-Host "Restart to apply..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit

      }
    2 {

Clear-Host
# create reg file
$MultilineComment = @"
Windows Registry Editor Version 5.00

; default theme
[HKEY_CURRENT_USER\Control Panel\Desktop]
"WallPaper"="C:\\Windows\\web\\wallpaper\\Windows\\img0.jpg"

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers]
"BackgroundHistoryPath0"="C:\\Windows\\web\\wallpaper\\Windows\\img0.jpg"
"CurrentWallpaperPath"="C:\\Windows\\web\\wallpaper\\Windows\\img0.jpg"

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers]
"BackgroundType"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"AppsUseLightTheme"=dword:00000001
"SystemUsesLightTheme"=dword:00000001

[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent]
"AccentPalette"=hex:99,eb,ff,00,4c,c2,ff,00,00,91,f8,00,00,78,d4,00,00,67,c0,\
  00,00,3e,92,00,00,1a,68,00,f7,63,0c,00
"StartColorMenu"=dword:ffc06700
"AccentColorMenu"=dword:ffd47800

[HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM]
"EnableWindowColorization"=dword:00000000
"AccentColor"=dword:ffd47800
"ColorizationColor"=dword:c40078d4
"ColorizationAfterglow"=dword:c40078d4

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"ColorPrevalence"=dword:00000000

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"EnableTransparency"=dword:00000001
"@
Set-Content -Path "$env:TEMP\DefaultTheme.reg" -Value $MultilineComment -Force
# edit reg file
$path = "$env:TEMP\DefaultTheme.reg"
(Get-Content $path) -replace "\?","$" | Out-File $path
# import reg file
Regedit.exe /S "$env:TEMP\DefaultTheme.reg"
Clear-Host
Write-Host "Restart to apply..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit

      }
    } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }