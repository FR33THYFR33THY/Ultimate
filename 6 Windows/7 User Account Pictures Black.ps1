        # SCRIPT RUN AS ADMIN
        If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
        {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit}
        $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
        $Host.UI.RawUI.BackgroundColor = "Black"
        $Host.PrivateData.ProgressBackgroundColor = "Black"
        $Host.PrivateData.ProgressForegroundColor = "White"
        Clear-Host

        Write-Host "User Account Pictures:"
        Write-Host "1. Black"
        Write-Host "2. Default`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

# backup user account pictures
if (!(Test-Path "$env:SystemDrive\ProgramData\User Account Pictures")) {
Copy-Item "$env:SystemDrive\ProgramData\Microsoft\User Account Pictures" -Destination "$env:SystemDrive\ProgramData" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
}

# make all user account pictures black
$accountPicturesPath = "$env:SystemDrive\ProgramData\Microsoft\User Account Pictures"
$images = Get-ChildItem $accountPicturesPath -Include *.png,*.bmp -Recurse
Add-Type -AssemblyName System.Drawing
foreach ($image in $images) {
try {
$bitmap = [System.Drawing.Bitmap]::FromFile($image.FullName)
$width = $bitmap.Width
$height = $bitmap.Height
$bitmap.Dispose()
$newBitmap = New-Object System.Drawing.Bitmap($width, $height)
$graphics = [System.Drawing.Graphics]::FromImage($newBitmap)
$graphics.Clear([System.Drawing.Color]::Black)
$graphics.Dispose()
$newBitmap.Save($image.FullName)
$newBitmap.Dispose()
} catch { }
}

exit

          }
        2 {

Clear-Host

# restore user account pictures
Copy-Item "$env:SystemDrive\ProgramData\User Account Pictures" -Destination "$env:SystemDrive\ProgramData\Microsoft" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }