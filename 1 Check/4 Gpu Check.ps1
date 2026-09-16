        # SCRIPT RUN AS ADMIN
        If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
        {Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit}
        $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
        $Host.UI.RawUI.BackgroundColor = "Black"
        $Host.PrivateData.ProgressBackgroundColor = "Black"
        $Host.PrivateData.ProgressForegroundColor = "White"
        Clear-Host

        # SCRIPT CHECK INTERNET
        if (!(Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
        Write-Host "Internet Connection Required`n" -ForegroundColor Red
        Pause
        exit
        }

        # SCRIPT SILENT
        $progresspreference = 'silentlycontinue'

Write-Host "Downloading: Gpu Z..."

# download gpuz
IWR "https://github.com/FR33THYFR33THY/Ultimate/releases/download/Files/gpuz.exe" -OutFile "$env:SystemRoot\Temp\gpuz.exe"

# start gpuz
Start-Process "$env:SystemRoot\Temp\gpuz.exe"

Clear-Host
Write-Host "GPU CHECK"
Write-Host "---------"
Write-Host "- Check Video Bus is at maximum"
Write-Host "- Check Resizable BAR is enabled"
Write-Host "- Verify monitor cable is connected to the GPU"
Write-Host "- Confirm GPU is in the top PCIe motherboard slot"
Write-Host "- Running multiple graphics cards is not recommended`n"

Pause