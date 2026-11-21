# Muralha — O Guardião da Área: referência v1

Integração posterior concluída: `../animacoes/obrigatorios/INTEGRACAO.md`, com corrida e salto preservado. Pendências mencionadas abaixo registram a etapa da referência.

Animação de salto preparada posteriormente em `../animacoes/obrigatorios/previa-goleiro-arbitragem.html`; detalhes/prompts em `../animacoes/obrigatorios/ANIMACOES-v1.md`. Corrida terrestre e integração na fase ainda pendentes.

`goleiro-muralha-v1.png`: goleiro humano original, uniforme verde-petróleo número 1, luvas acolchoadas grandes, proteções escuras com bordas em cobre e chuteiras pretas/turquesa. Postura baixa para saltar, cabelos curtos cacheados, rosto original. Preserva identidade clara de goleiro sem usar jogador real. Nome e aparência são propostas de design para a adaptação solicitada.

## Reaproveitamento verificado

`cena_inimigo2.tscn` e `script_inimigo2.gd` já oferecem CharacterBody2D, gravidade, perseguição de 300 px/s, salto de força 250 ao detectar Personagem pelo RayCast, AnimationPlayer parado/correndo/atacando, ativação por tela, área de contato e Resistencia. Manter obrigatoriamente perseguição COM SALTO; apenas andar atrás do jogador não atende à opção goleiro do enunciado.

Próximas animações: postura de espera, corrida curta e salto de bloqueio com luvas abertas. Ajustar recortes/âncoras aos pés e preservar ativação e momento de dano existentes. Mbappé, Haaland, Neymar e Impedimento reutilizam a base direta ou indiretamente; não alterar parâmetros/AnimationPlayer de modo que desconfigure suas variantes. Conferir regressões dessas cenas na integração.


## Estado e integração futura

Referência criada com ferramenta integrada imagegen, inspecionada na saída e salva no projeto. Amostras externas transparentes conferidas; resíduos coloridos de borda podem precisar de limpeza na preparação das folhas. Sem nova fase nem sistema complexo. Esta etapa não altera cenas, scripts, colisões ou gameplay; os personagens antigos continuam na fase até a integração das animações.

## Prompt utilizado — ferramenta integrada imagegen

Use case: stylized-concept. ONE full-body original human GOALKEEPER enemy design for detailed pixel-art football platformer FORA DE CAMPO. Name concept Muralha, goalkeeper who pursues by jumping. Original adult face, not a real football celebrity: medium brown skin, short tightly curled black hair, square face, focused expression, clean-shaven. Strong athletic goalkeeper build, believable adult proportions, NOT chibi or giant bodybuilder. TEAL / DEEP PETROL GREEN long-sleeve goalkeeper jersey with small white number1, matching dark teal shorts, teal socks and black football boots with turquoise accents. Large padded goalkeeper GLOVES white/dark-grey with turquoise grips, unmistakable goalkeeper identity. Compact charcoal metal elbow guards, low shoulder caps and shin/knee guards with restrained copper edges, keep most jersey readable, no massive armor or cape. Ready-to-pounce low balanced stance facing LEFT in near side view, knees bent, both oversized gloved hands open in front ready for a save, torso slightly leaning forward. One complete single character with head,fingers,boots entirely inside generous empty margins. Detailed crisp PIXEL ART, discrete pixel clusters, dark clean outlines, nuanced limited shading coherent with armored football heroes, realistic adult face translated into pixel art; no photo, smooth painting, 3D, vector or caricature. TRUE transparent alpha0 background outside figure. NO floor, shadows, haze, gradient, glow, aura, ball, goal, flags, weapons, text labels, title, logos or watermark. One pose only, not animation sheet.
