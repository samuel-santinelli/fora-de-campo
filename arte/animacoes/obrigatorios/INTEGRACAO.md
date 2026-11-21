# Muralha e Sentença — integração dos obrigatórios

A fase agora instancia `cena_muralha.tscn` e `cena_sentenca.tscn` nos lugares dos antigos Inimigo2 e Inimigo1, preservando nomes, posições e colisões. Variantes herdam as cenas originais. Scripts/cenas base não foram modificados: Mbappé, Haaland, Neymar e Impedimento continuam usando suas bases anteriores.

## Muralha

`script_muralha.gd` estende script_inimigo2 e reutiliza sua perseguição, gravidade, RayCast, movimento e salto de força 250. Aguarda ativação por tela; evita acessar jogador inválido/derrotado. Contato encaminha dano fora do sinal físico para evitar conflito ao interromper animações do jogador.

Corrida em oito novos quadros, gerados pela ferramenta integrada imagegen, em `corrida-v1.png`, exportação `corrida-v1-alinhado.png` e `quadros-corrida-v1/`. Salto usa as poses aprovadas: subida, bloqueio/descida e aterrissagem. O ciclo visual segue a velocidade vertical e o apoio real, sem aplicar novo deslocamento ao corpo; a arte pode ter pequeno espaço de voo residual. AnimationPlayer antigo é interrompido para não sobrescrever recortes, e área de contato é habilitada para o novo visual.

Folhas de corrida e salto têm escala comum de exportação baseada na maior altura das duas. Células 384×384, âncora (192,360), sprite escala 0,48 e pés em (-2,5;61), preservando corpo original. Não há animação nova de dano/derrota dedicada, permanecem clarão e remoção do componente compartilhado.

## Sentença

`script_sentenca.gd` estende script_inimigo1, mantendo corpo, gravidade, RayCast, direção, Marker2D, resistência e posição. Substitui somente o controle do lançamento/visual por folha nova. Um disparo aos 540 ms após detectar jogador, correspondente à primeira pose de mão aberta; ciclo total de 1,5 s com recuperação. Sem jogador detectado/vivo, cancela a preparação. Sprite escala 0,53, âncora (192,360), pés em (-1;63), colisão original.

Alterna de fato amarelo e vermelho. `cena_cartao_sentenca.tscn` herda a variante segura de projétil inimigo; `script_cartao_sentenca.gd` mantém contato/dano, remoção em terreno, duração máxima de 3 s e velocidade original de cartão 550 px/s. Cartão retangular 14×20 desenhado separado, grupo cartoes_sentenca; não usa visual de bola e não modifica cartão original nem outras variantes. Som de lançamento reutiliza Carrinho.mp3 em volume baixo; apito dedicado ainda não foi criado. A arte do gesto mostra amarelo na mão e vermelho na cintura mesmo no ciclo cujo projétil é vermelho: esse detalhe visual ainda pode ser refinado.

## Validação e limitações

Godot 4.7.2 headless, verificar_obrigatorios.gd: zero falhas. Confirma ativação, salto físico real do goleiro, nova folha no ar, pausa, parada ao sair da tela, disparos reais alternados amarelo/vermelho atingindo o jogador, pose nova do árbitro, pausa, cancelamento com jogador ausente e novas cenas apoiadas no terreno real.

Regressões Mbappé, Haaland, Neymar, Impedimento, VAR-01 e resistência: zero falhas. Total sete verificações. Mensagens ambientais persistem sobre certificados, UIDs com fallback por caminho e recursos em uso ao encerrar. Não houve validação visual em janela do jogo nesta etapa; conferir tamanho, contornos, salto e origem dos cartões em partida. Os resíduos coloridos das artes geradas permanecem para refinamento.

## Prompt da corrida — ferramenta integrada imagegen

Use case: identity-preserve. Eight-frame RUNNING sprite sheet of exact original goalkeeper Muralha in supplied reference. Same face, medium brown skin, short tightly curled black hair, teal long-sleeve jersey white1, teal shorts/socks, charcoal guards copper edges, big padded white/grey goalkeeper gloves turquoise grips, black/turquoise boots. EXACT FOUR EQUAL COLUMNS TWO EQUAL ROWS on1536x1024, one full body per384x512 cell, all SIDE VIEW FACING LEFT, stable hip center x192, same adult proportions and size, helmetless head near y70 feet ground near y480. Eight distinct sequential short running steps with alternating foot contact/compression/passing/flight/opposite contact, athletic goalkeeper low forward posture, bent arms with open gloved hands held ready to block. Gloves remain big and readable, no ball. Entire hair,gloves,boots inside own cell with generous gutters, never touch adjacent cells. Crisp detailed pixel art, discrete clusters and dark contours, preserve reference identity/outfit exactly, no chibi/3D/painting. TRUE alpha0 transparent background, no floor,shadow,glow,haze,gradient,matte,labels,grid,watermark or extra figures. Seamless loop, no duplicated poses.
