# Derrotas dos rivais e identidade sonora — 20/11/2026

Sete folhas novas geradas pela ferramenta integrada imagegen, usando as artes aprovadas como referências de identidade. Arquivos `muralha-v1.png`, `sentenca-v1.png`, `neymar-v1.png`, `mbappe-v1.png`, `haaland-v1.png`, `impedimento-v1.png` e `var-01-v1.png`, nesta pasta. Cada folha tem seis quadros de 512×512, em grade 3×2 com alpha. As referências existentes foram preservadas.

O golpe fatal remove o corpo de combate e cria uma animação visual sem colisões. Mantém direção, altura, pausa e queda até o piso quando atingido no ar. Os rivais levam entre 1,15 e 1,7 segundos para cair e desaparecer. O VAR-01 leva 3,8 segundos: pane, oscilação, faíscas, joelhos no chão e monitor apagado. Só ao terminar sua sequência o portão inicia a abertura. Sair da fase elimina os efeitos sem abrir portões de outra partida. Nenhuma alteração de velocidade global ou pausa do áudio.

Prévia: `previa-derrotas.html`. Integração: `script_derrota_inimigo.gd` e `script_resistencia_inimigo.gd` na raiz.

## Áudio

A auditoria encontrou MP3s herdados do professor nos eventos de pulo, carrinho, chute, dano e coleta. As referências em uso foram substituídas por WAVs originais produzidos por `verificacoes/gerar_sons_combate.cjs`: pulo-cr7, carrinho-cr7, chute-cr7, dano-cr7, dano-rival, dano-tanque, dano-metal, coleta-campo, queda-rival, queda-tanque, desligamento-robo e colapso-var. Síntese determinística, mono PCM 16 bits a 22050 Hz, envelopes de entrada/saída, sem loops ou gravações externas. MP3s antigos permanecem no acervo, sem uso nas cenas/scripts atuais. As cinco músicas e os oito efeitos originais anteriores foram preservados. Não há imitação de voz dos jogadores.

Áudio permanece no bus Efeitos, separado de Musica, com ganho reduzido no chute/dano do jogador. Preservadas as correções de áudio Web e confirmação de interação inicial. Prévia sonora: `arte/audio/previa-sons.html`.

## Prompts utilizados

Validação final: 36 verificações Godot passaram, incluindo derrotas, resistência, chute, guardião, vitória, pausa, interface e áudio. O teste das sete derrotas também passou carregando o PCK Web exportado, sem depender dos recursos do projeto-fonte. Roteamento JavaScript de áudio validado novamente. Os testes são automáticos em modo headless; ritmo visual e escuta no navegador devem ser conferidos em uma partida.

As imagens não foram recortadas nem repintadas por código. `verificacoes/medir_quadros_derrota.ps1` apenas mede limites de alpha e grava `script_limites_derrotas.gd`; o sprite ajusta a âncora e escala em runtime. Haaland usa altura de referência 138, contra 115 de Neymar/Mbappé (20% maior).

Pacotes atualizados: Web 55.259.616 bytes; Windows 83.090.284 bytes. Ambos usam 164 recursos selecionados por dependências. Os tamanhos e hashes atuais estão em `entrega/pacotes.json`.

### muralha

Referência: `arte/animacoes/obrigatorios/salto-v1-alinhado.png`.

```text
Use case: stylized-concept / game sprite animation. Reference image is ONLY identity and pixel-art style reference, do not copy its sheet layout. Generate a NEW transparent PNG death/DEFEAT animation sprite sheet of precisely this approved character, preserve face outfit colors proportions and detailed crisp pixel art. Exact teal goalkeeper number 1, dark curly hair, large white teal gloves, dark armor knees and boots. All poses facing LEFT. Six consecutive clearly DIFFERENT poses in this order: reels backward with gloves up; knees buckle; one knee and glove touch floor; sits heavily; slumps onto side; remains defeated on side with gloves near chest. Full-body game view, non-gory cartoon sport defeat, no wounds. EXACT canvas 1536x1024, 3 columns by 2 rows, SIX equally sized 512x512 cells, read left to right then second row. Ground baseline y480 in EACH cell; same body size throughout, standing height about 400px; body centered x256. Fallen pose stays fully inside cell, shrink the entire consistent six-frame character scale slightly if necessary to fit horizontal body, NEVER crop or overlap cells. Keep transparent gutters. Flat side view consistent camera. Actual alpha transparency, no background, NO floor or floor shadow, no text, no labels, no grid, no opponent, no new outfit, no effects obscuring silhouette. Deliberate strong game animation silhouettes, detailed clustered pixels matching supplied reference.
```

