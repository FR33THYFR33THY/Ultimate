. $CommonScript

Ensure-Admin

# get motherboard id
$instanceID = (Get-CimInstance Win32_BaseBoard).Product
$query = [uri]::EscapeDataString($instanceID)

# search motherboard id in web browser
Start-Process "https://www.google.com/search?q=$query"
