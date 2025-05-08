# disk_fill.ps1

# List directory contents before disk fill
Write-Host "`n[BEFORE] Listing C:\codebuild\reserve:"
Get-ChildItem "C:\codebuild\reserve" -Force

# Print free space BEFORE
$drive = Get-PSDrive -Name C
$freeGBBefore = [math]::Round($drive.Free / 1GB)
Write-Host "[BEFORE] Free space on C: = $freeGBBefore GB"

# Prepare to fill disk space
$path = "C:\disk_fill.bin"
$buffer = New-Object byte[] 1MB
$i = 0

$stream = [System.IO.File]::Open($path, 'Create', 'Write')
try {
    while ($true) {
        try {
            $stream.Write($buffer, 0, $buffer.Length)
            $stream.Flush()
        } catch {
            Write-Host "Disk full after writing $i MB."
            break
        }
        $i++
        if ($i % 100 -eq 0) {
            Write-Host "Written $i MB so far..."
        }
    }
} finally {
    $stream.Close()
}
Write-Host "Created file at $path with size: $i MB"

# Print free space AFTER
$drive = Get-PSDrive -Name C
$freeGBAfter = [math]::Round($drive.Free / 1GB)
Write-Host "[AFTER] Free space on C: = $freeGBAfter GB"

# List directory contents after disk fill
Write-Host "`n[AFTER] Listing C:\codebuild\reserve:"
Get-ChildItem "C:\codebuild\reserve" -Force
