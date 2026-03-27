. $CommonScript

Ensure-Admin

	
Start-Process "ms-settings:appsfeatures"

Get-AppXPackage | select name | format-table -autosize

Pause
