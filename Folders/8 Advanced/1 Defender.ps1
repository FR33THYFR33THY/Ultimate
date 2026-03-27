. $CommonScript

Ensure-Admin

        Write-Host "1. Defender: Disable"
        Write-Host "2. Defender: Enable (Default)`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "Defender: Disable...`n"

# create defenderdisable ps1 file
$DefenderDisable = @'
        # SCRIPT RUN AS ADMIN
        If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
        {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit}
        $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
        $Host.UI.RawUI.BackgroundColor = "Black"
        $Host.PrivateData.ProgressBackgroundColor = "Black"
        $Host.PrivateData.ProgressForegroundColor = "White"
        Clear-Host

        # FUNCTION RUN AS TRUSTED INSTALLER
        function Run-Trusted([String]$command) {
        try {
    	Stop-Service -Name TrustedInstaller -Force -ErrorAction Stop -WarningAction Stop
  		}
  		catch {
    	taskkill /im trustedinstaller.exe /f >$null
  		}
        $service = Get-CimInstance -ClassName Win32_Service -Filter "Name='TrustedInstaller'"
        $DefaultBinPath = $service.PathName
  		$trustedInstallerPath = "$env:SystemRoot\servicing\TrustedInstaller.exe"
  		if ($DefaultBinPath -ne $trustedInstallerPath) {
    	$DefaultBinPath = $trustedInstallerPath
  		}
        $bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
        $base64Command = [Convert]::ToBase64String($bytes)
        sc.exe config TrustedInstaller binPath= "cmd.exe /c powershell.exe -encodedcommand $base64Command" | Out-Null
        sc.exe start TrustedInstaller | Out-Null
        sc.exe config TrustedInstaller binpath= "`"$DefaultBinPath`"" | Out-Null
        try {
    	Stop-Service -Name TrustedInstaller -Force -ErrorAction Stop -WarningAction Stop
  		}
  		catch {
    	taskkill /im trustedinstaller.exe /f >$null
  		}
        }

	    # REMOVE WINLOGON PS1 FILE
        cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`" /v `"Userinit`" /t REG_SZ /d `"C:\WINDOWS\system32\userinit.exe,`" /f >nul 2>&1"

Write-Host "Defender: Disable...`n"

# start explorer
Start-Process explorer

