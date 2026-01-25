    If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
    {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit}
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
    $Host.UI.RawUI.BackgroundColor = "Black"
	$Host.PrivateData.ProgressBackgroundColor = "Black"
    $Host.PrivateData.ProgressForegroundColor = "White"
    Clear-Host

    Write-Host "1. Pause Updates for 1 Year"
    Write-Host "2. Unpause Updates"
    while ($true) {
    $choice = Read-Host " "
    if ($choice -match '^[1-2]$') {
    switch ($choice) {
    1 {

Clear-Host
# pause for 1 year
$pause = (Get-Date).AddDays(365)
$today = Get-Date
$today = $today.ToUniversalTime().ToString( 'yyyy-MM-ddTHH:mm:ssZ' )
$pause = $pause.ToUniversalTime().ToString( 'yyyy-MM-ddTHH:mm:ssZ' )
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseUpdatesExpiryTime' -Value $pause -Force >$null
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseFeatureUpdatesEndTime' -Value $pause -Force >$null
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseFeatureUpdatesStartTime' -Value $today -Force >$null
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseQualityUpdatesEndTime' -Value $pause -Force >$null
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseQualityUpdatesStartTime' -Value $today -Force >$null
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseUpdatesStartTime' -Value $today -Force >$null
Clear-Host
Write-Host "Done. Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Start-Process ms-settings:windowsupdate
exit

      }
    2 {

Clear-Host
# unpause
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseUpdatesExpiryTime' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseFeatureUpdatesEndTime' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseFeatureUpdatesStartTime' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseQualityUpdatesEndTime' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseQualityUpdatesStartTime' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseUpdatesStartTime' -ErrorAction SilentlyContinue
Clear-Host
Write-Host "Done. Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Start-Process ms-settings:windowsupdate
exit

      }
    } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
