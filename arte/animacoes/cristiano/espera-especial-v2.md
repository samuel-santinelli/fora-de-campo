# Cristiano — espera especial v2

Oito poses em quatro colunas e duas linhas, lidas da esquerda para a direita, primeiro a linha superior. Geradas pela ferramenta integrada de imagens usando a pose base v2 como referência de identidade. A versão v1 e as referências continuam preservadas. Ainda não integrada nas cenas.

## Direção de animação

Antecipação, elevação progressiva da mão, contato na testa, passagem pelo cabelo, descida progressiva e retorno à postura inicial. Sorriso contido; rosto com proporções realistas dentro do estilo pixel art aprovado. Capa acompanha o gesto com pequenas variações. A fluidez ainda precisa ser avaliada em reprodução: mais poses não garantem uma animação suave por si só.

Antes de integrar: recortar e alinhar cada quadro pelo corpo e sola, conferir estabilidade de rosto e armadura em tamanho de jogo e ajustar o movimento da capa. A mudança do quadro 4 para 5 pode precisar de uma pose intermediária. O brilho nos dentes não ficou destacado na geração; aplicar como pequeno efeito separado, se necessário, para não alterar a expressão facial.

Proposta inicial de durações por quadro em segundos: 0.30, 0.10, 0.10, 0.12, 0.16, 0.12, 0.18, 0.30. Ajustar após visualização. Executar uma vez após alguns segundos parado e voltar à respiração normal; interromper imediatamente com movimento ou ataque. Sem alterar as colisões do personagem.

## Prompt utilizado

Use case: identity-preserve. Create a polished 8-frame hand-animated sprite sheet for a premium 2D action platformer, improving stiff movement through anticipation, overlapping action, natural arcs, and easing. Reference image is the strict identity target: same recognizable Cristiano Ronaldo face, short swept dark hair, nose, jaw, skin, adult athletic proportions, red Portugal number 7 shirt, green shorts, red socks, small gold shoulder/forearm/shin armor, gold boots, short red cape with narrow gold edging. Preserve that design, detailed crisp pixel-art medium, realistic facial proportions; no caricature, no new outfit. Exactly EIGHT full-body frames in a regular FOUR COLUMN by TWO ROW grid, read left-to-right top row then left-to-right bottom row. All figures face RIGHT, identical side camera, head size, leg lengths, costume and scale. Equal-size invisible cells, all boot soles at identical baseline within each cell, ample margins. Clean transparent alpha background, no grid lines, labels, text, floor shadows, atmospheric glow, ball or environment.
Animation: confident natural idle flourish adjusting his hair, then a restrained smile. Crucial anatomy: animate ONLY the near-side arm lifting from its resting position in a continuous arc; far arm stays relaxed at the far side. Exactly TWO ARMS per figure, do NOT leave a duplicate near-side arm hanging when it is raised. Hand follows forehead to crown; no salute.
Frame 1 neutral ready idle, relaxed knees, arms down.
Frame 2 subtle exhale, slight weight shift with feet planted, near shoulder rises as elbow bends, hand lifts to chest height.
Frame 3 near hand rises past chin toward temple, elbow forward, small shoulder rotation, head dips very subtly.
Frame 4 fingertips contact front hairline, near elbow lifted, natural wrist, chest expands slightly.
Frame 5 fingers brush BACK across crown, head tilt only a few degrees, same facial profile and haircut; cape lags gently behind shoulder movement.
Frame 6 hand releases hair above temple and starts descending, elbow relaxes, face begins subtle confident smile.
Frame 7 hand lowers to waist along smooth arc, shoulders settle, restrained smile with tiny four-point glint at teeth corner, not exaggerated grin, cape still finishing its motion.
Frame 8 arm returns to neutral exactly as frame 1, face relaxes to original expression, cape settles, seamless return to breathing.
Do not make torso and head rigid identical cutouts: very subtle breathing shoulder/chest changes, but no scale changes or drifting feet. Cape must show modest delayed follow-through, not independent violent wind. Prioritize believable smooth transition poses and consistent likeness over flashy effects. One sheet with eight complete, separated figures, no cropped limbs or cape.