$windowssecuritysettings = @(
# virus & threat protection - manage settings
# real time protection - needs safe boot as trusted installer - windows turns this back on automatically
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection`" /v `"DisableRealtimeMonitoring`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',

# dev drive protection - needs safe boot as trusted installer
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection`" /v `"DisableAsyncScanOnOpen`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',

# cloud delivered protection - needs safe boot as trusted installer
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Spynet`" /v `"SpyNetReporting`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',

# automatic sample submission
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Spynet`" /v `"SubmitSamplesConsent`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',

# tamper protection - needs safe boot as trusted installer
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Features`" /v `"TamperProtection`" /t REG_DWORD /d `"4`" /f >nul 2>&1"',

# virus & threat protection - manage ransomware protection
# controlled folder access
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access`" /v `"EnableControlledFolderAccess`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',

# firewall & network protection - firewall notification settings - manage notifications
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications`" /v `"DisableEnhancedNotifications`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender Security Center\Virus and threat protection`" /v `"NoActionNotificationDisabled`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender Security Center\Virus and threat protection`" /v `"SummaryNotificationDisabled`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender Security Center\Virus and threat protection`" /v `"FilesBlockedNotificationDisabled`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows Defender Security Center\Account protection`" /v `"DisableNotifications`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows Defender Security Center\Account protection`" /v `"DisableDynamiclockNotifications`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows Defender Security Center\Account protection`" /v `"DisableWindowsHelloNotifications`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Services\SharedAccess\Epoch`" /v `"Epoch`" /t REG_DWORD /d `"1231`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile`" /v `"DisableNotifications`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile`" /v `"DisableNotifications`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile`" /v `"DisableNotifications`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',

# app & browser control - smart app control settings
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender`" /v `"VerifiedAndReputableTrustModeEnabled`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender`" /v `"SmartLockerMode`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender`" /v `"PUAProtection`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\AppID\Configuration\SMARTLOCKER`" /v `"START_PENDING`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\AppID\Configuration\SMARTLOCKER`" /v `"ENABLED`" /t REG_BINARY /d `"0000000000000000`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\CI\Policy`" /v `"VerifiedAndReputablePolicyState`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',

# app & browser control - reputation based protection settings
# check apps and files
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer`" /v `"SmartScreenEnabled`" /t REG_SZ /d `"Off`" /f >nul 2>&1"',

# smartscreen for microsoft edge - needs normal boot as admin
'cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Edge\SmartScreenEnabled`" /ve /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Edge\SmartScreenPuaEnabled`" /ve /t REG_DWORD /d `"0`" /f >nul 2>&1"',

# phishing protection
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components`" /v `"CaptureThreatWindow`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components`" /v `"NotifyMalicious`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components`" /v `"NotifyPasswordReuse`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components`" /v `"NotifyUnsafeApp`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components`" /v `"ServiceEnabled`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',

# potentially unwanted app blocking
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender`" /v `"PUAProtection`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',

# smartscreen for microsoft store apps - needs normal boot as admin
'cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost`" /v `"EnableWebContentEvaluation`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',

# app & browser control - exploit protection settings, leaving cfg control flow guard on for vanguard anticheat
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\Session Manager\kernel`" /v `"MitigationOptions`" /t REG_BINARY /d `"222222000001000000000000000000000000000000000000`" /f >nul 2>&1"',

# device security - core isolation details
# memory integrity
'cmd /c "reg delete `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity`" /v `"ChangedInBootCycle`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity`" /v `"Enabled`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg delete `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity`" /v `"WasEnabledBy`" /f >nul 2>&1"',

# turn off vbs virtualization based security
# faceit anti cheat forces this on, even after uninstall
'cmd /c "bcdedit /deletevalue allowedinmemorysettings >nul 2>&1"',
'cmd /c "bcdedit /deletevalue isolatedcontext >nul 2>&1"',
'cmd /c "bcdedit /deletevalue hypervisorlaunchtype >nul 2>&1"',
'cmd /c "reg delete `"HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard`" /v `"EnableVirtualizationBasedSecurity`" /f >nul 2>&1"',

# local security authority protection
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa`" /v `"RunAsPPL`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',

# microsoft vulnerable driver blocklist
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\CI\Config`" /v `"VulnerableDriverBlocklistEnable`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',

# defender services
# microsoft defender antivirus network inspection service
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WdNisSvc`" /v `"Start`" /t REG_DWORD /d `"4`" /f >nul 2>&1"',

# microsoft defender antivirus service
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WinDefend`" /v `"Start`" /t REG_DWORD /d `"4`" /f >nul 2>&1"',

# microsoft defender core service
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\MDCoreSvc`" /v `"Start`" /t REG_DWORD /d `"4`" /f >nul 2>&1"',

# security center
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\wscsvc`" /v `"Start`" /t REG_DWORD /d `"4`" /f >nul 2>&1"',

# web threat defense service
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\webthreatdefsvc`" /v `"Start`" /t REG_DWORD /d `"4`" /f >nul 2>&1"',

# web threat defense user service_XXXXX
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\webthreatdefusersvc`" /v `"Start`" /t REG_DWORD /d `"4`" /f >nul 2>&1"',

# windows defender advanced threat protection service
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Sense`" /v `"Start`" /t REG_DWORD /d `"4`" /f >nul 2>&1"',

# windows security service
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SecurityHealthService`" /v `"Start`" /t REG_DWORD /d `"4`" /f >nul 2>&1"',

# defender drivers
# microsoft defender antivirus boot driver
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WdBoot`" /v `"Start`" /t REG_DWORD /d `"4`" /f >nul 2>&1"',

# microsoft defender antivirus mini-filter driver
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WdFilter`" /v `"Start`" /t REG_DWORD /d `"4`" /f >nul 2>&1"',

# microsoft defender antivirus network inspection system driver
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WdNisDrv`" /v `"Start`" /t REG_DWORD /d `"4`" /f >nul 2>&1"'
)

# run $windowssecuritysettings as function with trusted installer
foreach ($command in $windowssecuritysettings) {
    Run-Trusted $command
}

# run $windowssecuritysettings as admin
foreach ($command in $windowssecuritysettings) {
    Invoke-Expression $command
}

# stop smartscreen running
Stop-Process -Force -Name smartscreen -ErrorAction SilentlyContinue | Out-Null

