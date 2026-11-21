param(
    [string]$Godot = 'C:/Users/samue/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe'
)
$ErrorActionPreference = 'Stop'
$raizProjeto = Split-Path $PSScriptRoot -Parent
if (-not (Test-Path -LiteralPath $Godot -PathType Leaf)) { throw 'Informe o caminho do executável console do Godot em -Godot.' }
$modelos = Join-Path $raizProjeto '.godot/modelos-exportacao/4.7.2.stable'
foreach ($nome in @('web_nothreads_debug.zip', 'web_nothreads_release.zip', 'windows_debug_x86_64.exe', 'windows_release_x86_64.exe')) {
    if (-not (Test-Path -LiteralPath (Join-Path $modelos $nome) -PathType Leaf)) {
        throw "Modelo ausente: $nome. Consulte entrega/MODELOS-EXPORTACAO.md."
    }
}
Add-Type -AssemblyName System.IO.Compression.FileSystem
Push-Location -LiteralPath $raizProjeto
try {
    $versao = (& $Godot --version | Out-String).Trim()
    if ($versao -notlike '4.7.2.stable*') { throw "Os modelos locais são da versão 4.7.2.stable; executável informado: $versao." }
    & node (Join-Path $PSScriptRoot 'preparar-recursos.cjs')
    if ($LASTEXITCODE -ne 0) { throw 'Falha ao preparar dependencias do jogo.' }
    New-Item -ItemType Directory -Path (Join-Path $raizProjeto 'builds') -Force | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $raizProjeto 'builds/.gdignore'), '')
    foreach ($alvo in @('Web', 'Windows')) {
        $pasta = Join-Path $raizProjeto ('builds/' + $alvo)
        New-Item -ItemType Directory -Path $pasta -Force | Out-Null
        $arquivo = if ($alvo -eq 'Web') { Join-Path $pasta 'index.html' } else { Join-Path $pasta 'ForaDeCampo.exe' }
        $log = Join-Path $raizProjeto ('verificacoes/exportacao-' + $alvo.ToLowerInvariant() + '-atual.log')
        & $Godot --headless --quiet --path $raizProjeto --log-file $log --export-release $alvo $arquivo
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $arquivo)) {
            throw "Exportação $alvo falhou. Verifique os modelos correspondentes à versão do Godot e o log acima. Nenhum ZIP será criado por esta execução."
        }
        $obrigatorios = if ($alvo -eq 'Web') { @('index.html', 'index.js', 'index.wasm', 'index.pck') } else { @('ForaDeCampo.exe', 'ForaDeCampo.pck') }
        foreach ($nome in $obrigatorios) {
            $caminho = Join-Path $pasta $nome
            if (-not (Test-Path -LiteralPath $caminho -PathType Leaf) -or (Get-Item -LiteralPath $caminho).Length -eq 0) {
                throw "A exportação $alvo não produziu o arquivo obrigatório: $nome."
            }
        }
    }
    # Nao publicar ZIP de uma build que apenas existe mas nao consegue iniciar.
    $logBoot = Join-Path $raizProjeto 'verificacoes/boot-windows-atual.log'
    $executavel = Join-Path $raizProjeto 'builds/Windows/ForaDeCampo.exe'
    $processo = Start-Process -FilePath $executavel -WorkingDirectory (Split-Path $executavel -Parent) -ArgumentList @('--headless', '--quit-after', '60', '--log-file', ('"' + $logBoot + '"')) -WindowStyle Hidden -Wait -PassThru
    if ($processo.ExitCode -ne 0) { throw "A build Windows nao iniciou corretamente: $($processo.ExitCode)." }
    $textoBoot = Get-Content -LiteralPath $logBoot -Raw
    if ($textoBoot -match 'SCRIPT ERROR|Failed to load script|Failed loading resource|Parse Error|does not exist') {
        throw "A build Windows apresenta erro de recurso ou script. Veja $logBoot."
    }
    $logCenas = Join-Path $raizProjeto 'verificacoes/cenas-pacote-atual.log'
    $testeCenas = Join-Path $raizProjeto 'verificacoes/verificar_cenas_pacote.gd'
    & $Godot --headless --path (Split-Path $executavel -Parent) --main-pack (Join-Path $raizProjeto 'builds/Windows/ForaDeCampo.pck') --script $testeCenas --log-file $logCenas --quit-after 1000
    $textoCenas = Get-Content -LiteralPath $logCenas -Raw -Encoding UTF8
    if ($LASTEXITCODE -ne 0 -or $textoCenas -notmatch 'pacote exportado: 0 falhas' -or $textoCenas -match 'SCRIPT ERROR|Failed to load script|Failed loading resource|Parse Error|does not exist') {
        throw "Falha na verificacao das cinco cenas do pacote. Veja $logCenas."
    }
    # Só compactar após as duas exportações concluírem com sucesso.
    $pacotes = @()
    foreach ($alvo in @('Web', 'Windows')) {
        $pasta = Join-Path $raizProjeto ('builds/' + $alvo)
        $zip = Join-Path $PSScriptRoot ('ForaDeCampo-' + $alvo + '.zip')
        $arquivosPacote = @(Get-ChildItem -LiteralPath $pasta -File | Where-Object { $_.Extension -ne '.import' } | Select-Object -ExpandProperty FullName)
        Compress-Archive -LiteralPath $arquivosPacote -DestinationPath $zip -Force
        $leitura = [System.IO.Compression.ZipFile]::OpenRead($zip)
        try {
            $entradas = @($leitura.Entries | ForEach-Object { $_.FullName.Replace('\', '/') })
            $raizObrigatoria = if ($alvo -eq 'Web') { 'index.html' } else { 'ForaDeCampo.exe' }
            if ($entradas -notcontains $raizObrigatoria) { throw "ZIP $alvo inválido: $raizObrigatoria deve ficar na raiz." }
        } finally { $leitura.Dispose() }
        $pacotes += [pscustomobject]@{
            plataforma = $alvo
            arquivo = Split-Path $zip -Leaf
            bytes = (Get-Item -LiteralPath $zip).Length
            sha256 = (Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash.ToLowerInvariant()
            conteudo = $entradas
        }
        Write-Output "Pacote gerado: $zip"
    }
    [pscustomobject]@{ godot = $versao; pacotes = $pacotes } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'pacotes.json') -Encoding UTF8
} finally {
    Pop-Location
}
