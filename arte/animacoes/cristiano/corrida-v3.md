# Corrida v3 — braços conforme a foto do usuário

Referências: fotografia anexada pelo usuário para postura/gesto e corrida-v2.png para aparência. Geração e limpeza feitas com a ferramenta integrada de imagens. Não copiar uniforme de treino, marcas, equipamento de resistência ou cenário da fotografia. Manter o personagem de Portugal com armadura dourada e capa.

Mudança principal: tronco inclinado, braço traseiro mais estendido e mãos abertas com dedos separados, conforme a referência fornecida. As fases intermediárias recuperam o braço, evitando uma pose permanentemente fixa. Trata-se de adaptação artística para oito poses, não captura de movimento.

Arquivos: corrida-v3.png (geração inicial), corrida-v3-limpa.png (segunda passagem de limpeza), quadros-corrida-v3 e corrida-v3-alinhada.png (exportação da segunda passagem). Prévia atual: previa-corrida.html; a anterior está em previa-corrida-v2.html. Nenhuma alteração nos scripts ou cenas do jogo.

A segunda passagem reduziu a contaminação vermelha ao redor dos contornos, mas ainda há pequenos resíduos e variações entre poses que merecem inspeção antes da integração. Conferir também alternância de braços, consistência da cabeça e o retorno 8→1 em movimento. O número 7 e detalhes do uniforme podem variar ligeiramente entre quadros gerados.

## Prompt de criação

Use case: identity-preserve, game run-cycle correction. TWO REFERENCES: the user-provided PHOTOGRAPH of Cristiano Ronaldo sprinting in a white training shirt is the POSE AND ARM-MECHANICS reference ONLY. The pixel-art sprite sheet is the CHARACTER DESIGN reference and edit target. Preserve the sprite's approved recognizable face, short dark haircut, red Portugal number 7 jersey, green shorts, red socks, light gold shoulder/forearm/shin armor and gold boots, short red cape with gold edging and detailed pixel art. Do not copy white shirt, sponsor, resistance belt, training equipment, grass or background from photograph.
CRITICAL USER CORRECTION: replace the compact tucked-in jogging arms with the photograph's distinctive dynamic sprint silhouette: torso tilted forward, shoulders opening and rotating slightly, rear arm driven FAR BEHIND the torso with elbow nearly straight, palm OPEN and fingers visibly spread, front arm bent forward with an OPEN splayed hand near chest height. NO CLENCHED FISTS. The rear hand must clearly extend beyond the cape at the key extension poses. This is NOT arms both held in front of the ribs. Each half-stride alternates the forward and rear arms naturally. Hands have five anatomically coherent fingers with readable spread silhouette, not tiny blobs. Body faces RIGHT (mirror the photograph's running direction for the game); face remains focused right. Do not turn into celebration, flying, T-pose or permanently both arms behind body. Exactly TWO arms per figure.
Output exactly EIGHT full-body distinct running frames in FOUR columns TWO rows, equal invisible cells, fixed camera, fixed scale, fixed pelvis horizontal anchor. Row 1 near-leg stride; row2 opposite-leg stride.
1 forefoot contact, near knee over foot, near arm reaching rearward with open fingers, far arm forward bent with open hand.
2 weight acceptance, rear arm beginning its recovery, forward hand starting descent.
3 push-off, arms pass near waist with open relaxed fingers, knees cycling.
4 short flight, opposite arm now extending rearward openly, near knee recovers forward.
5 opposite leg forefoot contact, far arm extended behind body open splayed hand, near arm forward bent open hand.
6 weight acceptance and smooth arm recovery.
7 push-off with arms passing waist again.
8 brief flight, near arm starts extending back and opposite arm swings forward, naturally looping to1.
Keep powerful football sprint leg action and heel recovery, slight vertical bounce, grounded contact frames share baseline; flight feet slightly above it. Safe margin around extended hands, cape, boots, head; no figures overlapping adjacent cells or clipped fingertips. Cape trails behind without covering open rear hand. True transparent alpha background with NO floor, shadows, halo, gradients, labels, grid or extra characters. Preserve all outfit and facial identity, change running mechanics to match supplied photograph.

## Limpeza

Segunda edição solicitando exclusivamente remover o matte vermelho/laranja e o halo fora da silhueta, preservando poses, rosto, dedos abertos, roupas, armadura, capa, escala e arranjo 4×2. Fundo transparente.

## Exportação e verificação

Escala comum 0,5 e mesmo plano de chão por linha; posições de voo preservadas. Células 256×256, duração do ciclo 530 ms. Reexportar com `powershell -NoProfile -ExecutionPolicy Bypass -File ./arte/animacoes/cristiano/preparar-corrida.ps1 -Version v3`. Exportador valida conteúdo e limites de todas as células. Prévia com controles verificada por DOM/canvas simulados; não houve teste em navegador real.