### sentenca

Referência: `arte/animacoes/obrigatorios/lancamento-v1-alinhado.png`.

```text
Use case: stylized-concept / game sprite animation. Reference image is ONLY identity and pixel-art style reference, do not copy its sheet layout. Generate a NEW transparent PNG death/DEFEAT animation sprite sheet of precisely this approved character, preserve face outfit colors proportions and detailed crisp pixel art. Exact magenta pink referee shirt, black shorts, grey black armored shin guards, brown slick short hair, whistle and yellow card. All poses facing LEFT. Six consecutive clearly DIFFERENT poses in this order: startled recoil holding yellow card; drops card as knees buckle; kneels; braces hand on ground; falls sitting sideways; slumped seated with head down, yellow card beside hand. Full-body game view, non-gory cartoon sport defeat, no wounds. EXACT canvas 1536x1024, 3 columns by 2 rows, SIX equally sized 512x512 cells, read left to right then second row. Ground baseline y480 in EACH cell; same body size throughout, standing height about 400px; body centered x256. Fallen pose stays fully inside cell, shrink the entire consistent six-frame character scale slightly if necessary to fit horizontal body, NEVER crop or overlap cells. Keep transparent gutters. Flat side view consistent camera. Actual alpha transparency, no background, NO floor or floor shadow, no text, no labels, no grid, no opponent, no new outfit, no effects obscuring silhouette. Deliberate strong game animation silhouettes, detailed clustered pixels matching supplied reference.
```

### neymar

Referência: `arte/animacoes/neymar/parado-v1.png`.

```text
Use case: stylized-concept / game sprite animation. Reference image is ONLY identity and pixel-art style reference, do not copy its sheet layout. Generate a NEW transparent PNG death/DEFEAT animation sprite sheet of precisely this approved character, preserve face outfit colors proportions and detailed crisp pixel art. Exact Neymar Brazil yellow jersey 10 blue shorts white socks green boots and tattooed arms brown short hair beard. All poses facing LEFT. Six consecutive clearly DIFFERENT poses in this order: loses balance after failed feint; twists and staggers; one knee down; hands brace ground; rolls onto hip; sits defeated clutching shin, head lowered. Full-body game view, non-gory cartoon sport defeat, no wounds. EXACT canvas 1536x1024, 3 columns by 2 rows, SIX equally sized 512x512 cells, read left to right then second row. Ground baseline y480 in EACH cell; same body size throughout, standing height about 400px; body centered x256. Fallen pose stays fully inside cell, shrink the entire consistent six-frame character scale slightly if necessary to fit horizontal body, NEVER crop or overlap cells. Keep transparent gutters. Flat side view consistent camera. Actual alpha transparency, no background, NO floor or floor shadow, no text, no labels, no grid, no opponent, no new outfit, no effects obscuring silhouette. Deliberate strong game animation silhouettes, detailed clustered pixels matching supplied reference.
```

### mbappe

Referência: `arte/animacoes/mbappe/parado-v1.png`.

```text
Use case: stylized-concept / game sprite animation. Reference image is ONLY identity and pixel-art style reference, do not copy its sheet layout. Generate a NEW transparent PNG death/DEFEAT animation sprite sheet of precisely this approved character, preserve face outfit colors proportions and detailed crisp pixel art. Exact Mbappe France navy number 10 white shorts red socks blue boots wrist and shin armor, dark short hair. All poses facing LEFT. Six consecutive clearly DIFFERENT poses in this order: abruptly brakes from sprint; skids leaning backwards; foot slips; lands on hip; slides with palm braced behind; sits defeated on floor leaning forward head lowered. Full-body game view, non-gory cartoon sport defeat, no wounds. EXACT canvas 1536x1024, 3 columns by 2 rows, SIX equally sized 512x512 cells, read left to right then second row. Ground baseline y480 in EACH cell; same body size throughout, standing height about 400px; body centered x256. Fallen pose stays fully inside cell, shrink the entire consistent six-frame character scale slightly if necessary to fit horizontal body, NEVER crop or overlap cells. Keep transparent gutters. Flat side view consistent camera. Actual alpha transparency, no background, NO floor or floor shadow, no text, no labels, no grid, no opponent, no new outfit, no effects obscuring silhouette. Deliberate strong game animation silhouettes, detailed clustered pixels matching supplied reference.
```

