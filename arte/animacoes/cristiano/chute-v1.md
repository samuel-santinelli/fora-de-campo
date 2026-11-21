# Chute de Energia — v1

Gerado com a ferramenta integrada de imagens usando `cristiano-pose-base-v2.png` como referência de identidade. Oito poses de preparação, balanço, contato, finalização e recuperação. Segunda passagem de edição para reduzir contaminação das bordas, preservando as poses. Pequenos resíduos de contorno e diferenças entre quadros ainda merecem revisão.

## Prévia

Abrir `previa-chute.html`. Usa a bola original `../../../Bola.png`, sem alterá-la, com rotação, partículas douradas, rastro, clarão de contato e impacto. Todos esses efeitos são desenhados separadamente no canvas; não fazem parte da folha. Alvo da prévia é apenas um marcador para visualizar impacto. Começa em meia velocidade. Controle por quadro, reinício, direção, escala e efeitos/bola ligados ou desligados.

Ação de 600 ms, tempos por quadro: 80,90,90,80,60,70,70,60 ms. Contato e disparo aos 340 ms, no início do quadro 5. A bola continua em percurso depois da recuperação, até um impacto ilustrativo aos 1040 ms. A trajetória, o tamanho da bola e o alvo são demonstrativos, não uma alteração dos cálculos de colisão ou velocidade no motor. O leve levantamento da bola antes do contato é apenas apresentação da prévia.

## Arquivos e exportação

Fontes `chute-v1.png` e `chute-v1-limpa.png`; folha horizontal `chute-v1-alinhada.png` (3072×256); oito quadros transparentes de 384×256 em `quadros-chute-v1`; metadados em `chute-v1-alinhada.json`.

Reutilizado o exportador existente com a opção `-Animacao chute`, mantendo o comportamento padrão do carrinho. Âncoras da perna de apoio revisadas por quadro, escala comum 0,5 e apoio no chão. Reexportar: `powershell -NoProfile -ExecutionPolicy Bypass -File ./arte/animacoes/cristiano/preparar-carrinho.ps1 -Animacao chute`.

## Integração futura

Nenhum script GDScript ou cena foi modificado nesta etapa. Reaproveitar `cena_bola.tscn`, `script_bola.gd` e o método `spawnar_bolar`. Para sincronizar com a arte, mover a chamada existente na trilha de animação de 600 para 340 ms e conferir a posição do Marker2D junto à chuteira; manter um único disparo por animação. Os efeitos devem acompanhar a direção e congelar com pausa. Não criar outro sistema de projéteis.

Antes de integrar, comparar rosto, armadura, tamanho do corpo, balanço da perna e retorno à espera no HTML. Amunição limitada e coletáveis continuam pendências do projeto maior.

## Verificação

Inspeção visual da folha exportada; oito recortes não vazios e destinos dentro das células. JavaScript executado com DOM/canvas simulados: dimensões reais dos PNGs e caminho da bola original, reprodução, quadro de contato, seleção/avanço, reinício, efeitos/bola desligados, direção e escala; metadados totalizam 600 ms. Não foi testado em navegador real nesta etapa.

## Prompt de criação

Use case: identity-preserve. Create an eight-frame POWER FOOTBALL KICK sprite sheet for the 2D platformer FORA DE CAMPO. Supplied image is the strict character appearance reference: SAME realistic recognizable Cristiano Ronaldo face, swept short dark hair, athletic adult anatomy, red Portugal number 7 jersey with green trim, green shorts with 7, red socks, light gold shoulder/forearm/shin armor, gold football boots and short red/gold cape. Detailed crisp pixel art, same proportions and shading, no chibi or painted photorealism.
EXACTLY EIGHT complete full-body poses, FOUR COLUMNS and TWO ROWS, identical cell sizes and body scale, fixed SIDE VIEW facing RIGHT, separated figures with generous safe margins. The left supporting foot stays on the same ground line and same relative position; near/right leg performs a realistic powerful instep kick to the RIGHT. Stable face identity in all poses. This is a grounded football shot, NOT martial arts high kick or bicycle kick.
1 preparation: weight over supporting left leg, near right foot slightly behind, torso tilted slightly forward, open hands balancing.
2 backswing: right knee flexes, right boot swings behind toward left, supporting knee soft, chest rotates subtly, open hands spread.
3 maximum backswing: right heel folded behind, left foot planted, arms counterbalance, cape lags behind left shoulder.
4 forward swing: right knee comes past supporting knee, lower leg extending forward toward imaginary ball at ankle-to-shin height.
5 CONTACT: right instep extends forward low, ankle locked with toes pointing forward/down, supporting left foot firmly planted, open hands balance, face focused at shot.
6 follow-through: right leg rises only to around knee/hip height, torso rotates slightly, cape follows, not a high martial arts kick.
7 recovery: right knee bends and boot descends toward ground, arms relax, maintain balance over planted left foot.
8 return to approved neutral right-facing standing pose and cape settling.
Exactly two arms and two legs, no duplicated boots, believable joint motion. Cape cannot cover foot contact area or face. Draw ONLY character poses: NO BALL, no glow, no trails, no burst, no dust, no floor or shadows, no text, labels or grid. The real game football and golden energy effects will be composited separately. True clean transparent background, dark pixel outlines, no red matte fringe. No clipped hair, hands, cape or extended boots; no pose encroaches into neighboring cell.

## Prompt de limpeza

Precise cutout cleanup of this eight-frame football KICK sprite sheet. Keep the same eight poses in four columns and two rows, face identity, anatomy, body scale, left supporting foot, moving right leg, hands, Portugal uniform number7, gold armor, boots and red/gold cape unchanged. Remove ONLY bright red/orange/yellow matte contamination outside dark character outlines and between limbs. Empty space should be clean transparent alpha, no aura, no glow, no jagged red fringe, no floating pixels. Preserve actual red/gold fabric and metal inside silhouette. No ball, no effects, ground, shadows, labels or grid. Do not redesign, change facial expression, alter layout, rescale individual figures or crop any part of the character.