# move smartscreen
Run-Trusted "cmd /c move /y `"C:\Windows\System32\smartscreen.exe`" `"C:\Windows\smartscreen.exe`""

# windows defender default definitions
Dism /Online /NoRestart /Disable-Feature /FeatureName:Windows-Defender-Default-Definitions | Out-Null

# defender context menu handlers
cmd /c "reg delete `"HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shellex\ContextMenuHandlers\EPP`" /f >nul 2>&1"
cmd /c "reg delete `"HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Drive\shellex\ContextMenuHandlers\EPP`" /f >nul 2>&1"
cmd /c "reg delete `"HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\EPP`" /f >nul 2>&1"

# security health system tray
cmd /c "reg delete `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`" /v `"SecurityHealth`" /f >nul 2>&1"

# remove safe mode boot
cmd /c "bcdedit /deletevalue {current} safeboot >nul 2>&1"

Write-Host "Restarting`n" -ForegroundColor Red

# restart
Start-Sleep -Seconds 5
shutdown -r -t 00
'@
Set-Content -Path "$env:SystemRoot\Temp\DefenderDisable.ps1" -Value $DefenderDisable -Force

# install winlogon defenderdisable ps1 file to run in safe boot
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`" /v `"Userinit`" /t REG_SZ /d `"powershell.exe -nop -ep bypass -WindowStyle Maximized -f $env:SystemRoot\Temp\DefenderDisable.ps1`" /f >nul 2>&1"

# smartscreen for microsoft edge - needs normal boot as admin
cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Edge\SmartScreenEnabled`" /ve /t REG_DWORD /d `"0`" /f >nul 2>&1"

# smartscreen for microsoft store apps - needs normal boot as admin
cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost`" /v `"EnableWebContentEvaluation`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# scheduled tasks - needs normal boot as admin
schtasks /Change /TN "Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh" /Disable 2>$null | Out-Null
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Disable 2>$null | Out-Null
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Disable 2>$null | Out-Null
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Disable 2>$null | Out-Null
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /Disable 2>$null | Out-Null

# turn on safe boot
cmd /c "bcdedit /set {current} safeboot minimal >nul 2>&1"

Write-Host "Restarting`n" -ForegroundColor Red

# restart
Start-Sleep -Seconds 5
shutdown -r -t 00

