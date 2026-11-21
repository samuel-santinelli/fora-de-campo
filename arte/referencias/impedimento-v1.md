# O Impedimento — O Último Bloqueio: referência v1

Integração posterior concluída em `../animacoes/impedimento/INTEGRACAO.md`. Este documento registra a proposta visual inicial.

Personagem original escolhido pelo usuário para ocupar o confronto especial antes do chefão, substituindo a proposta do Messi. Referência em `impedimento-v1.png`, criada com a ferramenta integrada imagegen. Ainda não há cena nem comportamento integrado para este personagem.

## Visual

Guardião mecânico com corpo humanoide, armadura preta e prata, visor âmbar estreito e chuteiras metálicas. Bandeira de arbitragem com quatro quadrantes alternados amarelos e laranjas integrada por suporte ao antebraço. Sem rosto humano, monitor na cabeça, cartão vermelho ou capa. Perfil voltado à esquerda com tronco parcialmente em três quartos, postura firme e articulações legíveis. Durante animação, manter orientação lateral e âncora do corpo; a bandeira não deve deslocar o centro de colisão.

Imagem inspecionada na saída do gerador e salva com alpha. Cantos e amostras de fundo transparentes conferidos. Há franja colorida em alguns contornos, principalmente no tecido e detalhes amarelos: revisar na preparação das folhas. Esta é uma proposta de aparência para conferir antes das animações, não sprite já pronto para uso na fase.

## Papel e requisitos

Executor das decisões do VAR-01 e guardião do acesso final ao estádio. Novo confronto especial na mesma fase, sem arena ou sistema novo. Mantém juiz que atira cartões, goleiro que salta, rivais já integrados e chefão final. VAR-01 permanece chefe final e deve conservar o cartão vermelho como elemento estrutural legível com braços e pernas para cumprir o enunciado.

Escolha visual distingue guardião por bandeira/amarelo e chefão por cartão vermelho/monitor. O ataque do VAR-01 chamado Impedimento pode futuramente ser renomeado para evitar confusão, mas não precisa de alteração nesta etapa.

## Reaproveitamento verificado

`script_mbappe.gd` já oferece perseguição, aviso, arrancada em direção capturada e recuperação; reutilizar a estrutura, substituindo visual e ajustando ritmo, sem alterar Mbappé. `script_bola_neymar.gd` e sua cena herdam o projétil de arbitragem e já oferecem disparo horizontal, contato com jogador, remoção em paredes e expiração; uma variante visual de sinalizador amarelo pode usar essa base. `script_resistencia_inimigo.gd` permite configurar resistência e clarão/som de dano.

Proposta simples: ergue a bandeira para avisar, avança em linha reta e abre recuperação parada; alterna com sinalizador amarelo de trajetória reta e aviso. Não adicionar navegação, fases ou padrões múltiplos complexos. Não definir vida/velocidade finais antes de verificar espaço e balanceamento do encontro. Portão do estádio continua reservado à derrota do chefão.

Folhas de avanço e aviso preparadas posteriormente, com prévia em `../animacoes/impedimento/previa-confronto.html` e detalhes/prompts em `../animacoes/impedimento/ANIMACOES-v1.md`. Próxima etapa após conferir poses e ritmo: integração do confronto. Nenhum script ou cena de gameplay existente foi alterado nesta etapa de arte.

## Prompt utilizado — ferramenta integrada imagegen

Use case: stylized-concept. Asset: ONE full-body original character reference for O IMPEDIMENTO — O ÚLTIMO BLOQUEIO, a mechanical assistant-referee knight guarding the stadium before final boss in detailed pixel-art football platformer FORA DE CAMPO. An entirely original ROBOT, no human face or likeness. Humanoid athletic mechanical body, slim angular BLACK and brushed SILVER plate armor with visible joints, two mechanical arms and two legs ending in metal football boots with small studs. Compact helmet with a narrow horizontal AMBER visor, no monitor head or camera head. Key identity: one large rectangular assistant-referee flag integrated with a short sturdy mount along the forward LEFT forearm, with clear FOUR LARGE QUADRANTS alternating BRIGHT YELLOW and ORANGE (football linesman's flag, not racing black-and-white checks). The forearm flag held diagonally upward in front of the torso, with elbow and robotic hand still readable; it is the main visual symbol, not a sword or huge shield. Small matching yellow/orange panels on shoulders and knees, but most armor black/silver. No red eye, red card, cape, fur, human skin, hair, gun, sword, monitor, wings or extra limbs. Stern rigid precise posture, knees softly bent, weight ready to dash, opposite hand clenched at hip. SINGLE COMPLETE FULL-BODY PROFILE/near-profile FACING LEFT for a side-scrolling game, head and torso remain oriented left, flag silhouette readable. Natural humanoid proportions, not chibi or bulky giant. Detailed crisp PIXEL ART with discrete pixel clusters, dark contours, controlled palette and metal highlights, consistent with detailed armored footballer sprites; not smooth painting, 3D render, vector or photorealism. Neutral studio-like shading on character only. True TRANSPARENT ALPHA background: all pixels outside character fully transparent, no haze, colored matte, glow, halo, gradient, floor, shadow, platform, labels, title, typography or watermark. Full boots, flag corners and head entirely inside comfortable margins. One pose, not animation sheet.
