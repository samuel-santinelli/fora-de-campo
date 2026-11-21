# VAR-01 — caminhada e Decisão Final v1

Atualização: animações integradas ao jogo posteriormente. Ver `INTEGRACAO-ANIMACOES.md` para seleção de estados, escala e testes. O restante deste documento registra a etapa anterior de criação da prévia.

Prévia em `previa-ataques.html`. Criadas pela ferramenta integrada imagegen duas folhas originais, `avanco-v1.png` e `golpe-v1.png`, com oito poses cada. A referência `../../referencias/var-01-v1.png` foi preservada. Esta etapa não altera script de combate nem cena: o jogo ainda usa a pose única da integração funcional.

## Exportação

`preparar-animacoes.ps1` recorta, alinha e redimensiona por vizinho mais próximo; não desenha novos quadros. Exporta folhas 3072×384, células 384×384, dezesseis PNGs individuais, pose parada e metadados. Âncora (192,360); linha de chão comum por fileira. Escala fixa por sequência calculada pela primeira pose pronta com altura alvo 320 px. Reserva espaço para punho levantado sem normalizar cada quadro. A escala de jogo 0,6 registrada é proposta inicial para ficar perto da altura atual de 192 px, não aplicada ainda à cena.

Como as fontes foram geradas separadamente, há pequenas diferenças de proporção entre caminhada/golpe/referência. Conferir altura do monitor e largura do cartão na integração. O cartão permanece retangular e visível durante o golpe; punho toca o chão nos quadros 5 e 6. As imagens exportadas ainda possuem resíduos coloridos em alguns contornos: revisão visual pendente, sem afirmar que a arte está limpa.

## Ritmo

Caminhada: 140,120,110,120,140,120,110,120 ms (980 ms). Golpe: 150,150,150,150,100,120,200,180 ms (1200 ms). Primeiro impacto no início do quadro 5, exatamente aos 600 ms, alinhado ao início da onda existente no Godot. Quadros 1–4 preparam, 5–6 fazem impacto/sustentação, 7–8 retornam. Na futura integração, sincronizar recuperação do sprite com o estado de onda de 450 ms sem repetir a preparação nem causar outro dano.

Prévia completa: caminhada 1200 ms, golpe 1200 ms, pausa 900 ms. Onda desenhada separada e apenas ilustrativa entre 600 e 1050 ms do golpe. Não simula colisões e não substitui os parâmetros do jogo. Modo exclusivo de golpe repete o ciclo para inspeção. Inclui pausa, quadro a quadro, seletor, reinício, ritmo, espelhamento e efeitos opcionais; referência ao lado.

## Verificação

Exportação executada com validação de fundo nos cantos (tolerância alpha 2/255) e limites de células. Quadro de impacto inspecionado como imagem. DOM/canvas simulados confirmaram dimensões, dezesseis PNGs, controles, pausa, recuperação e transição para quadro de impacto aos 600 ms. Não houve conferência em navegador real. Nenhuma regressão de gameplay executada porque esta etapa apenas adiciona arte e prévia; integração funcional anterior permanece descrita em INTEGRACAO.md.

## Próxima etapa

Após conferir a prévia, substituir pose por caminhada quando houver deslocamento, preparação do golpe durante estado GOLPE e impacto/retorno durante ONDA/RECUPERACAO. Manter CARGA/LASER/ATORDOADO com referência e efeitos existentes até criar animações específicas, se necessário. Preservar o momento do impacto, colisão, contra-ataque e portão; não redimensionar corpo pelo quadro do punho levantado.

## Prompts — ferramenta integrada imagegen

### Caminhada

Use case: identity-preserve. Eight-frame heavy WALK sprite sheet for exact original VAR-01 robot in reference. Preserve monitor head red digital eye, huge flat upright RED CARD torso framed thin gold, black/gunmetal articulated arms with big fists, mechanical football boots, small cameras and antennas behind shoulders. Card remains unmistakable large red rectangle in every pose. EXACT FOUR EQUAL COLUMNS TWO EQUAL ROWS on landscape1536x1024, one complete robot per384x512 cell, same physical size, body center near x192, feet baseline near y480, head near y80, safe margins all sides. All poses face LEFT at consistent three-quarter side angle showing red card front, no camera rotation. Eight distinct sequential heavy measured walking poses, alternating left/right contact, knee compression, passing, short lift, then opposite contact, realistic mechanical weight. Small free-arm swing, cameras slight secondary tilt, rigid card does not bend or change proportions. Each pose 2 arms 2 legs 1 monitor, no duplicates. Crisp detailed PIXEL ART, discrete clusters, dark outlines, coherent metal shading same as reference; not 3D or smooth painting. TRUE ALPHA TRANSPARENT background outside all figures, no floor/shadow/haze/glow/gradient/color matte or red fringe, no effects/projectiles, no text/labels/grid/watermark. Keep antennas, hands and boots fully within their own cells, never overlap adjacent sprites.

### Decisão Final

Use case: identity-preserve. Production EIGHT-frame GROUND PUNCH animation of the EXACT VAR-01 robot in reference. Preserve monitor head red digital eye, large rigid red referee CARD torso with thin gold frame, black/grey arms with oversized fists, metallic football boots, back cameras/antennas. EXACT FOUR EQUAL COLUMNS and TWO EQUAL ROWS landscape1536x1024, each cell384x512 one full robot facing LEFT in stable three-quarter side view showing card front. Same body scale throughout, hip center near x205, boot baseline y480, ready pose head near y85, ample overhead space for raised fist. Frame1 SAME ready standing proportions as reference with knees soft. Frame2 forward LEFT fist retracts,3 same fist rises above monitor with knees bracing,4 highest raised-fist anticipation held,5 LEFT fist hits ground IN FRONT of LEFT boot (to left of body) as knees bend and torso leans,6 holds fist on ground with compressed knees,7 lifts fist and straightens,8 returns to ready similar1. Keep fist entirely inside own cell, clear distinct positions, two arms/two legs only, don't swap punching arm, no extending/stretching arms. Red card is rigid even when torso rotates subtly, remains clear rectangular red shape in every pose. Full head,fists,boots,cameras inside cells, no cropped raised hand. Detailed crisp pixel art, discrete clusters/dark contour, metal shading consistent with reference, no photoreal/3D/chibi. TRUE transparent alpha0 background outside character. NO floor, cracks,dust,shockwave,laser,glow,haze,gradient,shadow,labels,grid,watermark or extra figures. Effects will be separate in engine. Eight sequential frames row-major order, no text.
