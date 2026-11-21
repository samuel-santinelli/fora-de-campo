# Carrinho Relâmpago — v1

Ferramenta integrada de imagens, usando a pose lateral aprovada como referência. Oito poses: preparação, entrada, extensão da perna, deslizamento, final do deslize, recolhimento, levantamento e retorno à postura. Segunda passagem de edição para reduzir a contaminação das bordas, sem alterar a direção visual. Ainda há pequenos resíduos e diferenças entre poses a revisar antes da integração.

## Prévia

Abrir `previa-carrinho.html`. Comparação com a referência parada, seleção de quadros, velocidade, direção e tamanho. Rastro dourado e deslocamento são efeitos separados da arte, opcionais. Começa a meia velocidade para revisão. Duração total de 500 ms em velocidade normal, igual à duração da animação de carrinho original.

O deslocamento no HTML é apenas ilustrativo. O jogo ainda não foi alterado nesta etapa. Na integração, preservar o sistema de ataque próximo existente e sincronizar arte/efeitos à sua janela de colisão; um eventual impulso deve ser curto, obedecer às colisões e não reconstruir o movimento. O rastro aparece nos quadros de deslizamento, não durante toda a recuperação.

## Arquivos

- `carrinho-v1.png`: geração inicial.
- `carrinho-v1-limpa.png`: segunda passagem de limpeza.
- `quadros-carrinho-v1`: oito recortes transparentes de 384×256.
- `carrinho-v1-alinhada.png`: folha horizontal de 3072×256.
- `carrinho-v1-alinhada.json`: metadados e durações 50,50,60,80,80,60,60,60 ms.
- `preparar-carrinho.ps1`: exportação reproduzível. Recortes por linha revisados para não separar poses largas ou capturar o vizinho. Escala comum 0,5, apoio no chão, âncora local (192,240). Célula mais larga que repouso para não encolher a perna estendida.

## Verificação

Folha exportada inspecionada visualmente; oito recortes não vazios e destinos dentro das células. JavaScript executado com DOM/canvas simulados: dimensões reais dos PNGs, reprodução, seleção/avanço, efeito ligado/desligado, deslocamento, inversão e escala. Não testado em navegador real nesta etapa. Nenhum script ou cena do jogo foi modificado.

Conferir sem rastro: rosto durante o carrinho, contato da mão com o chão, escala em relação ao repouso, anatomia das pernas e transição 7→8. O rastro é um efeito gráfico simples em canvas e não exige uma nova imagem.

## Prompt de criação

Use case: identity-preserve. Create EIGHT animation keyframes of a grounded FOOTBALL SLIDE TACKLE (Carrinho Relâmpago) for FORA DE CAMPO. Strict character reference is the provided approved Cristiano Ronaldo pixel-art character. Keep his realistic recognizable face, swept short dark hair, athletic adult anatomy, red Portugal jersey number7 with green trim, green shorts, red socks, light gold shoulder/forearm/shin armor, gold football boots, short red cape with gold edging. Same detailed crisp pixel art, not smooth painting or chibi.
One sheet EXACTLY FOUR COLUMNS TWO ROWS, eight equal invisible cells, read left-to-right top row then bottom row. Side view facing RIGHT throughout, body same anatomical scale across all frames. Leave generous space around EVERY complete pose: horizontal sliding poses are wide; don't shrink them relative to standing poses, instead reserve sufficient width in each cell. All figures separated and unclipped, fixed camera, consistent local ground baseline. Do not draw world displacement across cells; game moves root.
Sequence:
1 quick low crouch, near knee bends, hips drop, hands open balancing.
2 entering slide: hips descend almost to ground, near leg stretches FORWARD to right, far knee folds underneath, torso leans back and left hand reaches near ground.
3 full slide tackle: near leg extended to right nearly horizontal, far leg bent, hip skims ground, torso reclined around 40 degrees, face focused right.
4 strongest active slide pose, golden boot leads right at low ankle height, sole not aimed upward, open balancing hands, cape drags behind LEFT clear of face.
5 slide follow-through, same extended leading leg and cape trailing, arms shift naturally, no rotation to face camera.
6 recovery begins: pull extended leg back, bend knee and plant one foot, one open hand braces beside hip.
7 rise from one-knee crouch, chest comes forward and weight over planted foot.
8 return to approved neutral standing side pose, cape settles.
Exactly two arms and two legs, believable football slide mechanics; NO kick in the air, no flying, no split, no flip, no combat roll. Facial identity stable, clothing and number7 consistent. Cape is cloth and cannot obscure leading boot or hands.
Transparent alpha background with clean dark pixel outlines: NO ground, floor, dust, particles, glow, gold trails, gradients, aura, red fringe, labels, title or grid. Effects will be added separately in game. Output one eight-frame sheet with complete body in every cell.

## Prompt de limpeza

Clean the supplied eight-pose football slide-tackle sprite sheet. Preserve EXACTLY the existing character, face, body scale, all eight poses, open hands, leg positions, red Portugal number7 uniform, green shorts, gold armor, red/gold cape and pixel-art detail. Do not rearrange figures or change their sizes or poses. Remove only the bright red/orange and yellow matte contamination OUTSIDE the solid dark character outlines. Empty gaps around fingers, between limbs and outside cape must be fully transparent, with crisp dark pixel contours and no red glow, floating pixels, dust or gradient haze. Keep legitimate red and gold INSIDE clothing, cape and armor. No new effects, no background, no shadows, labels or grid. The golden trail will be added separately at runtime. Keep one full sheet in exactly the same layout, every complete sprite unclipped.

