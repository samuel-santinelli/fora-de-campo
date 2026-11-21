# Quadra de treino e rua da arbitragem — referências v1

Atualização: primeira integração ao jogo concluída em `INTEGRACAO-INICIO.md`, sem alterar as fontes. O texto abaixo registra a criação das referências anterior à montagem na fase.

Arquivos gerados pela ferramenta integrada imagegen: `quadra-treino-v1.png` e `rua-arbitragem-v1.png`, ambos 1672×941, fundos opacos completos. Imagens inspecionadas na saída do gerador. Rua usa quadra como referência de estilo, paleta e altura do chão. Prévia em `previa-ambientes.html`; ainda não aplicadas à cena.

## Direção

Quadra (trecho inicial/Muralha): alambrado, trave ao fundo, pequena arquibancada, bancos, grama, concreto gasto e estádio distante à direita. Rua (Sentença): barreiras de organização ao fundo, muros, placas sem texto e cabine com magenta discreto. Mesma luz de entardecer azul com pontos âmbar e chão horizontal claro, passagem desobstruída na frente. Evitar tratar objetos do fundo como plataformas ou colisões.

As duas referências compartilham árvores/edificações/estádio para estabelecer continuidade. Não são painéis com bordas comprovadamente contínuas nem texturas seamless; a repetição literal evidenciaria o mesmo estádio/árvore. Preparar transição e módulos antes de usar no mapa ampliado. Não esticar cada imagem para cobrir 8050 px.

## Prévia e validação

A prévia alterna ambientes e sobrepõe a referência de Cristiano e os primeiros quadros exportados de Muralha/Sentença, com opção de esconder personagens e linha de apoio. A escala é ilustrativa, não medição definitiva de proporção no jogo. Linha y450 na prévia de 1040×585 aproxima o topo do chão das referências. As poses, fundos e arquivos anteriores foram preservados.

DOM/canvas simulados verificaram existência dos cinco assets usados, troca de fundo, personagens e guia. Não houve inspeção em navegador real. Gameplay não foi modificado e não foram repetidos testes do Godot nesta etapa.

## Próxima adaptação ao mapa

Separar fundo da faixa de terreno, produzir peças reutilizáveis de chão/plataforma e transição, e alinhar à geometria descrita em PERCURSO.md. A escada perto de x2320 e a plataforma de Haaland não aparecem nestas referências planas: continuar usando terreno alinhado às colisões até ter peças adequadas. As demais zonas também ainda precisam de arte. Preservar câmera, distâncias dos encontros e colisões validadas.

Manter contraste de aviso dos cartões, bola dourada, uniforme verde do goleiro e magenta do árbitro. Na integração, avaliar em jogo o tamanho dos pixels, legibilidade do alambrado e custo das camadas/texturas; não foi feita medição de desempenho em web.

## Prompts — ferramenta integrada imagegen

### Quadra

Use case: stylized-concept. Environment concept reference for existing detailed PIXEL ART 2D SIDE-SCROLLING football platformer FORA DE CAMPO. First continuous zone: outdoor TRAINING COURT before stadium, home to a jumping goalkeeper. Landscape wide game-screen composition, ideally1536x864. Strict orthographic SIDE VIEW with horizontal walkable foreground at about82% image height, NOT isometric, top-down, cinematic perspective or tilted camera. Empty scene, NO characters, enemies, balls, text, HUD or labels. Detailed crisp pixel clusters, dark coherent outlines and limited shaded palette matching armored footballer sprites. Blue-hour dusk sky, muted deep blue/teal low-rise urban silhouettes and distant stadium roof toward RIGHT, small warm amber streetlights in background. Midground chain-link sports fence, a small football goal set BACK BEHIND play area, modest low bleachers, benches and training cones BEHIND fence; recognizable neighborhood football practice grounds. Restrained weathered concrete walls and patches of grass, no excessive clutter. Foreground: clear continuous FLAT SIDE-VIEW concrete court edge with readable light top rim and darker soil/brick cross-section beneath. Keep foreground walking strip unobstructed from LEFT to RIGHT, no fences/goals/props crossing playable lane, no decorative platforms that look solid but are not. Lower contrast and fewer details at player-height band, brighter highlight only at actual floor top, subdued background so red/gold/teal characters and yellow/red projectiles stand out. Right edge suggests exit into nearby city access road, same ground height, no hard gate blocking passage. Opaque complete background, not transparent. No logos, readable lettering, watermark, lens blur, photorealism, 3D, gradient airbrush or foreground fog. This is an ART DIRECTION reference, not a tile atlas or final collision map.

### Rua

Use case: stylized-concept. NEW adjacent environment concept for same detailed pixel-art 2D SIDE-SCROLLING football platformer FORA DE CAMPO. Supplied court image is STYLE, PALETTE, GROUND HEIGHT and BLUE-HOUR LIGHT reference. Create NEXT zone: URBAN ACCESS STREET supervised by referee Sentenca, leading toward football stadium. Match image composition wide landscape ideally1536x864, crisp discrete pixel clusters, dark contours and limited shaded colors. Strict orthographic SIDE VIEW for foreground horizontal path, no isometric/top-down camera. Foreground continuous flat sidewalk/platform edge at SAME relative height as supplied reference (about77% image height), light worn concrete top rim, darker masonry cutaway beneath, unobstructed LEFT to RIGHT. Midground BEHIND walking lane: waist-high metal crowd-control barriers, concrete planters, modest brick walls, blank sign boards on posts (NO text), small inspection booth with muted magenta trim as subtle referee identity, amber streetlamps. All barriers/booth behind lane, not blocking playable foreground or creating fake platforms. Urban low-rise facades and stadium structure in RIGHT distance under same blue-hour dusk sky, distant windows warm amber, not neon cyberpunk. Referee setting suggested by organized access barriers, not military checkpoint or police. Keep colors mostly muted blue/grey, restrained magenta details, sparse grass along back edge. Lower contrast and restrained texture at character height so magenta referee, gold player and yellow/red cards remain visible. No characters, enemies, vehicles crossing lane, balls, HUD, labels, readable text, logos, watermark. No glow fog, photo,3D,smooth painted gradients. Opaque complete background. This is an art direction concept for one continuous level, not a tile atlas, not seven maps and not a collision implementation.
