# Cristiano — pose lateral v2

Gerada com a ferramenta integrada de imagens, editando `cristiano-pose-base-v1.png`. Referência para animação; ainda não integrada ao jogo.

## Verificação

- PNG: 1024 × 1536, com alpha.
- Limites da figura considerando alpha >= 128: x=180..605, y=36..1450.
- Fundo amostrado em (0,0), (100,500), (200,500), (700,500) e (800,900): alpha zero. A prévia da ferramenta mostra cores no fundo que não representam necessariamente pixels opacos.
- Perfil voltado para a direita; uniforme, número 7, armadura e capa preservados como identidade.
- Ainda requer redução e avaliação na escala de jogo; não confundir resolução da referência com resolução nativa de pixel art.

## Convenção proposta para os quadros

Usar como alvo inicial uma célula de 128 × 128 pixels para a animação parado: altura visual aproximada de 116 pixels, sola em y=120 e eixo do corpo em x=76, reservando espaço à esquerda para a capa. Validar na cena antes de aplicar às demais animações. Ataques podem precisar de células mais largas, preservando a mesma escala e âncora dos pés. Não alterar colisões para acompanhar a capa.

## Prompt utilizado

Edit target: supplied Cristiano pixel-art game character. Correct ONLY background cleanup and orientation; preserve approved face, hair, colors, red Portugal number 7 jersey, green shorts, red socks, gold shoulder/forearm/shin armor, gold boots and short red cape with gold trim. Deliver ONE idle full-body SIDE PROFILE game sprite facing RIGHT, with shoulders and pelvis rotated fully sideways (not front or 3/4 torso). Near arm hangs beside torso, far arm mostly occluded; stance narrow with boots slightly staggered horizontally and both soles on same baseline. The shorts number 7 remains visible on near thigh. Cape behind back toward left, upper-thigh length. Maintain athletic adult proportions and detailed but readable crisp pixel clusters, dark pixel outline, no chibi. CRITICAL BACKGROUND CLEANUP: isolate the character as a clean hard-edged cutout on completely TRANSPARENT background. Delete ALL luminous halo, all dark haze, ALL bloom, all floor shadows and glow from the reference. Outside the character silhouette every pixel must be fully transparent, not a dark gradient or semitransparent vignette. No ball, no ground, no atmospheric lighting or detached pixels. Generous transparent margin, full figure uncropped, one pose, no labels or grid. This is a game idle master ready for consistent animation frames.
