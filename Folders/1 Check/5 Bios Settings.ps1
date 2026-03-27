. $CommonScript

Ensure-Admin

Write-Host "INTEL CPU"
Write-Host "- ENABLE ram profile (XMP DOCP EXPO)"
Write-Host "- DISABLE c-states (K CHIPS ONLY)"
Write-Host "- ENABLE resizable bar (REBAR C.A.M)"
Write-Host "- DISABLE i-gpu`n"
Write-Host "AMD CPU"
Write-Host "- ENABLE ram profile (XMP DOCP EXPO)"
Write-Host "- ENABLE precision boost overdrive (PBO)"
Write-Host "- ENABLE resizable bar (REBAR C.A.M)"
Write-Host "- DISABLE iommu (NEEDED FOR FACEIT)"
Write-Host "- DISABLE i-gpu`n"
Write-Host "MAX pump and set fans to performance`n"
Write-Host "DISABLE any driver installer software"
Write-Host "- Asus armory crate"
Write-Host "- MSI driver utility"
Write-Host "- Gigabyte update utility"
Write-Host "- Asrock motherboard utility`n"

Write-Host "Press Enter to Restart to BIOS" -ForegroundColor Red
Pause

# restart to bios
cmd /c C:\Windows\System32\shutdown.exe /r /fw