exit

          }
        2 {

Clear-Host

Write-Host "Defender: Enable...`n"

# create defenderenable ps1 file
$DefenderEnable = @'
        # SCRIPT RUN AS ADMIN
        If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
        {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit}
        $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
        $Host.UI.RawUI.BackgroundColor = "Black"
        $Host.PrivateData.ProgressBackgroundColor = "Black"
        $Host.PrivateData.ProgressForegroundColor = "White"
        Clear-Host

        # FUNCTION RUN AS TRUSTED INSTALLER
        function Run-Trusted([String]$command) {
        try {
    	Stop-Service -Name TrustedInstaller -Force -ErrorAction Stop -WarningAction Stop
  		}
  		catch {
    	taskkill /im trustedinstaller.exe /f >$null
  		}
        $service = Get-CimInstance -ClassName Win32_Service -Filter "Name='TrustedInstaller'"
        $DefaultBinPath = $service.PathName
  		$trustedInstallerPath = "$env:SystemRoot\servicing\TrustedInstaller.exe"
  		if ($DefaultBinPath -ne $trustedInstallerPath) {
    	$DefaultBinPath = $trustedInstallerPath
  		}
        $bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
        $base64Command = [Convert]::ToBase64String($bytes)
        sc.exe config TrustedInstaller binPath= "cmd.exe /c powershell.exe -encodedcommand $base64Command" | Out-Null
        sc.exe start TrustedInstaller | Out-Null
        sc.exe config TrustedInstaller binpath= "`"$DefaultBinPath`"" | Out-Null
        try {
    	Stop-Service -Name TrustedInstaller -Force -ErrorAction Stop -WarningAction Stop
  		}
  		catch {
    	taskkill /im trustedinstaller.exe /f >$null
  		}
        }

	    # REMOVE WINLOGON PS1 FILE
        cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`" /v `"Userinit`" /t REG_SZ /d `"C:\WINDOWS\system32\userinit.exe,`" /f >nul 2>&1"

Write-Host "Defender: Enable...`n"

# start explorer
Start-Process explorer

$windowssecuritysettings = @(
# virus & threat protection - manage settings
# real time protection - needs safe boot as trusted installer - windows turns this back on automatically
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection`" /v `"DisableRealtimeMonitoring`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',

# dev drive protection - needs safe boot as trusted installer
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection`" /v `"DisableAsyncScanOnOpen`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',

# cloud delivered protection - needs safe boot as trusted installer
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Spynet`" /v `"SpyNetReporting`" /t REG_DWORD /d `"2`" /f >nul 2>&1"',

# automatic sample submission
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Spynet`" /v `"SubmitSamplesConsent`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',

# tamper protection - needs safe boot as trusted installer
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Features`" /v `"TamperProtection`" /t REG_DWORD /d `"5`" /f >nul 2>&1"',

# virus & threat protection - manage ransomware protection
# controlled folder access
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access`" /v `"EnableControlledFolderAccess`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',

# firewall & network protection - firewall notification settings - manage notifications
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications`" /v `"DisableEnhancedNotifications`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender Security Center\Virus and threat protection`" /v `"NoActionNotificationDisabled`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender Security Center\Virus and threat protection`" /v `"SummaryNotificationDisabled`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender Security Center\Virus and threat protection`" /v `"FilesBlockedNotificationDisabled`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows Defender Security Center\Account protection`" /v `"DisableNotifications`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows Defender Security Center\Account protection`" /v `"DisableDynamiclockNotifications`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows Defender Security Center\Account protection`" /v `"DisableWindowsHelloNotifications`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Services\SharedAccess\Epoch`" /v `"Epoch`" /t REG_DWORD /d `"1228`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile`" /v `"DisableNotifications`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile`" /v `"DisableNotifications`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile`" /v `"DisableNotifications`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',

# app & browser control - smart app control settings
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender`" /v `"VerifiedAndReputableTrustModeEnabled`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender`" /v `"SmartLockerMode`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender`" /v `"PUAProtection`" /t REG_DWORD /d `"2`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\AppID\Configuration\SMARTLOCKER`" /v `"START_PENDING`" /t REG_DWORD /d `"4`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\AppID\Configuration\SMARTLOCKER`" /v `"ENABLED`" /t REG_BINARY /d `"0400000000000000`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\CI\Policy`" /v `"VerifiedAndReputablePolicyState`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',

# app & browser control - reputation based protection settings
# check apps and files
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer`" /v `"SmartScreenEnabled`" /t REG_SZ /d `"Warn`" /f >nul 2>&1"',

# smartscreen for microsoft edge - needs normal boot as admin
'cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Edge\SmartScreenEnabled`" /ve /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Edge\SmartScreenPuaEnabled`" /ve /t REG_DWORD /d `"1`" /f >nul 2>&1"',

# phishing protection
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components`" /v `"CaptureThreatWindow`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components`" /v `"NotifyMalicious`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components`" /v `"NotifyPasswordReuse`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components`" /v `"NotifyUnsafeApp`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components`" /v `"ServiceEnabled`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',

# potentially unwanted app blocking
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender`" /v `"PUAProtection`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',

# smartscreen for microsoft store apps - needs normal boot as admin
'cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost`" /v `"EnableWebContentEvaluation`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',

# app & browser control - exploit protection settings
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\Session Manager\kernel`" /v `"MitigationOptions`" /t REG_BINARY /d `"111111000001000000000000000000000000000000000000`" /f >nul 2>&1"',

# device security - core isolation details
# memory integrity
'cmd /c "reg delete `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity`" /v `"ChangedInBootCycle`" /f >nul 2>&1"',
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity`" /v `"Enabled`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',
'cmd /c "reg delete `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity`" /v `"WasEnabledBy`" /t REG_DWORD /d `"2`" /f >nul 2>&1"',

# local security authority protection
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa`" /v `"RunAsPPL`" /t REG_DWORD /d `"2`" /f >nul 2>&1"',

# microsoft vulnerable driver blocklist
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\System\ControlSet001\Control\CI\Config`" /v `"VulnerableDriverBlocklistEnable`" /t REG_DWORD /d `"1`" /f >nul 2>&1"',

# defender services
# microsoft defender antivirus network inspection service
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WdNisSvc`" /v `"Start`" /t REG_DWORD /d `"3`" /f >nul 2>&1"',

# microsoft defender antivirus service
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WinDefend`" /v `"Start`" /t REG_DWORD /d `"2`" /f >nul 2>&1"',

# microsoft defender core service
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\MDCoreSvc`" /v `"Start`" /t REG_DWORD /d `"2`" /f >nul 2>&1"',

# security center
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\wscsvc`" /v `"Start`" /t REG_DWORD /d `"2`" /f >nul 2>&1"',

# web threat defense service
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\webthreatdefsvc`" /v `"Start`" /t REG_DWORD /d `"3`" /f >nul 2>&1"',

# web threat defense user service_XXXXX
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\webthreatdefusersvc`" /v `"Start`" /t REG_DWORD /d `"2`" /f >nul 2>&1"',

# windows defender advanced threat protection service
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Sense`" /v `"Start`" /t REG_DWORD /d `"3`" /f >nul 2>&1"',

# windows security service
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SecurityHealthService`" /v `"Start`" /t REG_DWORD /d `"2`" /f >nul 2>&1"',

# defender drivers
# microsoft defender antivirus boot driver
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WdBoot`" /v `"Start`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',

# microsoft defender antivirus mini-filter driver
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WdFilter`" /v `"Start`" /t REG_DWORD /d `"0`" /f >nul 2>&1"',

# microsoft defender antivirus network inspection system driver
'cmd /c "reg add `"HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WdNisDrv`" /v `"Start`" /t REG_DWORD /d `"3`" /f >nul 2>&1"'
)

# run $windowssecuritysettings as function with trusted installer
foreach ($command in $windowssecuritysettings) {
    Run-Trusted $command
}

# run $windowssecuritysettings as admin
foreach ($command in $windowssecuritysettings) {
    Invoke-Expression $command
}

# stop smartscreen running
Stop-Process -Force -Name smartscreen -ErrorAction SilentlyContinue | Out-Null

# move smartscreen
Run-Trusted "cmd /c move /y `"C:\Windows\smartscreen.exe`" `"C:\Windows\System32\smartscreen.exe`""

# windows defender default definitions (can't turn back on)
# Dism /Online /NoRestart /Enable-Feature /FeatureName:Windows-Defender-Default-Definitions | Out-Null

# defender context menu handlers
cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shellex\ContextMenuHandlers\EPP`" /ve /d `"{09A47860-11B0-4DA5-AFA5-26D86198A780}`" /f >nul 2>&1"
cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Drive\shellex\ContextMenuHandlers\EPP`" /ve /d `"{09A47860-11B0-4DA5-AFA5-26D86198A780}`" /f >nul 2>&1"
cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\EPP`" /ve /d `"{09A47860-11B0-4DA5-AFA5-26D86198A780}`" /f >nul 2>&1"

# security health system tray
cmd /c "reg add `"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`" /v `"SecurityHealth`" /t REG_EXPAND_SZ /d `"%windir%\system32\SecurityHealthSystray.exe`" /f >nul 2>&1"

# remove safe mode boot
cmd /c "bcdedit /deletevalue {current} safeboot >nul 2>&1"

Write-Host "Restarting`n" -ForegroundColor Red

# restart
Start-Sleep -Seconds 5
shutdown -r -t 00
'@
Set-Content -Path "$env:SystemRoot\Temp\DefenderEnable.ps1" -Value $DefenderEnable -Force

# install winlogon defenderenable ps1 file to run in safe boot
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`" /v `"Userinit`" /t REG_SZ /d `"powershell.exe -nop -ep bypass -WindowStyle Maximized -f $env:SystemRoot\Temp\DefenderEnable.ps1`" /f >nul 2>&1"

# smartscreen for microsoft edge - needs normal boot as admin
cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Edge\SmartScreenEnabled`" /ve /t REG_DWORD /d `"1`" /f >nul 2>&1"

# smartscreen for microsoft store apps - needs normal boot as admin
cmd /c "reg add `"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost`" /v `"EnableWebContentEvaluation`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

# scheduled tasks - needs normal boot as admin
schtasks /Change /TN "Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh" /Enable 2>$null | Out-Null
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Enable 2>$null | Out-Null
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Enable 2>$null | Out-Null
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Enable 2>$null | Out-Null
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /Enable 2>$null | Out-Null

# turn on safe boot
cmd /c "bcdedit /set {current} safeboot minimal >nul 2>&1"

Write-Host "Restarting`n" -ForegroundColor Red

# restart
Start-Sleep -Seconds 5
shutdown -r -t 00

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
