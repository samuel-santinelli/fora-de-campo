# Mbappé — corrida e arrancada v1

Gerado pela ferramenta integrada de imagens a partir de `arte/referencias/mbappe-v1.png`. Oito poses de corrida voltadas para a esquerda; identidade de França azul, branco e vermelho, proteções prateadas e chuteiras azuis. O rival ainda NÃO foi incluído na fase e nenhum GDScript foi alterado nesta etapa.

## Prévia

Abrir `previa-corrida.html`. Compara corrida e referência aprovada, com sequência ilustrativa de perseguição (1200 ms), aviso (240 ms), arrancada (350 ms) e recuperação (800 ms). O mesmo ciclo é acelerado na arrancada, com inclinação extra discreta, rastro azul e duas silhuetas translúcidas. Efeitos separados, desligáveis; não há teletransporte, física ou novo ataque implementado no motor.

Ciclo normal de 530 ms, tempos 75,65,60,65,75,65,60,65. Cadência de arrancada 1,65× e recuperação 0,55×. Valores provisórios para revisão; integração futura deve considerar a velocidade e o alcance do jogador, com aviso legível e intervalo entre arrancadas.

## Transparência e exportação

A primeira geração (`corrida-v1.png`) veio com fundo branco parcialmente opaco. Uma primeira limpeza (`corrida-v1-limpa.png`) ainda deixou alpha no fundo. A terceira geração, combinando referência de identidade com as poses, produziu `corrida-v1-transparente.png`, com alpha zero nos pontos de canto e intervalo verificados. As versões anteriores ficam preservadas como fontes, sem referência na prévia.

A folha transparente ainda tem resíduos de contorno colorido e variações de face/roupa entre poses; precisam de revisão antes de integrar. A prévia permite verificar movimento e proporções, não indica arte final sem defeitos.

`preparar-corrida.ps1` recorta e alinha oito quadros em `quadros-corrida-v1`, célula 256×256, escala comum 0,5, plano de apoio por linha e fases de voo preservadas. Exporta folha `corrida-v1-alinhada.png` (2048×256), metadados e referência `parado-v1.png`. Recorte e redimensionamento são preparação técnica; não houve remoção de fundo por script.

## Validação

Folha exportada inspecionada visualmente; recortes não vazios, limites dentro das células e fundo transparente amostrado. JavaScript exercitado com DOM/canvas simulados: dimensões reais dos PNGs, ciclo, aviso, arrancada, recuperação, controle por quadro, modos, efeito ligado/desligado, direção, escala e reinício. Sem teste em navegador real ou integração no Godot nesta etapa.

Próximo passo após conferir a prévia: criar variante do perseguidor para Mbappé, com movimento terrestre, aviso, impulso curto e recuperação; reutilizar Resistencia e manter o goleiro saltador obrigatório.

## Prompt de corrida

Use case: identity-preserve. Asset: exactly EIGHT distinct running-cycle poses for MBAPPÉ — O RELÂMPAGO in FORA DE CAMPO. The supplied image is the approved Mbappé identity reference: preserve his recognizable realistic Kylian Mbappé face, natural skin tone, very short close-cropped hair, lean powerful athletic build, navy-blue France number10 jersey, white shorts with10, red socks, slim silver forearm/shin protection and blue football boots. Same detailed crisp pixel art and adult proportions. NO cape, no ball, no helmet, no weapons. No gold armor or Cristiano haircut/face.
One sprite sheet FOUR COLUMNS TWO ROWS, eight equal cells, read top row left-to-right then bottom row. Every figure complete and unclipped, safe margins around hands, hair and boots. Fixed SIDE PROFILE facing LEFT, not front-facing torso. Consistent body scale/head size and horizontal pelvis anchor. Natural football sprint with slightly forward inclined torso, strong knee drive, quick heel recovery, relaxed hands, elbows pumping close to body in opposition to legs. Compact fast sprinter, not huge bounding jumps or a stiff march. Exactly two arms and legs.
Frame1 near forefoot contacts under hips, far leg trailing, opposite arms.
Frame2 near support knee absorbs weight, far knee recovers forward.
Frame3 near leg pushes backward, far thigh passes forward, rear heel recovers.
Frame4 short airborne flight, far leg preparing next contact and near leg folded back, opposite arms.
Frame5 FAR foot contacts under hips and near leg trails, arms reverse frame1.
Frame6 far support knee absorbs weight, near knee recovers.
Frame7 far leg pushes backward and near knee drives forward.
Frame8 brief flight preparing near-foot contact, leading smoothly back to1.
Grounded poses use common local baseline; flight boots slightly clear ground. Moderate subtle head bob, no scale changes or inconsistent face. Do not draw world displacement across the sheet. This single cycle will be played faster for the short dash, so it must read as athletic speed at both cadences. Draw ONLY sprites, no speed effects or aura; blue dash effects will be separate. True TRANSPARENT background with clean dark outlines, no halo, blue haze, red fringe, dust, floor, shadows, labels, title or grid.

## Prompt de limpeza inicial

BACKGROUND EXTRACTION ONLY for the supplied eight-frame pixel-art Mbappé running sheet. Preserve all eight exact poses, face, natural skin tone, close-cropped hair, navy-blue France number10 jersey, WHITE shorts, red socks, SILVER guards and blue boots. Keep same four-column two-row arrangement, scale and limb positions. Remove the entire off-white/white/grey background and any floor shadow to TRUE fully transparent alpha: every empty pixel outside the solid dark sprite outlines must have alpha zero, not a faint white texture or semiopaque matte. Preserve WHITE shorts and SILVER guards INSIDE their dark outlines; do not remove clothing highlights. Clean tiny grey/blue fringe outside outlines. Do not redesign, recolor, crop, rescale individual figures, add glow or change poses. Complete figures with safe margins on one transparent sheet, no text or grid.

## Prompt da folha transparente selecionada

Regenerate a NEW clean eight-frame Mbappé run sprite sheet using TWO references. FIRST image: approved Mbappé appearance and genuinely transparent cutout style. SECOND image: eight RUNNING POSES and four-column two-row layout ONLY; its pale background, haze, shadows and partial transparency are defects and MUST NOT be carried over. Same recognizable Mbappé face/close-cropped haircut, navy France number10 jersey, white shorts, red socks, slim silver guards and blue boots as first reference. Same detailed dark-outlined pixel art, eight complete figures facing LEFT, same anatomical scale, alternating legs and arms as second reference. Four columns two rows with safe clear margins. Re-render ONLY the character pixels and NOTHING else. Character interiors fully opaque; all empty background space and gaps between legs and arms have exactly ZERO ALPHA, with no soft white/grey shadows, no white paper texture, no background wash and no halo. Do not interpret transparency as white paint or a checkerboard. No scenery, ground, floor shadow, dust, trail, aura, text or grid. Keep legitimate white shorts and silver guards. Aim for a clean game-sprite atlas on transparency, not an illustration printed on a pale background.

