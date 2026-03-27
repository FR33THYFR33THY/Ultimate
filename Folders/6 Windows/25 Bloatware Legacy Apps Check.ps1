. $CommonScript

Ensure-Admin

Start-Process "$env:SystemDrive\Windows\system32\appwiz.cpl"

Get-Package | Select-Object Name | Format-Table -AutoSize

Write-Host ""

Pause
