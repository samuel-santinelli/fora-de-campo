# Neymar — O Driblador: referência v1

Primeira referência visual em `neymar-v1.png`, gerada pela ferramenta integrada imagegen. Mbappé usado apenas como referência de estilo e mundo, sem copiar rosto ou uniforme. Integração posterior ao jogo registrada em `../animacoes/neymar/INTEGRACAO.md`.

## Direção visual

Neymar com cabelo curto cacheado de pontas claras, barba curta, tatuagens, camisa amarela do Brasil número 10, calção azul, meias brancas, chuteiras verdes e proteções leves de metal escuro com detalhes verdes. Sem capa e sem armadura pesada. Postura flexionada pronta para mudar de direção. Porte semelhante ao de Cristiano e Mbappé; o aumento de 20% é exclusivo de Haaland. A pose de referência é parcialmente em três quartos e deverá ser estabilizada para perfil e âncora consistentes na animação.

PNG 1024×1536; imagem inspecionada na saída do gerador. Cantos e amostras externas alpha zero. A visualização do gerador pode mostrar RGB residual em áreas transparentes. Conferir contorno durante exportação, sem afirmar que toda a borda foi limpa nesta etapa.

## Estrutura disponível e adaptação proposta

`script_inimigo2.gd` fornece corpo, gravidade, colisão e contato. As variantes `script_mbappe.gd` e `script_haaland.gd` mostram perseguição terrestre com ativação por tela e animação por quadros. Para Neymar, reaproveitar essa estrutura com um ciclo curto e legível de avanço, recuo/finta e recuperação, sem navegação nova ou esquiva automática perfeita.

`script_inimigo1.gd` já instancia projéteis pelo Marker2D e direciona o disparo. `cena_cartao.tscn` e `script_cartao.gd` fornecem movimento horizontal e dano por Area2D. Uma variante futura de bola inimiga pode reutilizar esse contato/dano e trocar visual e movimento; não usar diretamente a bola do jogador, que causa dano em inimigos. A trajetória atual do cartão é reta (velocity.y = 0): qualquer arco ou quique exigirá pequena adaptação explícita na variante, preservando o cartão da arbitragem. Começar com um chute simples com aviso; trajetórias extras só se trouxerem ganho claro.

Resistencia já permite configurar vida e usar carrinho/bola atuais. Preservar juiz atirador de cartões, goleiro perseguidor com salto, rivais existentes e chefão. Neymar é rival adicional, não substitui os inimigos obrigatórios.

Ciclo de movimentação/finta preparado posteriormente em `../animacoes/neymar/previa-movimento.html`, com detalhes e prompts em `../animacoes/neymar/MOVIMENTO-v1.md`. Próxima etapa após revisar a prévia: integração do comportamento e chute. Nenhum script de gameplay ou cena alterado nesta etapa de arte.

## Prompt utilizado — ferramenta integrada

Use case: stylized-concept. Asset: ONE full-body character design reference for NEYMAR — O DRIBLADOR in existing 2D football platform game FORA DE CAMPO. Input image Mbappe is ONLY a reference for world, detailed pixel-art rendering, scale language and light sports armor; do NOT copy his face, haircut, uniform or pose. Create a clearly recognizable adult Neymar Jr: lean agile athletic Brazilian footballer, tan skin, characteristic narrow angular face and expressive brows, short curly dark hair with subtle bleached tips and faded sides, neatly trimmed short beard and mustache, small ear stud, restrained visible tattoo details on exposed forearms. Confident playful focused expression, no exaggerated caricature. Brazil traditional YELLOW number 10 football jersey with GREEN collar and cuffs, BLUE shorts with small white number 10, WHITE socks with green trim, vivid GREEN football boots. Small lightweight dark-metal forearm and shin guards with emerald accents; no heavy shoulder armor, no cape, no helmet, no weapon. Keep football identity and bare arms visible, agile slimmer silhouette than Haaland, same adult proportions as reference. SINGLE FULL BODY SIDE VIEW FACING LEFT, ready-to-feint stance: knees slightly bent, weight shifted onto rear leg, front foot poised to change direction, relaxed bent arms balancing torso. Maintain readable face profile, hands and boots, nothing cropped. Detailed crisp pixel art, discrete pixel clusters, dark contours, limited shaded palette, realistic recognizable face translated to pixel art, NOT photorealistic photo, smooth painting, vector, 3D or chibi. Transparent alpha background; every pixel outside character fully transparent. NO gradient, haze, glow, shadows, floor, platform, ball, labels, title, animation sheet or watermark. A clean isolated character reference with generous empty margins.
