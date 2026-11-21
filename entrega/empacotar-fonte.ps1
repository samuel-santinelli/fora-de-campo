$ErrorActionPreference = 'Stop'
$raiz = Split-Path $PSScriptRoot -Parent
& node (Join-Path $PSScriptRoot 'preparar-fonte.cjs')
if ($LASTEXITCODE -ne 0) { throw 'Falha ao selecionar dependencias do fonte.' }
$manifesto = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'fonte-manifesto.json') -Raw | ConvertFrom-Json
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$destino = Join-Path $PSScriptRoot 'ForaDeCampo-CodigoFonte.zip'
$fluxo = [System.IO.File]::Open($destino, [System.IO.FileMode]::Create)
$zip = [System.IO.Compression.ZipArchive]::new($fluxo, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    foreach ($relativo in $manifesto.arquivos) {
        $origem = [System.IO.Path]::GetFullPath((Join-Path $raiz $relativo))
        if (-not $origem.StartsWith($raiz + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) { throw 'Caminho fora do projeto.' }
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $origem, ('ForaDeCampo/' + $relativo.Replace('\','/')), [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
    }
} finally { $zip.Dispose(); $fluxo.Dispose() }
$arquivo = Get-Item -LiteralPath $destino
$hash = Get-FileHash -LiteralPath $destino -Algorithm SHA256
@{ arquivo=$arquivo.Name; bytes=$arquivo.Length; sha256=$hash.Hash; quantidade=$manifesto.quantidade } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'fonte-pacote.json') -Encoding UTF8
Write-Output ('Fonte pronto: ' + $destino)
