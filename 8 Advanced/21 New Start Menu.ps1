    If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
    {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit}
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
    $Host.UI.RawUI.BackgroundColor = "Black"
	$Host.PrivateData.ProgressBackgroundColor = "Black"
    $Host.PrivateData.ProgressForegroundColor = "White"
    Clear-Host

    Write-Host "1. New Start Menu"
    Write-Host "2. Old Start Menu"
    while ($true) {
    $choice = Read-Host " "
    if ($choice -match '^[1-2]$') {
    switch ($choice) {
    1 {

Clear-Host
# create reg file
$MultilineComment = @"
Windows Registry Editor Version 5.00

; new 25h2 start menu
[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\14\3036241548]
"EnabledState"=dword:00000002
"EnabledStateOptions"=dword:00000000

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\14\2792562829]
"EnabledState"=dword:00000002
"EnabledStateOptions"=dword:00000000

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\14\762256525]
"EnabledState"=dword:00000002
"EnabledStateOptions"=dword:00000000

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\14\734731404]
"EnabledState"=dword:00000002
"EnabledStateOptions"=dword:00000000

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\14\2114784909]
"EnabledState"=dword:00000002
"EnabledStateOptions"=dword:00000000

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\14\905601679]
"EnabledState"=dword:00000002
"EnabledStateOptions"=dword:00000000

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\14\1853569164]
"EnabledState"=dword:00000002
"EnabledStateOptions"=dword:00000000

; set start menu apps view to list
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Start]
"AllAppsViewMode"=dword:00000002
"@
Set-Content -Path "$env:TEMP\NewStartMenu.reg" -Value $MultilineComment -Force
# edit reg file
$path = "$env:TEMP\NewStartMenu.reg"
(Get-Content $path) -replace "\?","$" | Out-File $path
# import reg file
Regedit.exe /S "$env:TEMP\NewStartMenu.reg"
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

; remove 25h2 start menu
[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\14\3036241548]
"EnabledState"=-
"EnabledStateOptions"=-

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\14\2792562829]
"EnabledState"=-
"EnabledStateOptions"=-

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\14\762256525]
"EnabledState"=-
"EnabledStateOptions"=-

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\14\734731404]
"EnabledState"=-
"EnabledStateOptions"=-

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\14\2114784909]
"EnabledState"=-
"EnabledStateOptions"=-

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\14\905601679]
"EnabledState"=-
"EnabledStateOptions"=-

[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\14\1853569164]
"EnabledState"=-
"EnabledStateOptions"=-

; set start menu apps view to category
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Start]
"AllAppsViewMode"=dword:00000000
"@
Set-Content -Path "$env:TEMP\OldStartMenu.reg" -Value $MultilineComment -Force
# edit reg file
$path = "$env:TEMP\OldStartMenu.reg"
(Get-Content $path) -replace "\?","$" | Out-File $path
# import reg file
Regedit.exe /S "$env:TEMP\OldStartMenu.reg"
Clear-Host
Write-Host "Restart to apply..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit

      }
    } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }