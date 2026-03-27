. $CommonScript

Ensure-Admin
Test-Connection

        Write-Host "Higher Scaling With No Acceleration`n"
        Write-Host "1. 100%"
        Write-Host "2. 125%"
        Write-Host "3. 150%"
        Write-Host "4. 175%"
        Write-Host "5. 200%"
        Write-Host "6. 225%"
        Write-Host "7. 250%"
        Write-Host "8. 300%"
        Write-Host "9. 350%"
	    while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-9]$') {
        switch ($choice) {
        1 {

Clear-Host

# create reg file
$100 = @"
Windows Registry Editor Version 5.00

; 6-11 pointer speed
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSensitivity"="10"

; disable enhance pointer precision
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSpeed"="0"
"MouseThreshold1"="0"
"MouseThreshold2"="0"

; mouse curve default
[HKEY_CURRENT_USER\Control Panel\Mouse]
"SmoothMouseXCurve"=hex:\
    00,00,00,00,00,00,00,00,\
	c0,cc,0c,00,00,00,00,00,\
	80,99,19,00,00,00,00,00,\
	40,66,26,00,00,00,00,00,\
	00,33,33,00,00,00,00,00
"SmoothMouseYCurve"=hex:\
    00,00,00,00,00,00,00,00,\
	00,00,38,00,00,00,00,00,\
	00,00,70,00,00,00,00,00,\
	00,00,a8,00,00,00,00,00,\
	00,00,e0,00,00,00,00,00

; dpi scaling 100%
[HKEY_CURRENT_USER\Control Panel\Desktop]
"Win8DpiScaling"=dword:00000001
"LogPixels"=dword:00000060

; disable fix scaling for apps
[HKEY_CURRENT_USER\Control Panel\Desktop]
"EnablePerProcessSystemDPI"=dword:00000000
"@
Set-Content -Path "$env:SystemRoot\Temp\100%.reg" -Value $100 -Force

# import reg file
Regedit.exe /S "$env:SystemRoot\Temp\100%.reg"

exit

          }
        2 {

Clear-Host

# create reg file
$125 = @"
Windows Registry Editor Version 5.00

; 6-11 pointer speed
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSensitivity"="10"

; enable enhance pointer precision
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSpeed"="1"
"MouseThreshold1"="6"
"MouseThreshold2"="10"

; mouse curve 125% scaling
[HKEY_CURRENT_USER\Control Panel\Mouse]
"SmoothMouseXCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	00,00,10,00,00,00,00,00,\
	00,00,20,00,00,00,00,00,\
	00,00,30,00,00,00,00,00,\
	00,00,40,00,00,00,00,00
"SmoothMouseYCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	00,00,38,00,00,00,00,00,\
	00,00,70,00,00,00,00,00,\
	00,00,A8,00,00,00,00,00,\
	00,00,E0,00,00,00,00,00

; dpi scaling 125%
[HKEY_CURRENT_USER\Control Panel\Desktop]
"Win8DpiScaling"=dword:00000001
"LogPixels"=dword:00000078

; enable fix scaling for apps
[HKEY_CURRENT_USER\Control Panel\Desktop]
"EnablePerProcessSystemDPI"=dword:00000001
"@
Set-Content -Path "$env:SystemRoot\Temp\125%.reg" -Value $125 -Force

# import reg file
Regedit.exe /S "$env:SystemRoot\Temp\125%.reg"

exit

          }
        3 {

Clear-Host

# create reg file
$150 = @"
Windows Registry Editor Version 5.00

; 6-11 pointer speed
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSensitivity"="10"

; enable enhance pointer precision
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSpeed"="1"
"MouseThreshold1"="6"
"MouseThreshold2"="10"

; mouse curve 150% scaling
[HKEY_CURRENT_USER\Control Panel\Mouse]
"SmoothMouseXCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	30,33,13,00,00,00,00,00,\
	60,66,26,00,00,00,00,00,\
	90,99,39,00,00,00,00,00,\
	C0,CC,4C,00,00,00,00,00
"SmoothMouseYCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	00,00,38,00,00,00,00,00,\
	00,00,70,00,00,00,00,00,\
	00,00,A8,00,00,00,00,00,\
	00,00,E0,00,00,00,00,00

; dpi scaling 150%
[HKEY_CURRENT_USER\Control Panel\Desktop]
"Win8DpiScaling"=dword:00000001
"LogPixels"=dword:00000090

; enable fix scaling for apps
[HKEY_CURRENT_USER\Control Panel\Desktop]
"EnablePerProcessSystemDPI"=dword:00000001
"@
Set-Content -Path "$env:SystemRoot\Temp\150%.reg" -Value $150 -Force

# import reg file
Regedit.exe /S "$env:SystemRoot\Temp\150%.reg"

exit

          }
        4 {

Clear-Host

# create reg file
$175 = @"
Windows Registry Editor Version 5.00

; 6-11 pointer speed
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSensitivity"="10"

; enable enhance pointer precision
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSpeed"="1"
"MouseThreshold1"="6"
"MouseThreshold2"="10"

; mouse curve 175% scaling
[HKEY_CURRENT_USER\Control Panel\Mouse]
"SmoothMouseXCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	60,66,16,00,00,00,00,00,\
	C0,CC,2C,00,00,00,00,00,\
	20,33,43,00,00,00,00,00,\
	80,99,59,00,00,00,00,00
"SmoothMouseYCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	00,00,38,00,00,00,00,00,\
	00,00,70,00,00,00,00,00,\
	00,00,A8,00,00,00,00,00,\
	00,00,E0,00,00,00,00,00

; dpi scaling 175%
[HKEY_CURRENT_USER\Control Panel\Desktop]
"Win8DpiScaling"=dword:00000001
"LogPixels"=dword:000000a8

; enable fix scaling for apps
[HKEY_CURRENT_USER\Control Panel\Desktop]
"EnablePerProcessSystemDPI"=dword:00000001
"@
Set-Content -Path "$env:SystemRoot\Temp\175%.reg" -Value $175 -Force

# import reg file
Regedit.exe /S "$env:SystemRoot\Temp\175%.reg"

exit

          }
        5 {

Clear-Host

# create reg file
$200 = @"
Windows Registry Editor Version 5.00

; 6-11 pointer speed
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSensitivity"="10"

; enable enhance pointer precision
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSpeed"="1"
"MouseThreshold1"="6"
"MouseThreshold2"="10"

; mouse curve 200% scaling
[HKEY_CURRENT_USER\Control Panel\Mouse]
"SmoothMouseXCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	90,99,19,00,00,00,00,00,\
	20,33,33,00,00,00,00,00,\
	B0,CC,4C,00,00,00,00,00,\
	40,66,66,00,00,00,00,00
"SmoothMouseYCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	00,00,38,00,00,00,00,00,\
	00,00,70,00,00,00,00,00,\
	00,00,A8,00,00,00,00,00,\
	00,00,E0,00,00,00,00,00

; dpi scaling 200%
[HKEY_CURRENT_USER\Control Panel\Desktop]
"Win8DpiScaling"=dword:00000001
"LogPixels"=dword:000000c0

; enable fix scaling for apps
[HKEY_CURRENT_USER\Control Panel\Desktop]
"EnablePerProcessSystemDPI"=dword:00000001
"@
Set-Content -Path "$env:SystemRoot\Temp\200%.reg" -Value $200 -Force

# import reg file
Regedit.exe /S "$env:SystemRoot\Temp\200%.reg"

exit

          }
        6 {

Clear-Host

# create reg file
$225 = @"
Windows Registry Editor Version 5.00

; 6-11 pointer speed
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSensitivity"="10"

; enable enhance pointer precision
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSpeed"="1"
"MouseThreshold1"="6"
"MouseThreshold2"="10"

; mouse curve 225% scaling
[HKEY_CURRENT_USER\Control Panel\Mouse]
"SmoothMouseXCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	C0,CC,1C,00,00,00,00,00,\
	80,99,39,00,00,00,00,00,\
	40,66,56,00,00,00,00,00,\
	00,33,73,00,00,00,00,00
"SmoothMouseYCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	00,00,38,00,00,00,00,00,\
	00,00,70,00,00,00,00,00,\
	00,00,A8,00,00,00,00,00,\
	00,00,E0,00,00,00,00,00

; dpi scaling 225%
[HKEY_CURRENT_USER\Control Panel\Desktop]
"Win8DpiScaling"=dword:00000001
"LogPixels"=dword:000000d8

; enable fix scaling for apps
[HKEY_CURRENT_USER\Control Panel\Desktop]
"EnablePerProcessSystemDPI"=dword:00000001
"@
Set-Content -Path "$env:SystemRoot\Temp\225%.reg" -Value $225 -Force

# import reg file
Regedit.exe /S "$env:SystemRoot\Temp\225%.reg"

exit

          }  
        7 {

Clear-Host

# create reg file
$250 = @"
Windows Registry Editor Version 5.00

; 6-11 pointer speed
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSensitivity"="10"

; enable enhance pointer precision
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSpeed"="1"
"MouseThreshold1"="6"
"MouseThreshold2"="10"

; mouse curve 250% scaling
[HKEY_CURRENT_USER\Control Panel\Mouse]
"SmoothMouseXCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	00,00,20,00,00,00,00,00,\
	00,00,40,00,00,00,00,00,\
	00,00,60,00,00,00,00,00,\
	00,00,80,00,00,00,00,00
"SmoothMouseYCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	00,00,38,00,00,00,00,00,\
	00,00,70,00,00,00,00,00,\
	00,00,A8,00,00,00,00,00,\
	00,00,E0,00,00,00,00,00

; dpi scaling 250%
[HKEY_CURRENT_USER\Control Panel\Desktop]
"Win8DpiScaling"=dword:00000001
"LogPixels"=dword:000000f0

; enable fix scaling for apps
[HKEY_CURRENT_USER\Control Panel\Desktop]
"EnablePerProcessSystemDPI"=dword:00000001
"@
Set-Content -Path "$env:SystemRoot\Temp\250%.reg" -Value $250 -Force

# import reg file
Regedit.exe /S "$env:SystemRoot\Temp\250%.reg"

exit

          }
        8 {

Clear-Host

# create reg file
$300 = @"
Windows Registry Editor Version 5.00

; 6-11 pointer speed
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSensitivity"="10"

; enable enhance pointer precision
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSpeed"="1"
"MouseThreshold1"="6"
"MouseThreshold2"="10"

; mouse curve 300% scaling
[HKEY_CURRENT_USER\Control Panel\Mouse]
"SmoothMouseXCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	60,66,26,00,00,00,00,00,\
	C0,CC,4C,00,00,00,00,00,\
	20,33,73,00,00,00,00,00,\
	80,99,99,00,00,00,00,00
"SmoothMouseYCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	00,00,38,00,00,00,00,00,\
	00,00,70,00,00,00,00,00,\
	00,00,A8,00,00,00,00,00,\
	00,00,E0,00,00,00,00,00

; dpi scaling 300%
[HKEY_CURRENT_USER\Control Panel\Desktop]
"Win8DpiScaling"=dword:00000001
"LogPixels"=dword:00000120

; enable fix scaling for apps
[HKEY_CURRENT_USER\Control Panel\Desktop]
"EnablePerProcessSystemDPI"=dword:00000001
"@
Set-Content -Path "$env:SystemRoot\Temp\300%.reg" -Value $300 -Force

# import reg file
Regedit.exe /S "$env:SystemRoot\Temp\300%.reg"

exit

          }
        9 {

Clear-Host

# create reg file
$350 = @"
Windows Registry Editor Version 5.00

; 6-11 pointer speed
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSensitivity"="10"

; enable enhance pointer precision
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSpeed"="1"
"MouseThreshold1"="6"
"MouseThreshold2"="10"

; mouse curve 350% scaling
[HKEY_CURRENT_USER\Control Panel\Mouse]
"SmoothMouseXCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	C0,CC,2C,00,00,00,00,00,\
	80,99,59,00,00,00,00,00,\
	40,66,86,00,00,00,00,00,\
	00,33,B3,00,00,00,00,00
"SmoothMouseYCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	00,00,38,00,00,00,00,00,\
	00,00,70,00,00,00,00,00,\
	00,00,A8,00,00,00,00,00,\
	00,00,E0,00,00,00,00,00

; dpi scaling 350%
[HKEY_CURRENT_USER\Control Panel\Desktop]
"Win8DpiScaling"=dword:00000001
"LogPixels"=dword:00000150

; enable fix scaling for apps
[HKEY_CURRENT_USER\Control Panel\Desktop]
"EnablePerProcessSystemDPI"=dword:00000001
"@
Set-Content -Path "$env:SystemRoot\Temp\350%.reg" -Value $350 -Force

# import reg file
Regedit.exe /S "$env:SystemRoot\Temp\350%.reg"

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-9)." } }
