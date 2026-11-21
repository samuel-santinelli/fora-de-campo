param([string]$Godot = 'C:/Users/samue/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe')
$ErrorActionPreference = 'Stop'
$raiz = Split-Path $PSScriptRoot -Parent
$pacote = Join-Path $raiz 'builds/Windows/ForaDeCampo.pck'
$script = Join-Path $raiz 'verificacoes/capturar_divulgacao.gd'
# Novas capturas brutas nao sobrescrevem as pecas promocionais aprovadas.
$destino = Join-Path $PSScriptRoot 'capturas-renderizadas'
$log = Join-Path $raiz 'verificacoes/capturas-divulgacao.log'
if (-not (Test-Path -LiteralPath $pacote)) { throw 'Exporte a versao Windows antes de capturar.' }
$argumentos = @('--main-pack',('"'+$pacote+'"'),'--script',('"'+$script+'"'),'--rendering-method','gl_compatibility','--fixed-fps','60','--log-file',('"'+$log+'"'),'--quit-after','2500','--','--destino',('"'+$destino+'"'))
$p = Start-Process -FilePath $Godot -ArgumentList $argumentos -WorkingDirectory (Split-Path $pacote -Parent) -WindowStyle Hidden -PassThru -Wait
$texto = Get-Content -LiteralPath $log -Raw -Encoding UTF8
if ($p.ExitCode -ne 0 -or $texto -match 'SCRIPT ERROR|Parse Error|Failed loading resource|captura de divulga' -or $texto -notmatch 'Capturas da entrega conclu') { throw ('Falha nas capturas. Confira ' + $log) }
$quantidade = ([regex]::Matches($texto, 'Captura salva:')).Count
if ($quantidade -ne 19) { throw ('Esperadas 19 capturas, recebidas ' + $quantidade) }
Write-Output ('19 capturas concluidas em ' + $destino)
