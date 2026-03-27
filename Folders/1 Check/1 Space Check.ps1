. $CommonScript

Ensure-Admin

Write-Host "Keep SSD's at least 10% free`n"

# show space for all drives
Get-Volume | Where-Object {$_.DriveLetter} | Sort-Object DriveLetter | ForEach-Object {
try {
$percentRemain = ($_.SizeRemaining / $_.Size) * 100
Write-Host "$($_.DriveLetter): Free space = $($percentRemain.ToString().substring(0,4))%"
} catch {}
}

# open file explorer
Start-Process explorer shell:MyComputerFolder

Write-Host ""

Pause
