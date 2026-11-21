# VAR-01 — A Decisão Final: referência v1

Integração funcional posterior em `../animacoes/var-01/INTEGRACAO.md`: laser desviável, cancelamento pela bola e onda de choque. Usa esta pose com efeitos separados; animações dedicadas ainda pendentes. As observações seguintes registram a análise anterior à integração.

Primeira referência de aparência para o chefão final em `var-01-v1.png`, criada com a ferramenta integrada imagegen. Nenhuma cena ou script de gameplay foi alterado nesta etapa. O jogo ainda usa a arte anterior do chefão até a futura integração.

## Identidade visual e enunciado

Torso formado por um grande cartão vermelho vertical de cantos arredondados, com moldura metálica e detalhes dourados, braços e pernas mecânicos ligados à estrutura. Monitor de revisão como cabeça, olho digital vermelho, câmeras e antenas nas costas, punhos grandes e chuteiras metálicas. Preto, vermelho, cinza metálico e dourado. O cartão ocupa o centro da silhueta e não é apenas um pequeno emblema, para manter legível a exigência de chefão cartão vermelho com braços e pernas.

Referência em três quartos orientada à esquerda, preservando a face larga do cartão. Ao produzir animações, manter monitor/cartão na mesma perspectiva e âncora dos pés consistente. Distingue-se do Impedimento, cuja identidade é visor estreito e bandeira amarela/laranja. Não leva bandeira, capa ou rosto humano.

Imagem inspecionada na saída do gerador, salva no projeto e amostras externas transparentes conferidas. Pequenos resíduos de contorno podem existir; conferir durante exportação das animações.

## Estrutura existente verificada

`cena_chefao.tscn` já usa CharacterBody2D, gravidade, RectangleShape2D de 89×196, AnimationPlayer, Timer de 4 s e VisibleOnScreenNotifier2D. `script_chefao.gd` oferece avanço, parada, ataque e retorno ao avanço. Animação parada dura 1,2 s e chama atacar; ataque dura 0,8 s, chama dano aos 0,6 s e retoma avanço aos 0,8 s. A movimentação atual é 300 px/s e a gravidade soma 20 por atualização. São valores existentes, não novos valores de balanceamento aprovados.

Componente Resistencia tem seis vidas, som de dano e abre_portao=true. A derrota já abre o portão. `script_encontro_impedimento.gd` mantém o chefe aguardando sem ataques/camada atingível até a derrota do guardião, e depois restaura processamento e camada, respeitando a presença na tela. Preservar nome/caminho Chefao/Chefao para manter essa integração e as verificações existentes.

## Adaptação com escopo controlado

Prioridade: Decisão Final, golpe de punho no chão com aviso e recuperação, aproveitando o ciclo de ataque já existente. Mostrar onda de choque como efeito separado e limitar dano ao alcance real do ataque. Atenção: o dano atual atinge o jogador se estiver no chão e o chefe na tela, sem teste de distância; não apresentar efeito local mantendo dano invisível em toda a tela. Na integração, verificar alcance e aplicar dano uma vez por golpe.

Revisão de Campo (raio horizontal vermelho) pode usar uma variante dos projéteis inimigos, com aviso, direção capturada e remoção em terreno. É uma segunda prioridade, não precisa ser implementada junto da primeira animação.

Impedimento (faixa no chão com descarga atrasada) fica opcional: exige área de aviso e temporização adicionais e não é necessário para concluir o chefão. Para evitar confusão com o guardião chamado Impedimento, considerar futuramente chamar esse ataque de Linha de Revisão; ainda não foi renomeado nem implementado.

Preservar movimentação básica, colisões, resistência, abertura do portão e sequência do confronto. Não criar fase, arena ou sistema novo. O chefe deve continuar visivelmente sendo um cartão vermelho com membros.

## Próxima etapa

Criar folhas de avanço e preparação/impacto do golpe Decisão Final, depois prévia HTML de animação antes de substituir sprites na fase. Tamanho final deve ser calibrado no cenário existente, respeitando o corpo e a passagem; não alterar colisão automaticamente pelo tamanho da imagem original.

## Prompt utilizado — ferramenta integrada imagegen

Use case: stylized-concept. Asset: ONE full-body original final boss design reference for VAR-01: A DECISÃO FINAL, in detailed pixel art football platformer FORA DE CAMPO. Clearly recognizable as a FOOTBALL VAR machine and an ANTHROPOMORPHIC RED CARD WITH ARMS AND LEGS. Primary torso is a LARGE UPRIGHT SOLID RED REFEREE CARD, tall rectangular shape with subtly rounded corners, much of its flat red front visibly unobstructed, framed by a slim dark metal support with restrained GOLD edge details. The RED CARD IS THE ACTUAL CENTRAL BODY, not a tiny badge or small chest emblem on ordinary robot armor. Two powerful black/gunmetal mechanical arms connect at card's upper sides, large articulated metal fists. Two sturdy robotic legs connect at its lower corners, ending in metallic football boots with visible studs. Head is a recognizable rectangular VAR VIDEO REVIEW MONITOR above the card, thick black bezel, single RED DIGITAL EYE on dark screen. Small video cameras and short antennas mounted on a compact BACK rack behind shoulders, recognizably sports review equipment. Palettes: dominant vivid red torso, BLACK support and limbs, metallic GREY articulated parts, small GOLD details, red digital eye only emissive pixels no outer glow. Distinguish from slim assistant referee guard: heavier square body, big fists, monitor head, RED CARD core, NO yellow/orange flag or cape. Rigid imposing ready stance, knees subtly bent, one heavy fist slightly forward and other lowered ready for ground slam. SINGLE complete full-body NEAR SIDE VIEW FACING LEFT, enough three-quarter torso angle to show unmistakable large rectangular red card FRONT without losing side-scroller readability. No human face or real-person likeness. Detailed crisp PIXEL ART, discrete pixel clusters, dark contours, controlled metal shading, same visual world as armored football sprites, not chibi, 3D, vector or smooth painting. Full monitor,cameras,hands and boots inside comfortable margins. TRUE TRANSPARENT ALPHA background: all exterior pixels fully alpha0, no haze, floor, shadow, glow halo, gradients, vignette, labels, title, lettering, watermark, projectiles or other characters. One pose only, not animation sheet.
