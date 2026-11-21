param([string]$Pacote = '')
$ErrorActionPreference = 'Stop'
$raizProjeto = Split-Path $PSScriptRoot -Parent
if ([string]::IsNullOrWhiteSpace($Pacote)) {
    $Pacote = Join-Path $raizProjeto '.godot/modelos-exportacao/Godot_v4.7.2-stable_export_templates.tpz'
}
if (-not (Test-Path -LiteralPath $Pacote -PathType Leaf)) { throw 'Pacote TPZ oficial ainda nao foi baixado.' }
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($Pacote)
try {
    $versaoEntrada = $zip.GetEntry('templates/version.txt')
    if ($null -eq $versaoEntrada) { throw 'Pacote invalido: templates/version.txt ausente.' }
    $leitor = New-Object System.IO.StreamReader($versaoEntrada.Open())
    try { $versao = $leitor.ReadToEnd().Trim() } finally { $leitor.Dispose() }
    if ($versao -ne '4.7.2.stable') { throw "Versao incorreta no pacote: $versao." }
    $nomes = @('web_nothreads_debug.zip', 'web_nothreads_release.zip', 'windows_debug_x86_64.exe', 'windows_release_x86_64.exe')
    foreach ($nome in $nomes) {
        if ($null -eq $zip.GetEntry('templates/' + $nome)) { throw "Pacote incompleto: $nome ausente." }
    }
    $destino = Join-Path $raizProjeto '.godot/modelos-exportacao/4.7.2.stable'
    New-Item -ItemType Directory -Path $destino -Force | Out-Null
    foreach ($nome in ($nomes + @('version.txt', 'icudt_godot.dat'))) {
        $entrada = $zip.GetEntry('templates/' + $nome)
        if ($null -ne $entrada) {
            [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entrada, (Join-Path $destino $nome), $true)
            Write-Output "Modelo preparado: $nome"
        }
    }
} finally { $zip.Dispose() }
Write-Output 'Modelos locais preparados. Execute entrega/exportar.ps1.'
