# Haaland — avanço pesado v1

Altura aprovada pelo usuário: 20% maior. Capa de pele viking e referência `../../referencias/haaland-com-capa-v2.png` preservadas. Prévia em `previa-avanco.html`; a página não modifica cenas. Etapa de arte concluída; integração posterior documentada em `INTEGRACAO.md`.

## Arquivos e escala

Geração pela ferramenta integrada imagegen, seguida de uma edição para reduzir resíduos vermelhos do contorno. Original `avanco-v1.png` e edição `avanco-v1-limpo.png` preservados. Exportador `preparar-avanco.ps1` apenas recorta, alinha e redimensiona por vizinho mais próximo, sem desenhar novos quadros. Oito células de 320×320, âncora (140,300), folha 2560×320 e oito PNGs em `quadros-avanco-v1/`. Fundo alpha transparente conferido; pequenos resíduos de contorno ainda podem precisar de revisão visual.

Altura visual alvo 278,4 px na folha, comparada a 232 px das referências eretas anteriores. Na futura escala 0,5, equivale aproximadamente a 139,2 px contra 116 px. Uma escala comum ao ciclo preserva compressão e oscilação da cabeça. Linhas de chão por fileira evitam alinhar individualmente cada pé levantado. Referência parada exportada na mesma altura alvo. O tamanho final deve ser conferido com poses eretas no Godot; colisão deve acompanhar corpo, excluindo capa.

Ciclo 960 ms: 130,120,110,120,130,120,110,120. Passada firme, tronco mais ereto e movimento secundário da capa. A prévia oferece pausa, quadro a quadro, espelhamento, pose parada, ritmo e comparação com Mbappé.

## Reaproveitamento identificado

`script_mbappe.gd` já estende `script_inimigo2.gd`: corpo, gravidade, move_and_slide, contato, detecção de tela e componente Resistencia existentes. Para Haaland, reaproveitar essa base terrestre com velocidade menor e maior vida no mesmo componente; não copiar a arrancada rápida do Mbappé como identidade do Tanque. Proposta para próxima integração: quatro vidas, perseguição lenta e contato atual, sem projéteis ou sistema novo. Manter goleiro, arbitragem e chefão exigidos. Não foram alterados scripts de combate, cenas ou valores dos personagens existentes nesta etapa.

## Validação

Exportador executado com verificação de fundo e limites de cada célula. Prévia exercitada com DOM/canvas simulados para carregamento, controles, ciclo e comparação. Folha exportada inspecionada como imagem. Não houve validação em navegador real nem integração no Godot nesta etapa.

## Prompts — ferramenta integrada

### Geração

Use case: identity-preserve. Asset: production pixel-art sprite sheet for existing football platform game, Haaland heavy advance loop. Input is approved character design; preserve recognizable Erling Haaland face, blond tied bun, red Norway jersey number 9, white shorts number 9, navy socks, dark steel armor at shoulders/forearms/shins, navy boots with red accents, and shaggy grey-brown Viking FUR CAPE behind shoulders to knees. SAME character design in every frame. Create EXACTLY EIGHT distinct full-body sequential animation poses, arranged in an EXACT 4 COLUMN by 2 ROW evenly spaced grid, each equal cell containing one complete side-facing LEFT character, same physical scale, head size, consistent torso center and ground level within each row. Canvas wide landscape 1536x1024 if possible. Every character entirely inside its cell, generous clear gutters; no touching neighboring poses. Heavy powerful football jog/advance, NOT a sprint: upright broad torso with subtle forward lean, strong deliberate heel contact, knees compress at weight acceptance, purposeful opposite arm swing with bent elbows, grounded weight, small vertical head oscillation. Frames 1 left heel contact, 2 compression, 3 legs passing, 4 right leg extends forward, 5 right heel contact, 6 compression opposite, 7 passing opposite, 8 left leg extends toward first contact. Visible changing leg and arm poses; no duplicates. Fur cape swings with delayed secondary motion, readable fur tufts, does not cover face or planted feet. Crisp detailed PIXEL ART with discrete pixel clusters and dark outlines, coherent realistic adult proportions; not smooth illustration or chibi. True transparent alpha background everywhere between characters, NO solid or semitransparent background, NO black backdrop, gradients, haze, glow, floor shadow, floor, dust, speed streaks, labels, cell outlines, text or watermark. Character pixels opaque, background fully alpha zero. Number 9 is only text. Do not bake 20% size increase into anatomy: 20% taller in-game will be set in export/rendering. Match reference identity and costume exactly.

### Limpeza

Use case: background-extraction. Clean this exact eight-frame 4x2 Haaland sprite sheet for production. Keep ALL EIGHT poses, positions, sizes, costume details, face, blond hair, navy/red boots, dark armor and shaggy grey-brown fur cape IDENTICAL. Remove ONLY stray red/magenta outline artifacts outside his skin/hair/legs, plus any backdrop haze or matte remnants. Red belongs INSIDE the football jersey and boot accents only, never around blond head or bare knees. Replace every background pixel with actual fully transparent alpha zero, preserve character opaque pixels and clean dark pixel-art outlines. NO colored fringe, NO checkerboard baked in, NO blur, NO floor/shadows, NO repaint, NO rearrangement of frames. Retain 1536x1024 sheet, four equal columns two equal rows, full bodies and empty transparent gutters.
