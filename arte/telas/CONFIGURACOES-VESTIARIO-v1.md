# Configurações — vestiário e painel compacto

Atualização posterior: controles gerais de áudio e tela em duas abas, descritos em `CONFIGURACOES-GERAIS.md`. A largura e composição do vestiário foram preservadas; altura do painel ajustada aos novos controles.

Solicitação: acrescentar Cristiano amarrando chuteira no vestiário, reduzir modal e corrigir controle/ajuda visual. Arte opaca `configuracoes-vestiario-v1.png` criada com imagegen integrado e capa inicial como referência. 1672 × 941; inspecionada na saída do gerador e salva no projeto. Cristiano sentado à direita, Portugal 7, armadura dourada, capa no banco, amarrando a chuteira. Lado esquerdo preservado para UI.

Integrada diretamente em `script_configuracoes.gd`. Painel agora 440 × 340 unidades, escala máxima 1,15 (antes 560 × 420, máxima 1,4), à esquerda em vez de centralizado. Arte proporcional sem escurecimento global; só o painel é escuro. Textos menores e espaços fixos entre título, interruptor, ajuda e estado. Controles existentes, música e callbacks preservados.

Não havia tooltip configurada na cena/script anterior. Foram tratados os elementos possivelmente associados ao relato: ícones padrão do CheckButton substituídos por SVGs de interface em `ui/silenciar-ativo.svg` e `ui/silenciar-inativo.svg`, tamanhos constantes 52 × 28; cores de texto definidas para foco/hover/pressionado, fundo próprio do controle e ajuda fixa abaixo dele. Tooltips dos botões explicitamente vazias e Labels ignoram mouse, para não sobrepor popup ou interceptar cliques. Não afirmar que uma causa específica de tooltip foi reproduzida em janela.

A linha diz Silenciar áudio; interruptor ativo significa mudo e o estado escrito confirma Áudio silenciado. Continua atuando no Master e preserva preferência durante a sessão; não adiciona salvamento em disco ou controles independentes de canais.

## Verificação

Três verificações headless com zero falhas: configurações, auditoria das telas e menu inicial. Teste de configurações ampliado para conferir arte correta, ícone próprio, ausência de tooltip flutuante, ajuda fora do interruptor e todos os controles dentro do painel compacto em três tamanhos de janela, além de mute/unmute e retorno/reabertura. Logs `verificacoes/vestiario-*.log`.

Não houve inspeção em janela real ou audição. Conferir visual em Configurações pelo menu ou F6 em `cena_configuracoes.tscn`. Mensagens ambientais de certificados e recursos em uso ao encerrar continuam presentes.

## Prompt — imagegen integrado

Use case: stylized-concept. NEW background for SETTINGS screen of FORA DE CAMPO detailed pixel-art football game. Approved supplied title image is exact character/style reference, preserve recognizable Cristiano Ronaldo face, swept dark hair, red Portugal7 shirt, green shorts, red socks, light GOLD shoulder/forearm/shin armor, gold football boots, red gold-trimmed cape. Wide opaque1672x941 or16:9. Scene: private football stadium LOCKER ROOM before match. RIGHT half Cristiano seated naturally on a wooden bench, fully clothed in approved football outfit/armor, leaning forward tying the laces of one GOLD FOOTBALL BOOT resting on the floor, both hands on laces, head angled down in concentration, focused preparation rather than heroic pose, all body/boots/cape in frame. Cape neatly folded/draped behind him on bench, not on left. Background navy/slate lockers, muted wood bench, warm practical overhead lamps, small kit bag and football near right bench. Dry matte tiles, restrained bronze hardware, same crisp detailed pixel clusters, coherent outlines, limited shading as approved artwork. LEFT45percent calm darker navy locker surfaces mostly uncluttered for smaller settings panel, no character details there. Lighting subtle warm gold edges and cool navy shadows, no glamorous posing, no overlit muscles. No shirtless body, shower, underwear, other people, trophy, stadium crowd or glowing magic. NO text, labels, jersey names on lockers, numbers EXCEPT7 on character kit, UI, buttons, logos,watermark. Do not render menu into image. Detailed pixel art, not photorealism,3D or smooth painting. Readable welcoming calm preparation moment.
