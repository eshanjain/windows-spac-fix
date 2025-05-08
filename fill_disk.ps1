# disk_fill.ps1

Get-ChildItem -Path "C:\codebuild\reverse" -Force -File | 
  Where-Object { $_.Attributes -match "Hidden" } |
  Select-Object Name, @{Name="SizeMB";Expression={[math]::Round($_.Length / 1MB, 2)}}

# Print free space BEFORE
$drive = Get-PSDrive -Name C
$freeMBBefore = [math]::Round($drive.Free / 1MB)
Write-Host "[BEFORE] Free space on C: = $freeMBBefore MB"

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
$freeMBAfter = [math]::Round($drive.Free / 1MB)
Write-Host "[AFTER] Free space on C: = $freeMBAfter MB"

Get-ChildItem -Path "C:\codebuild\reverse" -Force -File | 
  Where-Object { $_.Attributes -match "Hidden" } |
  Select-Object Name, @{Name="SizeMB";Expression={[math]::Round($_.Length / 1MB, 2)}}
