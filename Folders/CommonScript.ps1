# Admin Check 
function Ensure-Admin {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
        ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

        Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit
    }

    $Host.UI.RawUI.WindowTitle = "$($myInvocation.MyCommand.Definition) (Administrator)"
    $Host.UI.RawUI.BackgroundColor = "Black"
    $Host.PrivateData.ProgressBackgroundColor = "Black"
    $Host.PrivateData.ProgressForegroundColor = "White"
    Clear-Host
}

# File Web Download 
function Get-FileFromWeb {
    param (
        [Parameter(Mandatory)][string]$URL,
        [Parameter(Mandatory)][string]$File
    )

    function Show-Progress {
        param (
            [Parameter(Mandatory)][Single]$TotalValue,
            [Parameter(Mandatory)][Single]$CurrentValue,
            [Parameter(Mandatory)][string]$ProgressText,
            [Parameter()][int]$BarSize = 10,
            [Parameter()][switch]$Complete
        )
        $percent = $CurrentValue / $TotalValue
        $percentComplete = $percent * 100
        if ($psISE) {
            Write-Progress "$ProgressText" -id 0 -percentComplete $percentComplete
        } else {
            Write-Host -NoNewLine "`r$ProgressText $(''.PadRight($BarSize * $percent, [char]9608).PadRight($BarSize, [char]9617)) $($percentComplete.ToString('##0.00').PadLeft(6)) % "
        }
    }

    try {
        $request = [System.Net.HttpWebRequest]::Create($URL)
        $response = $request.GetResponse()
        if ($response.StatusCode -in 401,403,404) { 
            throw "Remote file either doesn't exist, is unauthorized, or is forbidden for '$URL'." 
        }

        # Ensure file path exists
        if (!(Split-Path $File)) { 
            $File = Join-Path (Get-Location) $File 
        }
        $fileDirectory = [System.IO.Path]::GetDirectoryName($File)
        if (!(Test-Path $fileDirectory)) { 
            [System.IO.Directory]::CreateDirectory($fileDirectory) | Out-Null 
        }

        # Download with progress
        [long]$fullSize = $response.ContentLength
        [byte[]]$buffer = New-Object byte[] 1048576
        [long]$total = 0
        $reader = $response.GetResponseStream()
        $writer = New-Object System.IO.FileStream $File, 'Create'

        do {
            $count = $reader.Read($buffer, 0, $buffer.Length)
            $writer.Write($buffer, 0, $count)
            $total += $count
            if ($fullSize -gt 0) { 
                Show-Progress -TotalValue $fullSize -CurrentValue $total -ProgressText "Downloading $([System.IO.Path]::GetFileName($File))"
            }
        } while ($count -gt 0)

    } finally {
        $reader.Close()
        $writer.Close()
        Write-Host ""
    }
}
# Modern File Picker
    	function Show-ModernFilePicker {
    	param(
    	[ValidateSet('Folder', 'File')]
    	$Mode,
    	[string]$fileType
    	)
    	if ($Mode -eq 'Folder') {
    	$Title = 'Select Folder'
    	$modeOption = $false
    	$Filter = "Folders|`n"
    	}
    	else {
    	$Title = 'Select File'
    	$modeOption = $true
    	if ($fileType) {
    	$Filter = "$fileType Files (*.$fileType) | *.$fileType|All files (*.*)|*.*"
    	}
    	else {
    	$Filter = 'All Files (*.*)|*.*'
    	}
    	}
    	$AssemblyFullName = 'System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
    	$Assembly = [System.Reflection.Assembly]::Load($AssemblyFullName)
    	$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    	$OpenFileDialog.AddExtension = $modeOption
    	$OpenFileDialog.CheckFileExists = $modeOption
    	$OpenFileDialog.DereferenceLinks = $true
    	$OpenFileDialog.Filter = $Filter
    	$OpenFileDialog.Multiselect = $false
    	$OpenFileDialog.Title = $Title
    	$OpenFileDialog.InitialDirectory = [Environment]::GetFolderPath('Desktop')
    	$OpenFileDialogType = $OpenFileDialog.GetType()
    	$FileDialogInterfaceType = $Assembly.GetType('System.Windows.Forms.FileDialogNative+IFileDialog')
    	$IFileDialog = $OpenFileDialogType.GetMethod('CreateVistaDialog', @('NonPublic', 'Public', 'Static', 'Instance')).Invoke($OpenFileDialog, $null)
    	$null = $OpenFileDialogType.GetMethod('OnBeforeVistaDialog', @('NonPublic', 'Public', 'Static', 'Instance')).Invoke($OpenFileDialog, $IFileDialog)
    	if ($Mode -eq 'Folder') {
    	[uint32]$PickFoldersOption = $Assembly.GetType('System.Windows.Forms.FileDialogNative+FOS').GetField('FOS_PICKFOLDERS').GetValue($null)
    	$FolderOptions = $OpenFileDialogType.GetMethod('get_Options', @('NonPublic', 'Public', 'Static', 'Instance')).Invoke($OpenFileDialog, $null) -bor $PickFoldersOption
    	$null = $FileDialogInterfaceType.GetMethod('SetOptions', @('NonPublic', 'Public', 'Static', 'Instance')).Invoke($IFileDialog, $FolderOptions)
    	}
    	$VistaDialogEvent = [System.Activator]::CreateInstance($AssemblyFullName, 'System.Windows.Forms.FileDialog+VistaDialogEvents', $false, 0, $null, $OpenFileDialog, $null, $null).Unwrap()
    	[uint32]$AdviceCookie = 0
    	$AdvisoryParameters = @($VistaDialogEvent, $AdviceCookie)
    	$AdviseResult = $FileDialogInterfaceType.GetMethod('Advise', @('NonPublic', 'Public', 'Static', 'Instance')).Invoke($IFileDialog, $AdvisoryParameters)
    	$AdviceCookie = $AdvisoryParameters[1]
    	$Result = $FileDialogInterfaceType.GetMethod('Show', @('NonPublic', 'Public', 'Static', 'Instance')).Invoke($IFileDialog, [System.IntPtr]::Zero)
    	$null = $FileDialogInterfaceType.GetMethod('Unadvise', @('NonPublic', 'Public', 'Static', 'Instance')).Invoke($IFileDialog, $AdviceCookie)
    	if ($Result -eq [System.Windows.Forms.DialogResult]::OK) {
    	$FileDialogInterfaceType.GetMethod('GetResult', @('NonPublic', 'Public', 'Static', 'Instance')).Invoke($IFileDialog, $null)
    	}
    	return $OpenFileDialog.FileName
    	}
   
