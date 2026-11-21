$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$pasta = Join-Path $PSScriptRoot 'divulgacao-v1'
$imagens = @(Get-ChildItem -LiteralPath $pasta -Filter '*.png' -File)
if ($imagens.Count -ne 19) { throw 'Esperadas 19 imagens PNG.' }
$destino = Join-Path $PSScriptRoot 'ForaDeCampo-Prints-HD.zip'
$fluxo = [System.IO.File]::Open($destino, [System.IO.FileMode]::Create)
$zip = [System.IO.Compression.ZipArchive]::new($fluxo, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    foreach ($arquivo in Get-ChildItem -LiteralPath $pasta -File) {
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $arquivo.FullName, $arquivo.Name, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
    }
} finally { $zip.Dispose(); $fluxo.Dispose() }
Write-Output ('Prints prontos: ' + $destino)
