# Haaland — capa de pele e porte maior (v2)

Pedido do usuário: acrescentar capa de pele em estilo viking e fazer Haaland mais alto no jogo que Mbappé e Cristiano. Edição feita com a ferramenta integrada de imagens a partir de `haaland-v1.png`, preservada. Nova referência: `haaland-com-capa-v2.png`.

Capa de pele cinza/marrom presa nos ombros, com fechos metálicos e comprimento próximo dos joelhos; sem esconder rosto, camisa 9, calção, braços ou chuteiras. Rosto, cabelo loiro preso, uniforme da Noruega e armadura mantidos como identidade. Nada de capacete, arma ou animal inteiro.

## Altura para integrar

Definição aprovada: Haaland com aproximadamente 20% mais altura visual que as poses eretas dos outros dois (referência de 116 px para cerca de 139 px). Ajustar pela altura real do corpo após recorte, mantendo proporção de cabeça e membros, mesma sola no chão e volume maior. A futura colisão deve acompanhar o corpo mais alto, sem incluir a capa. Não ampliar o nó raiz indiscriminadamente, pois isso também mudaria alcance, efeitos e movimento de maneiras indesejadas.

`previa-alturas.html` mostra as três referências recortadas por seus limites alpha na mesma linha de chão, com altura ajustável de 10% a 30% maior; inicia em 20%. Esse controle não grava alterações nem modifica o jogo. Integração concluída posteriormente em `../animacoes/haaland/INTEGRACAO.md`. Guardar essa escala ao produzir outras animações futuras, calibrando em relação às poses eretas, não ao quadro abaixado de uma passada.

## Verificação

PNG 1024×1536 com alpha; canto transparente. Limites visíveis (alpha >= 128): x=208..906, y=76..1486. A imagem foi inspecionada na saída do gerador. Comparação usa apenas recorte e renderização no navegador, sem editar as imagens originais. A prévia foi exercitada com DOM/canvas simulados; não houve conferência em navegador real nesta etapa.

## Prompt utilizado

Use case: identity-preserve. Edit the approved Haaland reference with ONE addition: a VIKING-INSPIRED FUR CAPE. Preserve exactly the existing recognizable Erling Haaland face, blond hair tied in bun, expression, body proportions, pose, red Norway number9 jersey, white shorts with9, navy socks, gunmetal shoulder/forearm/shin armor and dark football boots. Add a heavy but SHORT wolf-grey/brown faux-fur mantle and cape attached behind the existing shoulder armor with discreet metal clasps. Thick shaggy textured fur collar rests behind shoulders without covering face, neckline, Norway crest or chest number9. Cape drapes down BACK toward the RIGHT (character faces LEFT), ending around upper-thigh or knee level, with readable chunky pixel-art tufts and dark neutral grey/brown tones, subtly lighter tips. Keep both hands, shorts number9, legs and boots fully visible, no fur on bare arms or legs. Same detailed crisp pixel art, not photorealistic hair or painted blur. No animal face, paws, skull, trophy, horns, helmet, weapon or shield. This is the SAME footballer design with a fur cape, not a new Viking costume. Full body unclipped with room for cape behind. TRUE transparent alpha background, clean cutout, no glow, halo, floor, vignette or shadow. No labels, title or extra figures. The character will be displayed taller in the game via scale later; do not stretch his anatomy or enlarge his head in this reference.

