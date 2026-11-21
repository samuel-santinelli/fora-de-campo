# Cristiano — corrida v1

Gerada com a ferramenta integrada de imagens a partir da pose lateral aprovada. Oito poses em quatro colunas e duas linhas. Os scripts e as cenas do jogo não foram modificados nesta etapa.

## Prévia

Abrir `previa-corrida.html`. Exibe a corrida e a pose parada aprovada lado a lado; permite pausar, selecionar quadros, variar velocidade, inverter direção e comparar em 128, 256 ou 384 pixels. A guia e o chão móvel são auxiliares de revisão.

## Exportação

`preparar-corrida.ps1` exporta oito quadros de 256 × 256 e a folha `corrida-v1-alinhada.png`, com 2048 × 256. Usar escala comum 0,5 da folha gerada, sem redimensionar cada pose individualmente. Âncora horizontal em 56% da célula original e plano de chão comum por linha, preservando o espaço sob os pés nos quadros de voo. Tempos em ms: 85,75,65,75,85,75,65,75. Ciclo total: 600 ms. As células de revisão correspondem a metade do tamanho quando exibidas a 128 pixels, como a espera atual no Godot.

A escala da corrida é uma aproximação inicial da proporção da cabeça em relação à espera; precisa de comparação visual antes da integração. O corpo inclina e flexiona as pernas, reduzindo naturalmente sua altura. A arte é uma primeira versão: verificar consistência do rosto, alternância das pernas e fluidez na transição 8→1. Pequenas diferenças no contorno e número 7 entre poses geradas continuam sujeitas à revisão.

## Verificação

Inspeção visual da folha alinhada; oito recortes com conteúdo e destinos inteiramente dentro das células; confirmação da folga dos pés nas duas poses de voo; reprodução, seleção, pausa/avanço, inversão e escala da comparação exercitados com DOM/canvas simulados. Não houve validação em navegador real nem no motor nesta etapa.

## Prompt utilizado

Use case: identity-preserve. Asset: 8-frame in-place RUN CYCLE sprite sheet for the 2D football platformer FORA DE CAMPO. Input is the strict approved Cristiano Ronaldo character design: keep exact recognizable realistic face, short swept dark hair, athletic adult build, red Portugal jersey with green trim and white 7, green shorts with white 7, red socks, small gold shoulder/forearm/shin armor, gold football boots, short red cape with gold edging. Same detailed crisp pixel-art style and proportions, no redesign. One sheet EXACTLY 4 columns and 2 rows, eight equal invisible cells read left-to-right top row then bottom row. Every cell ONE full-body right-facing SIDE PROFILE Cristiano in a DIFFERENT phase of the SAME seamless running cycle. Run in place, pelvis horizontally at same anchor, fixed camera and scale. Lean forward slightly like an elite footballer sprinting, gaze focused to right, restrained vertical bounce, counter-swing bent elbows. Exactly 2 arms and 2 legs throughout. NO BALL. Cape trails LEFT with small delayed rhythmic flutter, fully within cell.
Frames 1-4 first half stride, 5-8 opposite legs:
1 near leg forward heel contacting common ground line, far leg extended backward with toe leaving ground, far arm forward near arm back.
2 near leg bears weight with knee flexion, far knee recovering forward, body lowers slightly.
3 near leg pushes backward, far knee passes forward at hip, torso returns mid-height.
4 airborne flight: far knee forward high, near leg folded back, both boots slightly above ground, opposite arms.
5 far leg forward heel contacting same ground, near leg extended backward, arms opposite frame1.
6 far leg bears weight with knee flexion, near knee recovering.
7 far leg pushes backward, near knee passes forward.
8 airborne flight: near knee forward, far leg folded back; leads smoothly to frame1.
Clear alternating legs, natural foot arcs, no eight identical poses, no stiff march. Consistent head dimensions, upper body proportions and armor throughout. Allow 1-2 native pixels of head bob, don't resize figures to fit each cell. All grounded frames use same ground baseline; flight frames have deliberate small clearance, not giant jumps. Leave generous safe space above head and left of cape and in front of extended boots. True transparent alpha background, NO halo, gradients, shadows, floor, scenic background, title, text, labels or grid. Deliver one coherent eight-pose sheet, not a storyboard or portraits.

