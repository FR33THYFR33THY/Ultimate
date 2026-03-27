. $CommonScript

Ensure-Admin
		
Start-Process "ms-settings:optionalfeatures"

dism /online /get-capabilities /format:table

Write-Host ""

Pause
