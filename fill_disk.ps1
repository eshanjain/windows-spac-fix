# fill_disk.ps1
$path = "C:\disk_fill.bin"
$size = 1GB
$buffer = New-Object byte[] 1MB
$stream = [System.IO.File]::OpenWrite($path)
for ($i = 0; $i -lt ($size / 1MB); $i++) {
    $stream.Write($buffer, 0, $buffer.Length)
}
$stream.Close()
Write-Host "Created 1GB file at $path"
