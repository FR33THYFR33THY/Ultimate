. $CommonScript

Ensure-Admin
Testing-Connection

# SCRIPT SILENT
$progresspreference = 'silentlycontinue'


        Write-Host "SELECT YOUR SYSTEM'S GPU`n" -ForegroundColor Yellow
        Write-Host " 1.  NVIDIA" -ForegroundColor Green
        Write-Host " 2.  AMD" -ForegroundColor Red
        Write-Host " 3.  INTEL`n" -ForegroundColor Blue
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-3]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "Unless recording or using replay buffer," -ForegroundColor Red 
Write-Host "avoid installing the NVIDIA App.`n" -ForegroundColor Red
Write-Host "Game Filter (ALT+F3) and Statistics (ALT+R)," -ForegroundColor Red 
Write-Host "will significantly reduce FPS when enabled.`n" -ForegroundColor Red
Write-Host "In the NVIDIA App turn off," -ForegroundColor Red
Write-Host "'Automatically optimize newly added games and apps'.`n" -ForegroundColor Red

# find latest nvidia driver
$uri = 'https://gfwsl.geforce.com/services_toolkit/services/com/nvidia/services/AjaxDriverService.php?func=DriverManualLookup&psid=120&pfid=929&osID=57&languageCode=1033&isWHQL=1&dch=1&sort1=0&numberOfResults=1'
$response = Invoke-WebRequest -Uri $uri -Method GET -UseBasicParsing
$payload = $response.Content | ConvertFrom-Json
$version =  $payload.IDS[0].downloadInfo.Version
$windowsVersion = if ([Environment]::OSVersion.Version -ge (new-object 'Version' 9, 1)) {"win10-win11"} else {"win8-win7"}
$windowsArchitecture = if ([Environment]::Is64BitOperatingSystem) {"64bit"} else {"32bit"}
$url = "https://international.download.nvidia.com/Windows/$version/$version-desktop-$windowsVersion-$windowsArchitecture-international-dch-whql.exe"
Write-Output "Downloading: Nvidia Driver $version"

# download nvidia driver
Get-FileFromWeb -URL $url -File "$env:SystemRoot\Temp\NvidiaDriver.exe"
Clear-Host

# open nvidia driver installer
Start-Process "$env:SystemRoot\Temp\NvidiaDriver.exe"

exit

          }
        2 {

Clear-Host

Write-Host "Downloading: AMD Driver Web Installer..."

# download amd driver auto detect
$DownloadAmd = Invoke-WebRequest "https://www.amd.com/en/support/download/drivers.html" -UseBasicParsing |
Select-Object -ExpandProperty Links |
Where-Object { $_.href -match "drivers\.amd\.com/drivers/installer/.*/whql/amd-software-adrenalin-edition-.*-minimalsetup-.*_web\.exe" } | Select-Object href
$spoofwebbrowser = @{
"User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
"Accept"     = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
"Referer"    = "https://www.amd.com/"
}
Invoke-WebRequest $DownloadAmd.href -UseBasicParsing -Headers $spoofwebbrowser -OutFile "$env:SystemRoot\Temp\AmdDriver.exe" -ErrorAction SilentlyContinue | Out-Null

# open amd web driver installer
Start-Process "$env:SystemRoot\Temp\AmdDriver.exe"

exit

          }
        3 {

Clear-Host

# open intel driver web page
Start-Process "https://www.intel.com/content/www/us/en/search.html#sortCriteria=%40lastmodifieddt%20descending&f-operatingsystem_en=Windows%2011%20Family*&f-downloadtype=Drivers&cf-tabfilter=Downloads&cf-downloadsppth=Graphics"

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-3)." } }
