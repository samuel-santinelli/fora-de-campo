# Neymar — movimentação e finta v1

Prévia de animação em `previa-movimento.html`, seguindo a referência aprovada `../../referencias/neymar-v1.png`. Registro da etapa de arte; a integração posterior à fase está documentada em `INTEGRACAO.md`.

## Arte e exportação

Criadas pela ferramenta integrada imagegen: `corrida-v1.png` e `finta-v1.png`, cada uma com oito poses em quatro colunas por duas fileiras. Edição de contorno da finta em `finta-v1-limpa.png`; original preservado. A edição reduziu parte dos resíduos, mas NÃO eliminou todos: ainda existem pixels vermelhos/amarelados nas bordas, visíveis nos PNGs exportados. Revisar antes de considerar a arte final limpa. Há pequenas variações de rosto e postura entre as poses geradas, a conferir na prévia.

`preparar-movimento.ps1` faz recorte por alpha, alinhamento e escala por vizinho mais próximo. Usa uma única escala para as duas folhas, sem normalizar cada pose individualmente; isso preserva a flexão dos joelhos na finta. Cada fileira tem uma linha de chão comum, preservando pés elevados na corrida. Não redesenha sprites. Exporta duas folhas 2048×256 com células 256×256 e âncora (140,240), dezesseis quadros individuais e `parado-v1.png`. Referência visual de altura 232 px na folha, prevista em escala 0,5 para ficar na mesma faixa de altura de Cristiano/Mbappé. O aumento de 20% continua exclusivo de Haaland. A pose aprovada está com joelhos flexionados; calibrar proporções pelas poses eretas na futura integração.

## Ritmo e prévia

Corrida: 85,75,65,75,85,75,65,75 ms (600 ms). Finta: 90,100,110,160,90,80,110,140 ms (880 ms), com sustentação no engano. Sequência demonstrativa: aproximação 1200 ms, finta 880 ms, recuperação 350 ms. Deslocamento horizontal curto da finta é somente apresentação no HTML, não implementação de colisão ou esquiva. O corpo mantém orientação e muda o peso, sem teletransporte ou invulnerabilidade.

Controles: reprodução/pausa, reiniciar, avanço de um quadro, seletor de quadro, modo completo/corrida/finta, ritmo e espelhamento. Referência parada fica ao lado para comparação. A prévia não inclui chute nesta etapa.

## Verificação

Exportador concluiu com validação de cantos transparentes e limites das células; folhas e quadros inspecionados como imagens. Exercício com DOM/canvas simulados confirmou dimensões, carregamento, dezesseis PNGs, escala compartilhada, duração, controles, pausa, finta, recuperação e reinício do ciclo. Não houve inspeção em navegador real nem teste no Godot, pois o gameplay não mudou. Scripts PowerShell foram executados com política Bypass apenas para o processo de exportação, sem mudar a configuração persistente do sistema.

## Próxima integração

Reaproveitar corpo e perseguição terrestre existentes, com avanço/recuo e uma curta recuperação legível. Manter dois ou três estados simples e evitar esquiva automática perfeita. Depois preparar chute com aviso usando uma variante do projétil inimigo, preservando juiz atirador de cartões e os demais inimigos obrigatórios. Não adicionar trajetória extra nem sistema de navegação nesta etapa.

## Prompts — ferramenta integrada imagegen

### Corrida

Use case: identity-preserve. Asset: Neymar eight-frame movement sprite sheet for existing 2D pixel art football platformer. Reference image is approved Neymar design: preserve recognizable Neymar face, tan skin, blond-tipped short curls with faded sides, short beard, small stud, tattoos, yellow Brazil number10 jersey green trim, blue shorts10, white socks green trim, green boots, light dark-metal wrist/forearm and shin guards with green accents; NO cape. EXACTLY EIGHT sequential distinct short nimble JOGGING poses in EXACTLY FOUR EQUAL COLUMNS AND TWO EQUAL ROWS, landscape1536x1024. One complete full-body sprite per cell, every pose faces LEFT in stable side view, feet at same ground baseline per row, body centered same local x, same scale and head size in all cells. Short quick controlled steps and agile bent knees, relaxed bent arms in opposite swing, slight forward torso angle, subtle vertical bob; Neymar dribbler footwork, not Mbappe full sprint or Haaland heavy march. Frames 1 left contact,2 compression,3 pass,4flight,5rightcontact,6compression,7pass,8flight back to1. Consistent identity, anatomy and outfit, crisp detailed pixel clusters and dark pixel-art contours, realistic adult proportions, not photorealistic, blurred painting, vector or chibi. Generous transparent gutters and margins, no clipped hair,hands,boots. TRUE ALPHA TRANSPARENT background, all exterior pixels fully alpha0; no matte, colorful fringe, gradient, halo, haze, floor, shadows, platform, ball, speed lines, labels or watermark. Number10 only costume text. Eight poses only; no extra figures.

### Finta

Use case: identity-preserve. Asset: eight-frame Neymar BODY FEINT animation sprite sheet for 2D platform game, following approved character reference. EXACTLY FOUR EQUAL COLUMNS by TWO EQUAL ROWS on landscape1536x1024, one full body in each cell, row-major order. Preserve recognizable Neymar face, short curly blond-tipped hair and faded sides, short beard, ear stud, tattoos, yellow Brazil10 jersey green trim, blue shorts10, white socks green trim, green boots, light dark-metal guards green accents. SAME style and proportions as reference. Stable SIDE VIEW FACING LEFT throughout, no turning back or changing camera, no ball. This is NOT a run cycle: make distinct readable body-feint poses. Frame1 ready knees softened,2 lowers hips and draws hands out for balance,3 steps forward LEFT and dips left shoulder as bait,4 holds left-lean anticipation with rear foot firmly planted,5 shifts weight back RIGHT with torso twist still head looking LEFT,6 pushes off front foot into short backwards sidestep RIGHT while facing LEFT,7 settles on rear leg with open arms,8 recovers to ready pose similar to1. Smooth progression, convincing balance and knee compression, fixed anatomy and consistent scale. All sprites fully contained with large gutters, consistent floor baseline per row and same local hip center allowing only small authentic weight shift. Detailed crisp pixel art, discrete pixel clusters, dark outlines, realistic adult facial proportions. TRUE transparent alpha0 background outside character. NO haze, gradient, glow, shadows, floor, dust, ghost copies, motion blur, ball, captions, grid lines, watermark, weapons or cape. No red or magenta outline artifacts.

### Revisão do contorno

Use case: background-extraction. Clean ONLY the contour of this exact 4x2 eight-frame Neymar body-feint sprite sheet. Preserve all eight poses, same positions, dimensions, facial identity, clothing and pixel-art style. Remove stray RED and MAGENTA matte pixels hugging the outside of shoulders, hair, arms, thighs and hands. There are NO RED parts anywhere in Neymar's design: costume is yellow green blue white, skin tan, guards grey. Restore clean dark contour around character without colored fringe. All areas outside character must be FULLY alpha0 transparent, not semitransparent colored gradients. Keep all eight full bodies in exactly four columns two rows. NO floor, glow, haze, shadows, text, labels or new objects. Do not alter pose or proportions.
