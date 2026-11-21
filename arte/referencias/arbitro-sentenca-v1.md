# Sentença — O Árbitro de Ferro: referência v1

Integração posterior concluída: `../animacoes/obrigatorios/INTEGRACAO.md`, com disparos alternados de cartões amarelos e vermelhos. Pendências abaixo registram a etapa da referência.

Animação de lançamento preparada posteriormente em `../animacoes/obrigatorios/previa-goleiro-arbitragem.html`; detalhes/prompts em `../animacoes/obrigatorios/ANIMACOES-v1.md`. Disparo real com novo visual e integração na fase ainda pendentes.

`arbitro-sentenca-v1.png`: árbitro humano original, uniforme magenta/preto, apito e comunicador, cabelo escuro grisalho nas têmporas, proteções prateadas e cartões amarelo/vermelho visíveis. Rosto original e postura rígida. Distingue-se do goleiro e do Impedimento robótico com bandeira. Nome e aparência são propostas de design para a adaptação solicitada.

## Reaproveitamento verificado

`cena_inimigo1.tscn` e `script_inimigo1.gd` já oferecem corpo, gravidade, detecção do jogador pelo RayCast, direção, Marker2D para disparo, AnimationPlayer parado/atirando e Resistencia. `atirar_cartao` instancia `cena_cartao.tscn`, que usa `script_cartao.gd` para movimento horizontal e dano por Area2D. Manter a arbitragem atirando cartões, não trocar por bola nem por sinalizador.

Próximas animações: espera com apito, gesto de advertência e lançamento de cartão. Durante integração, tornar amarelo e vermelho claramente legíveis no projétil e verificar a alternância/apresentação de ambos, preservando trajetória e dano. A nova referência mostra ambas as cores, mas isso não significa que o disparo já foi adaptado. Não alterar script_cartao de forma que desconfigure as variantes de Neymar/Impedimento.


## Estado e integração futura

Referência criada com ferramenta integrada imagegen, inspecionada na saída e salva no projeto. Amostras externas transparentes conferidas; resíduos coloridos de borda podem precisar de limpeza na preparação das folhas. Sem nova fase nem sistema complexo. Esta etapa não altera cenas, scripts, colisões ou gameplay; os personagens antigos continuam na fase até a integração das animações.

## Prompt utilizado — ferramenta integrada imagegen

Use case: stylized-concept. ONE full-body original human FOOTBALL REFEREE enemy design for detailed pixel-art platformer FORA DE CAMPO. Original middle-aged adult man not a real person: olive skin, short dark swept-back hair greying at temples, long angular face, clean-shaven, stern focused expression. Lean upright adult athletic proportions, not chibi. Clearly identifiable referee: rich MAGENTA short-sleeve referee shirt with BLACK collar, chest pockets, BLACK shorts, black knee-high socks and black football boots. Silver-grey compact forearm and shin guards with restrained magenta details, no bulky shoulder armor or cape. Small referee headset with microphone, whistle at neck. Near-side profile facing LEFT, slightly turned chest readable, planted ready stance, forward hand raised holding ONE plain rectangular YELLOW CARD, other hand near waist holding ONE plain rectangular RED CARD, both cards large and clearly visible, only two arms and five fingers per hand. These are actual referee cards, not weapons, flags or magical tablets. Detailed crisp PIXEL ART with discrete clusters, clean dark outlines and limited nuanced shading, realistic original adult face translated to pixel art, coherent with armored football sprites, no photo/3D/vector/smooth painting. Full body, both card corners, hands and boots entirely inside generous margins. TRUE alpha0 transparent background outside figure, no floor/shadow/glow/haze/gradient or colored matte. No text labels,title,logos,watermark,ball or other figures. Single pose only, not animation sheet. Keep referee uniform and cards readable, distinguish from black/silver robot with orange flag.
