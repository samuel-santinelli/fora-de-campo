# Salto e queda — v1

Geração pela ferramenta integrada de imagens usando a pose lateral v2 aprovada como referência. Oito poses: preparação, impulso, subida, ápice, início de queda, queda, aterrissagem e recuperação. Uma segunda passagem de geração limpou o fundo e ajustou margens. Há pequenas variações e resíduos de contorno a revisar; não são quadros finais integrados ao jogo.

Prévia: `previa-salto.html`, com comparação ao repouso, controle de velocidade, seleção de quadro, direção e trajetória ilustrativa opcional. Fonte original `salto-v1.png`, segunda passagem `salto-v1-limpa.png`, folha exportada `salto-v1-alinhada.png`, oito recortes em `quadros-salto-v1` e metadados em `salto-v1-alinhada.json`.

O exportador existente foi ampliado com opção `-Animacao salto`; o comportamento padrão de corrida foi mantido. Limites de coluna específicos evitam capturar parte do vizinho, pois a geração não manteve espaçamento uniforme. Alinhamento horizontal pelo centro do topo do cabelo, com deslocamento constante; escala comum 0,5, sem esticar cada pose. Plano de referência vertical comum por linha, preservando recolhimento das pernas. As proporções da recuperação devem ser comparadas ao repouso antes da integração.

Reexportar: `powershell -NoProfile -ExecutionPolicy Bypass -File ./arte/animacoes/cristiano/preparar-corrida.ps1 -Animacao salto -Version v1`.

## Integração futura

Não alterar impulso, gravidade, colisões ou controle aéreo. Não introduzir atraso obrigatório de preparação nem bloquear comandos na aterrissagem. Escolher poses pela velocidade vertical e contato com o chão; segurar subida/queda conforme necessário em vez de repetir um ciclo completo durante o voo. A trajetória e tempos do HTML servem apenas para revisão, não representam o cálculo da física atual.

## Validação desta etapa

Inspeção visual da folha alinhada, oito recortes não vazios e destinos dentro das células. JavaScript executado com DOM/canvas simulados: reprodução, seleção, avanço, direção, escala e trajetória ativada/desativada. Não testado em navegador real. Nenhuma cena ou script GDScript do jogo alterado.

## Prompt de criação

Use case: identity-preserve. Asset: jump and fall keyframe sprite sheet for FORA DE CAMPO, a 2D football platformer. The input is the strict approved character reference. Preserve recognizable Cristiano Ronaldo's mature realistic face, hair, athletic adult proportions, red Portugal number 7 shirt with green trim, green shorts with visible 7, red socks, small GOLD shoulder/forearm/shin armor, gold boots, short red cape with narrow gold edging. SAME detailed crisp pixel art, no redesign, no chibi, no painted photorealism. All figures face RIGHT in consistent SIDE PROFILE; no facial turn toward camera.
Produce EXACTLY EIGHT full-body poses in FOUR COLUMNS and TWO ROWS, equal cells, read top row left-to-right then bottom row. Same scale and horizontal hip anchor, consistent head/limb sizes. SINGLE JUMP sequence with natural footballer athletic jump, expressive OPEN hands and fingers, no weapons or ball, no aerial attack.
1 very short anticipation: knees slightly flexed and hips lowered, chest forward slightly, arms swept just behind hips, both feet on baseline.
2 takeoff: legs extending powerfully, toes pushing down, arms swinging forward and upward with open hands to generate lift.
3 rising: near knee bends forward, trailing leg flexed, torso extends upward, elbows bent and open hands near shoulders. Cape lags DOWN behind shoulders.
4 apex: compact balanced airborne pose, knees moderately tucked, torso upright, hands open and slightly spread for balance; cape lifts gently.
5 early descent: knees begin unfolding, arms open to sides and slightly forward for balance, cape drifts upward slightly relative to body.
6 falling: legs extend downward ready to land, knees still soft, arms spread slightly with open hands, chest centered and face focused right. Cape floats gently upward behind.
7 landing: feet on baseline, knees bend deeply enough to absorb impact, torso compresses, arms swing down and forward. No dust effects.
8 recovery: return to approved upright neutral idle silhouette, arms relax at sides and cape settles.
Respect joint anatomy, exactly two arms and two legs in each pose. Keep pelvis at SAME local canvas anchor height across airborne frames 3-6 (the game moves the character in world space; don't draw a trajectory across the sheet). Grounded frames share foot baseline. No enormous leaps or superhero flight pose. Allow small head height change due to knee flexion. Plenty of margin around hands, head and cape, no overlap or clipped sprites. Transparent alpha background, clean crisp dark pixel outline with NO halo, colored fringe, floating pixels, gradients, floor, shadow, ground, labels, title or grid. One coherent eight-pose sheet.

## Prompt de limpeza

Edit this eight-pose jump sprite sheet ONLY to clean the cutouts and fix safe margins. Keep same character, realistic Cristiano face, Portugal number 7 uniform, gold armor, cape, open hands, all eight jumping poses and four-column two-row order. Remove ALL bright red matte contamination OUTSIDE the character's dark outlines; keep red shirt, socks and cape inside silhouette. No red haze, no particles, no glow, no energy effects. Transparent alpha empty space. The TOP RIGHT apex pose has insufficient space above the hair: ensure the complete head including hair has at least 20 pixels of transparent space above in its cell, without clipping any other body part. Give all figures consistent safe margins, scale all eight uniformly only if necessary, do not independently resize or change pose. All heads and limbs retain consistent size. Maintain fixed camera side view facing RIGHT. Deliver eight isolated clean full-body sprites, same four-by-two sheet, no scenery, shadow, text or grid.

