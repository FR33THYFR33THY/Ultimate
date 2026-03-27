. $CommonScript

Ensure-Admin

        Write-Host "1. Memory Compression: Off (Recommended)"
        Write-Host "2. Memory Compression: Enable`n"
        while ($true) {
        $choice = Read-Host " "
        if ($choice -match '^[1-2]$') {
        switch ($choice) {
        1 {

Clear-Host

Write-Host "Memory Compression: Off...`n"

# disable memory compression
Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue | Out-Null

# show mmagent
get-mmagent

Pause

exit

          }
        2 {

Clear-Host

Write-Host "Memory Compression: Enable...`n"

# enable memory compression
Enable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue | Out-Null

# show mmagent
get-mmagent

Pause

exit

          }
        } } else { Write-Host "Invalid input. Please select a valid option (1-2)." } }
