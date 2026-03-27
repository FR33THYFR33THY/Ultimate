. $CommonScript

Ensure-Admin
Testing-Connection

Write-Host "Downloading: C++..."
# download c++ installers
Get-FileFromWeb -URL "https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x86.EXE" -File "$env:SystemRoot\Temp\vcredist2005_x86.exe"
Get-FileFromWeb -URL "https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x64.EXE" -File "$env:SystemRoot\Temp\vcredist2005_x64.exe"
Get-FileFromWeb -URL "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe" -File "$env:SystemRoot\Temp\vcredist2008_x86.exe"
Get-FileFromWeb -URL "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe" -File "$env:SystemRoot\Temp\vcredist2008_x64.exe"
Get-FileFromWeb -URL "https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe" -File "$env:SystemRoot\Temp\vcredist2010_x86.exe" 
Get-FileFromWeb -URL "https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe" -File "$env:SystemRoot\Temp\vcredist2010_x64.exe"
Get-FileFromWeb -URL "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" -File "$env:SystemRoot\Temp\vcredist2012_x86.exe"
Get-FileFromWeb -URL "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe" -File "$env:SystemRoot\Temp\vcredist2012_x64.exe"
Get-FileFromWeb -URL "https://download.microsoft.com/download/2/e/6/2e61cfa4-993b-4dd4-91da-3737cd5cd6e3/vcredist_x86.exe" -File "$env:SystemRoot\Temp\vcredist2013_x86.exe"
Get-FileFromWeb -URL "https://download.microsoft.com/download/2/e/6/2e61cfa4-993b-4dd4-91da-3737cd5cd6e3/vcredist_x64.exe" -File "$env:SystemRoot\Temp\vcredist2013_x64.exe"
Get-FileFromWeb -URL "https://aka.ms/vs/17/release/vc_redist.x86.exe" -File "$env:SystemRoot\Temp\vcredist2015_2017_2019_2022_x86.exe"
Get-FileFromWeb -URL "https://aka.ms/vs/17/release/vc_redist.x64.exe" -File "$env:SystemRoot\Temp\vcredist2015_2017_2019_2022_x64.exe"

Clear-Host
Write-Host "Installing: C++..."

# install c++ packages
Start-Process -wait "$env:SystemRoot\Temp\vcredist2005_x86.exe" -ArgumentList "/q"
Start-Process -wait "$env:SystemRoot\Temp\vcredist2005_x64.exe" -ArgumentList "/q"
Start-Process -wait "$env:SystemRoot\Temp\vcredist2008_x86.exe" -ArgumentList "/qb"
Start-Process -wait "$env:SystemRoot\Temp\vcredist2008_x64.exe" -ArgumentList "/qb"
Start-Process -wait "$env:SystemRoot\Temp\vcredist2010_x86.exe" -ArgumentList "/passive /norestart"
Start-Process -wait "$env:SystemRoot\Temp\vcredist2010_x64.exe" -ArgumentList "/passive /norestart"
Start-Process -wait "$env:SystemRoot\Temp\vcredist2012_x86.exe" -ArgumentList "/passive /norestart"
Start-Process -wait "$env:SystemRoot\Temp\vcredist2012_x64.exe" -ArgumentList "/passive /norestart"
Start-Process -wait "$env:SystemRoot\Temp\vcredist2013_x86.exe" -ArgumentList "/passive /norestart"
Start-Process -wait "$env:SystemRoot\Temp\vcredist2013_x64.exe" -ArgumentList "/passive /norestart"
Start-Process -wait "$env:SystemRoot\Temp\vcredist2015_2017_2019_2022_x86.exe" -ArgumentList "/passive /norestart"
Start-Process -wait "$env:SystemRoot\Temp\vcredist2015_2017_2019_2022_x64.exe" -ArgumentList "/passive /norestart"
