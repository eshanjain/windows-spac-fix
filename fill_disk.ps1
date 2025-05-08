# disk_fill.ps1

# Print free space BEFORE
$drive = Get-PSDrive -Name C
$freeMBBefore = [math]::Round($drive.Free / 1MB)
Write-Host "[BEFORE] Free space on C: = $freeMBBefore MB"

# Create 1GB file
$path = "C:\disk_fill.bin"
$size = 1GB
$buffer = New-Object byte[] 1MB
$stream = [System.IO.File]::OpenWrite($path)
for ($i = 0; $i -lt ($size / 1MB); $i++) {
    $stream.Write($buffer, 0, $buffer.Length)
}
$stream.Close()
Write-Host "Created 1GB file at $path"

# Print free space AFTER
$drive = Get-PSDrive -Name C
$freeMBAfter = [math]::Round($drive.Free / 1MB)
Write-Host "[AFTER] Free space on C: = $freeMBAfter MB"