### haaland

Referência: `arte/animacoes/haaland/parado-v1.png`.

```text
Use case: stylized-concept / game sprite animation. Reference image is ONLY identity and pixel-art style reference, do not copy its sheet layout. Generate a NEW transparent PNG death/DEFEAT animation sprite sheet of precisely this approved character, preserve face outfit colors proportions and detailed crisp pixel art. Exact Haaland red Norway 9 light grey shorts black armor huge shaggy dark brown Viking fur cape blond bun navy boots. All poses facing LEFT. Six consecutive clearly DIFFERENT poses in this order: absorbs blow standing braced; staggers deeply with cape swinging; drops to one knee; both knees grounded hand on floor; topples onto hip; collapses on side with fur cape spread behind, head lowered. Full-body game view, non-gory cartoon sport defeat, no wounds. EXACT canvas 1536x1024, 3 columns by 2 rows, SIX equally sized 512x512 cells, read left to right then second row. Ground baseline y480 in EACH cell; same body size throughout, standing height about 400px; body centered x256. Fallen pose stays fully inside cell, shrink the entire consistent six-frame character scale slightly if necessary to fit horizontal body, NEVER crop or overlap cells. Keep transparent gutters. Flat side view consistent camera. Actual alpha transparency, no background, NO floor or floor shadow, no text, no labels, no grid, no opponent, no new outfit, no effects obscuring silhouette. Deliberate strong game animation silhouettes, detailed clustered pixels matching supplied reference.
```

### impedimento

Referência: `arte/animacoes/impedimento/parado-v1.png`.

```text
Use case: stylized-concept / game sprite animation. Reference image is ONLY identity and pixel-art style reference, do not copy its sheet layout. Generate a NEW transparent PNG death/DEFEAT animation sprite sheet of precisely this approved character, preserve face outfit colors proportions and detailed crisp pixel art. Exact silver black armored robotic linesman, yellow slit visor, orange yellow checkered linesman flag in hand. All poses facing LEFT. Six consecutive clearly DIFFERENT poses in this order: robot glitches upright; visor flickers arms sag; knees buckle flag drops lower; one knee down; falls seated; lies powered off on side with lowered flag. Full-body game view, non-gory cartoon sport defeat, no wounds. EXACT canvas 1536x1024, 3 columns by 2 rows, SIX equally sized 512x512 cells, read left to right then second row. Ground baseline y480 in EACH cell; same body size throughout, standing height about 400px; body centered x256. Fallen pose stays fully inside cell, shrink the entire consistent six-frame character scale slightly if necessary to fit horizontal body, NEVER crop or overlap cells. Keep transparent gutters. Flat side view consistent camera. Actual alpha transparency, no background, NO floor or floor shadow, no text, no labels, no grid, no opponent, no new outfit, no effects obscuring silhouette. Deliberate strong game animation silhouettes, detailed clustered pixels matching supplied reference.
```

### var-01

Referência: `arte/animacoes/var-01/parado-v1.png`.

```text
Use case: stylized-concept / game sprite animation. Reference image is ONLY identity and pixel-art style reference, do not copy its sheet layout. Generate a NEW transparent PNG death/DEFEAT animation sprite sheet of precisely this approved character, preserve face outfit colors proportions and detailed crisp pixel art. Exact VAR-01 black grey humanoid robot with huge RED CARD chest gold trim, monitor head red single digital eye, cameras antennas, huge hands and metal football boots. All poses facing LEFT. Six consecutive clearly DIFFERENT poses in this order: eye flickers and arms tense; head jerks down with small red sparks; chest light cracks red and knees buckle; drops heavily to both knees monitor dim; falls onto one forearm; collapsed powered off on side, black monitor eye completely OFF and chest dark crimson. No explosion destroying identity. Full-body game view, non-gory cartoon sport defeat, no wounds. EXACT canvas 1536x1024, 3 columns by 2 rows, SIX equally sized 512x512 cells, read left to right then second row. Ground baseline y480 in EACH cell; same body size throughout, standing height about 400px; body centered x256. Fallen pose stays fully inside cell, shrink the entire consistent six-frame character scale slightly if necessary to fit horizontal body, NEVER crop or overlap cells. Keep transparent gutters. Flat side view consistent camera. Actual alpha transparency, no background, NO floor or floor shadow, no text, no labels, no grid, no opponent, no new outfit, no effects obscuring silhouette. Deliberate strong game animation silhouettes, detailed clustered pixels matching supplied reference.
```

