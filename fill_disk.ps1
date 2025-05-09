# List directory contents before disk fill
Write-Host "`n[BEFORE] Listing C:\codebuild\reserve:"
Get-ChildItem "C:\codebuild\reserve" -Force

# Print free space BEFORE
$drive = Get-PSDrive -Name C
$freeMBStart = [math]::Round($drive.Free / 1MB)
Write-Host "[BEFORE] Free space on C: = $freeMBStart MB"

# Prepare to fill disk space
$path = "C:\disk_fill.bin"
$buffer = New-Object byte[] 1MB
$i = 0
$stream = [System.IO.File]::Open($path, 'Create', 'Write')

try {
    while ($true) {
        # Re-check free space on every iteration
        $drive = Get-PSDrive -Name C
        $freeMB = [math]::Round($drive.Free / 1MB)

        if ($freeMB -le 10) {
            Write-Host "Stopping fill: only $freeMB MB left on disk."
            break
        }

        try {
            $stream.Write($buffer, 0, $buffer.Length)
            $stream.Flush()
        } catch {
            Write-Host "Write error after writing $i MB: $($_.Exception.Message)"
            break
        }

        $i++
        if ($i % 100 -eq 0) {
            Write-Host "Written $i MB so far... Free space = $freeMB MB"
        }
    }
} finally {
    $stream.Close()
}

Write-Host "Created file at $path with size: $i MB"

# Print free space AFTER
$drive = Get-PSDrive -Name C
$freeMBEnd = [math]::Round($drive.Free / 1MB)
Write-Host "[AFTER] Free space on C: = $freeMBEnd MB"

# List directory contents after disk fill
Write-Host "`n[AFTER] Listing C:\codebuild\reserve:"
Get-ChildItem "C:\codebuild\reserve" -Force
