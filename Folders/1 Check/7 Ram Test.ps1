. $CommonScript

Ensure-Admin
Testing-Connection

# SCRIPT SILENT
$progresspreference = 'silentlycontinue'

Write-Host "Downloading: TM5..."

# download tm5
$result = Get-FileFromWeb -URL "https://github.com/FR33THYFR33THY/files/raw/main/TM5.zip" -File "$env:SystemRoot\Temp\TM5.zip"

# extract files
Expand-Archive "$env:SystemRoot\Temp\TM5.zip" -DestinationPath "$env:SystemRoot\Temp\TM5" -ErrorAction SilentlyContinue

# create config for tm5
$Tm5Config = @'
Memory Test config file v0.02
Copyrights to the program belong to me.
Serj
testmem.tz.ru
serj_m@hotmail.com

[Main Section]
Config Name=ABSOLUT(01102021)
Config Author=anta777
Cores=0
Tests=16
Time (%)=1250
Cycles=3
Language=0
Test Sequence=1,4,6,15,3,2,7,15,5,2,8,15,4,2,9,15,3,2,10,15,5,2,11,15,4,2,12,15,5,14,15

[Global Memory Setup]
Channels=2
Interleave Type=1
Single DIMM width, bits=64
Operation Block, byts=64
Testing Window Size (Mb)=1536
Lock Memory Granularity (Mb)=64
Reserved Memory for Windows (Mb)=512
Capable=0x0
Debug Level=7

[Window Position]
WindowPosX=400
WindowPosY=400

[Test0]
Enable=1
Time (%)=8
Function=RefreshStable
DLL Name=bin\MT0.dll
Pattern Mode=0
Pattern Param0=0x0
Pattern Param1=0x0
Parameter=0
Test Block Size (Mb)=0

[Test1]
Enable=1
Time (%)=240
Function=SimpleTest
DLL Name=bin\MT0.dll
Pattern Mode=2
Pattern Param0=0x77777777
Pattern Param1=0x33333333
Parameter=0
Test Block Size (Mb)=4

[Test2]
Enable=1
Time (%)=8
Function=SimpleTest
DLL Name=bin\MT0.dll
Pattern Mode=1
Pattern Param0=0
Pattern Param1=0
Parameter=0
Test Block Size (Mb)=0

[Test3]
Enable=1
Time (%)=20
Function=MirrorMove128
DLL Name=bin\MT0.dll
Pattern Mode=0
Pattern Param0=0x0
Pattern Param1=0x0
Parameter=2
Test Block Size (Mb)=0

[Test4]
Enable=1
Time (%)=20
Function=MirrorMove
DLL Name=bin\MT0.dll
Pattern Mode=0
Pattern Param0=0x0
Pattern Param1=0x0
Parameter=4
Test Block Size (Mb)=0

[Test5]
Enable=1
Time (%)=20
Function=MirrorMove128
DLL Name=bin\MT0.dll
Pattern Mode=0
Pattern Param0=0x0
Pattern Param1=0x0
Parameter=1
Test Block Size (Mb)=0

[Test6]
Enable=1
Time (%)=240
Function=SimpleTest
DLL Name=bin\MT0.dll
Pattern Mode=0
Pattern Param0=0x0
Pattern Param1=0x0
Parameter=0
Test Block Size (Mb)=4

[Test7]
Enable=1
Time (%)=120
Function=SimpleTest
DLL Name=bin\MT0.dll
Pattern Mode=0
Pattern Param0=0x0
Pattern Param1=0x0
Parameter=0
Test Block Size (Mb)=8

[Test8]
Enable=1
Time (%)=60
Function=SimpleTest
DLL Name=bin\MT0.dll
Pattern Mode=0
Pattern Param0=0x0
Pattern Param1=0x0
Parameter=0
Test Block Size (Mb)=16

[Test9]
Enable=1
Time (%)=30
Function=SimpleTest
DLL Name=bin\MT0.dll
Pattern Mode=0
Pattern Param0=0x0
Pattern Param1=0x0
Parameter=0
Test Block Size (Mb)=32

[Test10]
Enable=1
Time (%)=16
Function=SimpleTest
DLL Name=bin\MT0.dll
Pattern Mode=0
Pattern Param0=0x0
Pattern Param1=0x0
Parameter=0
Test Block Size (Mb)=64

[Test11]
Enable=1
Time (%)=8
Function=SimpleTest
DLL Name=bin\MT0.dll
Pattern Mode=0
Pattern Param0=0x0
Pattern Param1=0x0
Parameter=0
Test Block Size (Mb)=128

[Test12]
Enable=1
Time (%)=8
Function=SimpleTest
DLL Name=bin\MT0.dll
Pattern Mode=0
Pattern Param0=0x0
Pattern Param1=0x0
Parameter=0
Test Block Size (Mb)=256

[Test13]
Enable=1
Time (%)=8
Function=SimpleTest
DLL Name=bin\MT0.dll
Pattern Mode=0
Pattern Param0=0x0
Pattern Param1=0x0
Parameter=0
Test Block Size (Mb)=512

[Test14]
Enable=1
Time (%)=8
Function=SimpleTest
DLL Name=bin\MT0.dll
Pattern Mode=0
Pattern Param0=0x0
Pattern Param1=0x0
Parameter=0
Test Block Size (Mb)=0

[Test15]
Enable=1
Time (%)=8
Function=SimpleTest
DLL Name=bin\MT0.dll
Pattern Mode=0
Pattern Param0=0x0
Pattern Param1=0x0
Parameter=256
Test Block Size (Mb)=0
'@
Set-Content -Path "$env:SystemRoot\Temp\TM5\bin\MT.cfg" -Value $Tm5Config -Force

# set config to read only
Set-ItemProperty -Path "$env:SystemRoot\Temp\TM5\bin\MT.cfg" -Name IsReadOnly -Value $true

# start tm5
Start-Process "$env:SystemRoot\Temp\TM5\TM5.exe"

Clear-Host
Write-Host "Run a basic RAM stress test to check for errors"
Write-Host "Check temps and WHEA errors in Hw Info during this test"
Write-Host "TM5 will run three cycles`n"
Write-Host "CPU and RAM errors should not be ignored as they can lead to:"
Write-Host "- Corrupted Windows"
Write-Host "- Corrupted files"
Write-Host "- Stutters and hitches"
Write-Host "- Poor performance"
Write-Host "- Input lag"
Write-Host "- Shutdowns"
Write-Host "- Blue screens`n"
Write-Host "Basic troubleshooting for errors or issues running XMP DOCP EXPO:"
Write-Host "- BIOS out of date? (update)"
Write-Host "- BIOS bugged out? (clear CMOS)"
Write-Host "- Incompatible RAM? (check QVL)"
Write-Host "- Mismatched RAM? (replace)"
Write-Host "- RAM in wrong slots? (check manual)"
Write-Host "- Unlucky CPU memory controller? (lower RAM speed)"
Write-Host "- Overclock? (turn it off/dial it down)"
Write-Host "- CPU cooler overtightened? (loosen)"
Write-Host "- CPU overheating? (repaste/retighten/RMA cooler)"
Write-Host "- RAM overheating? Typically over 55deg. (fix case flow/ram fan)"
Write-Host "- Faulty RAM stick? (RMA)"
Write-Host "- Faulty motherboard? (RMA)"
Write-Host "- Faulty CPU? (RMA)"
Write-Host "- Bent CPU pin? (RMA)`n"

Pause
