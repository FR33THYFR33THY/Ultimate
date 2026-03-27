. $CommonScript

Ensure-Admin

		Write-Host "1. Context Menu: Clean (Recommended)"
		Write-Host "2. Context Menu: Default`n"
		while ($true) {
		$choice = Read-Host " "
		if ($choice -match '^[1-2]$') {
		switch ($choice) {
		1 {

Clear-Host

# restore the classic context menu
cmd /c "reg add `"HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32`" /ve /t REG_SZ /d `"`" /f >nul 2>&1"

# remove customize this folder
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer`" /v `"NoCustomizeThisFolder`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

# remove pin to quick access
cmd /c "reg delete `"HKCR\Folder\shell\pintohome`" /f >nul 2>&1"

# remove add to favorites
cmd /c "reg delete `"HKCR\*\shell\pintohomefile`" /f >nul 2>&1"

# remove troubleshoot compatibility
cmd /c "reg delete `"HKCR\exefile\shellex\ContextMenuHandlers\Compatibility`" /f >nul 2>&1"

# remove open in terminal
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked`" /v `"{9F156763-7844-4DC4-B2B1-901F640F5155}`" /t REG_SZ /d `"`" /f >nul 2>&1"

# remove scan with defender
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked`" /v `"{09A47860-11B0-4DA5-AFA5-26D86198A780}`" /t REG_SZ /d `"`" /f >nul 2>&1"

# remove give access to
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked`" /v `"{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}`" /t REG_SZ /d `"`" /f >nul 2>&1"

# remove include in library
cmd /c "reg delete `"HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location`" /f >nul 2>&1"

# remove share
cmd /c "reg delete `"HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\ModernSharing`" /f >nul 2>&1"

# remove restore previous versions
cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer`" /v `"NoPreviousVersionsPage`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

# remove send to
cmd /c "reg delete `"HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo`" /f >nul 2>&1"
cmd /c "reg delete `"HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\SendTo`" /f >nul 2>&1"

exit

		  }
		2 {

Clear-Host

# context menu
cmd /c "reg delete `"HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}`" /f >nul 2>&1"

# customize this folder
cmd /c "reg delete `"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer`" /v `"NoCustomizeThisFolder`" /f >nul 2>&1"

# pin to quick access
# add to favorites
$ContextMenuDefault = @"
Windows Registry Editor Version 5.00

; pin to quick access
[HKEY_CLASSES_ROOT\Folder\shell\pintohome]
"AppliesTo"="System.ParsingName:<>\"::{f874310e-b6b7-47dc-bc84-b9e6b38f5903}\" AND System.ParsingName:<>\"::{679f85cb-0220-4080-b29b-5540cc05aab6}\" AND System.IsFolder:=System.StructuredQueryType.Boolean#True"
"CommandStateHandler"="{b455f46e-e4af-4035-b0a4-cf18d2f6f28e}"
"CommandStateSync"=""
"MUIVerb"="@shell32.dll,-51601"
"SkipCloudDownload"=dword:00000000

[HKEY_CLASSES_ROOT\Folder\shell\pintohome\command]
"DelegateExecute"="{b455f46e-e4af-4035-b0a4-cf18d2f6f28e}"

; add to favorites
[HKEY_CLASSES_ROOT\*\shell\pintohomefile]
"CommandStateHandler"="{b455f46e-e4af-4035-b0a4-cf18d2f6f28e}"
"CommandStateSync"=""
"MUIVerb"="@shell32.dll,-51608"
"NeverDefault"=""
"SkipCloudDownload"=dword:00000000

[HKEY_CLASSES_ROOT\*\shell\pintohomefile\command]
"DelegateExecute"="{b455f46e-e4af-4035-b0a4-cf18d2f6f28e}"
"@
Set-Content -Path "$env:SystemRoot\Temp\ContextMenuDefault.reg" -Value $ContextMenuDefault -Force

# import reg file
Regedit.exe /S "$env:SystemRoot\Temp\ContextMenuDefault.reg"

# troubleshoot compatibility
cmd /c "reg add `"HKCR\exefile\shellex\ContextMenuHandlers\Compatibility`" /ve /t REG_SZ /d `"{1d27f844-3a1f-4410-85ac-14651078412d}`" /f >nul 2>&1"

# open in terminal
# scan with defender
# give access to
cmd /c "reg delete `"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked`" /f >nul 2>&1"

# include in library
cmd /c "reg add `"HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location`" /ve /t REG_SZ /d `"{3dad6c5d-2167-4cae-9914-f99e41c12cfa}`" /f >nul 2>&1"

# share
cmd /c "reg add `"HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\ModernSharing`" /ve /t REG_SZ /d `"{e2bf9676-5f8f-435c-97eb-11607a5bedf7}`" /f >nul 2>&1"

# restore previous versions
cmd /c "reg delete `"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer`" /v `"NoPreviousVersionsPage`" /f >nul 2>&1"

# send to
cmd /c "reg add `"HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo`" /ve /t REG_SZ /d `"{7BA4C740-9E81-11CF-99D3-00AA004AE837}`" /f >nul 2>&1"
cmd /c "reg add `"HKCR\UserLibraryFolder\shellex\ContextMenuHandlers\SendTo`" /ve /t REG_SZ /d `"{7BA4C740-9E81-11CF-99D3-00AA004AE837}`" /f >nul 2>&1"

exit

		  }
		} } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