# Check Internet    
function Testing-Connection {
    if (!(Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
     Write-Host "Internet Connection Required`n" -ForegroundColor Red
     Pause
     exit
    }
}

        # FUNCTION RUN AS TRUSTED INSTALLER
        function Run-Trusted([String]$command) {
        try {
    	Stop-Service -Name TrustedInstaller -Force -ErrorAction Stop -WarningAction Stop
  		}
  		catch {
    	taskkill /im trustedinstaller.exe /f >$null
  		}
        $service = Get-CimInstance -ClassName Win32_Service -Filter "Name='TrustedInstaller'"
        $DefaultBinPath = $service.PathName
  		$trustedInstallerPath = "$env:SystemRoot\servicing\TrustedInstaller.exe"
  		if ($DefaultBinPath -ne $trustedInstallerPath) {
    	$DefaultBinPath = $trustedInstallerPath
  		}
        $bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
        $base64Command = [Convert]::ToBase64String($bytes)
        sc.exe config TrustedInstaller binPath= "cmd.exe /c powershell.exe -encodedcommand $base64Command" | Out-Null
        sc.exe start TrustedInstaller | Out-Null
        sc.exe config TrustedInstaller binpath= "`"$DefaultBinPath`"" | Out-Null
        try {
    	Stop-Service -Name TrustedInstaller -Force -ErrorAction Stop -WarningAction Stop
  		}
  		catch {
    	taskkill /im trustedinstaller.exe /f >$null
  		}
        }

