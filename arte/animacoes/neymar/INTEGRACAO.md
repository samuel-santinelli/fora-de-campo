# Neymar — O Driblador integrado

`cena_neymar.tscn` herda a cena do goleiro; `script_neymar.gd` estende `script_inimigo2.gd`. Reutiliza CharacterBody2D, gravidade 10, move_and_slide, contato, ativação por tela, som de dano e componente Resistencia. Não altera os scripts de juiz, goleiro, Mbappé, Haaland, jogador ou chefão.

Na fase, Neymar começa na posição local (1900,497), apoiado no trecho central após a subida e antes de Mbappé. Preserva todos os inimigos anteriores e o salto do goleiro. Fica com três pontos de vida e porte semelhante ao de Cristiano/Mbappé; Haaland mantém seu aumento de 20%.

## Ciclo inicial

Três estados: AVANCANDO, FINTANDO e RECUPERANDO. Ativa ao entrar na tela, com jogador válido e vivo a até 560 px na horizontal, e só executa ciclo apoiado no chão. Sem navegação, salto, leitura dos comandos do jogador ou esquiva perfeita.

- Aproximação por 0,9 s, a até 260 px/s, parando de aproximar a menos de 95 px. Contato causa um ponto de dano, como na base.
- Finta de 0,88 s: captura a direção e mantém a orientação; avança a 80 px/s nos primeiros 0,30 s, sustenta o engano, recua a 160 px/s entre 0,46 e 0,68 s e para. Não causa dano por contato durante a finta.
- Aviso verde junto da chuteira entre 0,46 e 0,74 s; dispara uma única bola aos 0,74 s na direção capturada. A bola não corrige a mira se o jogador mudar de lado.
- Recupera parado e sem contato por 0,60 s; volta a aproximar.
- Acerto não fatal cancela a finta/chute pendente e reinicia a recuperação. Não cria invulnerabilidade; outros ataques distintos podem atingir. Dano zero não interrompe o ciclo.
- Sair da tela, perder alcance, ficar no ar ou perder jogador válido/vivo cancela o ciclo pendente. Gravidade e colisões continuam funcionando. Pausa congela ciclo, animação e projéteis.

## Arte e som

Usa as duas folhas aprovadas de oito quadros, células 256×256, escala 0,5 e âncora (140,240). Pés em y=61, corpo 42×108 e contato 56×76. Finta segue seus tempos originais sem repetir o primeiro quadro antes de terminar; corrida tem ciclo de 600 ms. AnimationPlayer antigo fica parado para não sobrescrever as folhas.

O disparo funcional aproveita a pose final da finta e um aviso desenhado separado do sprite. Ainda não há folha exclusiva de chute do Neymar; isso fica como refinamento visual posterior. Reutiliza `Sons/Chutando_a_bola.mp3`. Resíduos coloridos de contorno documentados em MOVIMENTO-v1.md permanecem para limpeza futura. Nesta etapa não foi gerada arte nova.

## Bola inimiga

`cena_bola_neymar.tscn` herda `cena_cartao.tscn`; `script_bola_neymar.gd` estende `script_cartao.gd`. Reutiliza movimento horizontal e método de dano do projétil da arbitragem, com textura `Bola.png` já existente e animação de cartão desativada. Não modifica o cartão original nem usa a bola do jogador contra inimigos.

Bola de 18 px, contato circular de raio 9, rotação visual, velocidade 360 px/s e duração máxima de 3 s. Area2D detecta somente jogador; o corpo não entra na camada dos inimigos. RayCast detecta terreno antes do deslocamento, removendo bola em parede/chão; não ricocheteia nem usa curva. Some após um acerto, expiração ou ausência/derrota do jogador. Bolas já disparadas podem continuar após a derrota do Neymar até essas condições de remoção.

Para evitar alterações de formas durante consultas físicas, o contato do Neymar e da bola agenda a chamada ao dano herdado fora do sinal físico. A bola marca consumo imediatamente para impedir dano repetido. A primeira execução revelou erro de queries causado pela interrupção das animações do jogador; corrigido nas variantes, sem alterar o jogador nem os inimigos existentes.

## Verificação

Godot 4.7.2 headless: `verificacoes/verificar_neymar.gd`, zero falhas. Confirma herança, repouso, perseguição, contato físico real, finta/recuo, orientação capturada, aviso antes do disparo, uma bola por ciclo, pausa de personagem/bola, recuperação segura, cancelamento de chute por dano, alcance, saída de tela, jogador inválido/derrotado, três ataques distintos por carrinho/bola, contato da bola nos dois sentidos, parede para personagem/projétil, expiração e apoio no terreno real. Confirma os rivais e os inimigos obrigatórios preservados.

Regressões Haaland, Mbappé e resistência: zero falhas. Logs em `verificacoes`. Permanecem avisos conhecidos de certificados, preferências do editor fora do workspace durante importação e recursos de áudio ainda em uso ao encerrar alguns testes. Não houve conferência visual em janela do jogo: validar em partida o tamanho, o aviso, a distância da finta e o equilíbrio do encontro.
