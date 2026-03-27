. $CommonScript

Ensure-Admin

        Write-Host "1. Signout Lockscreen Wallpaper: Black (Recommended)"
        Write-Host "2. Signout Lockscreen Wallpaper: Default`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

# create image
Add-Type -AssemblyName System.Windows.Forms
$screenWidth = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width
$screenHeight = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height
Add-Type -AssemblyName System.Drawing
$file = "C:\Windows\Black.jpg"
$edit = New-Object System.Drawing.Bitmap $screenWidth, $screenHeight
$color = [System.Drawing.Brushes]::Black
$graphics = [System.Drawing.Graphics]::FromImage($edit)
$graphics.FillRectangle($color, 0, 0, $edit.Width, $edit.Height)
$graphics.Dispose()
$edit.Save($file)
$edit.Dispose()

# set image
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP`" /v `"LockScreenImagePath`" /t REG_SZ /d `"C:\Windows\Black.jpg`" /f >nul 2>&1"
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP`" /v `"LockScreenImageStatus`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

# black wallpaper
cmd /c "reg add `"HKCU\Control Panel\Desktop`" /v `"Wallpaper`" /t REG_SZ /d `"C:\Windows\Black.jpg`" /f >nul 2>&1"
rundll32.exe user32.dll, UpdatePerUserSystemParameters

exit

          }
        2 {

Clear-Host

# revert set image
cmd /c "reg delete `"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP`" /f >nul 2>&1"

# revert black wallpaper
cmd /c "reg add `"HKCU\Control Panel\Desktop`" /v `"Wallpaper`" /t REG_SZ /d `"C:\Windows\Web\Wallpaper\Windows\img0.jpg`" /f >nul 2>&1"
rundll32.exe user32.dll, UpdatePerUserSystemParameters

# delete image
Remove-Item -Recurse -Force "C:\Windows\Black.jpg" -ErrorAction SilentlyContinue | Out-Null

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
