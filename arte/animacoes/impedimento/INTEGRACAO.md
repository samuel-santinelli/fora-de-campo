# O Impedimento — confronto integrado

`cena_impedimento.tscn` herda `cena_mbappe.tscn`; `script_impedimento.gd` estende `script_mbappe.gd`, que já reutiliza o perseguidor original. Mantém gravidade, colisões, ativação por tela, captura de direção, cancelamento ao sofrer dano e ciclo de quatro estados. Não modifica IA nem valores de Mbappé, Neymar, Haaland ou goleiro.

Posição inicial local (2670,547), no chão após a plataforma de Haaland e antes do chefe. O espaço é curto: `script_encontro_impedimento.gd`, anexado à fase, sequencia os dois confrontos. Enquanto o guardião vive, a raiz do chefe fica com processamento desabilitado e corpo fora da camada atingida pelos ataques. O chefe continua visível, aguardando. A derrota confirmada do guardião restaura modo de processamento e camada anteriores; a ativação do chefe segue sua presença na tela. Não ativa chefe fora da tela. Remover a fase inteira não inicia o encontro.

## Comportamento inicial

- Cinco pontos de vida pelo componente Resistencia, com som/clarão existentes; bola e carrinho atuais continuam funcionando, um dano por ataque distinto.
- Aproximação de 170 px/s durante 0,9 s. Ativa na tela, com jogador vivo a até 480 px na horizontal e apoiado no chão.
- Aviso parado de 0,8 s, com os oito quadros da bandeira erguida; sem contato durante aviso. Traço amarelo indica investida, ponto amarelo indica sinalizador.
- Alterna investida e sinalizador. Primeiro ataque: investida de 560 px/s por até 0,3 s, direção capturada no início do aviso; parede encerra investida. Segundo: um sinalizador horizontal na direção capturada, entrando diretamente em recuperação sem avançar junto.
- Recuperação parada por 0,9 s e sem contato. Acerto não fatal interrompe ataque como no Mbappé; dano zero não interrompe. Pode receber novos ataques distintos durante recuperação, sem invulnerabilidade.
- Perseguição e investida usam contato de um ponto. Contato é agendado fora do sinal físico para que a reação do jogador não altere formas durante consultas de colisão.
- Pausa congela ciclo/animação/projéteis. Fora da tela/alcance, jogador ausente/derrotado ou corpo no ar interrompem ataque e contato, mantendo gravidade.

## Visual e sinalizador

Usa folhas de avanço e aviso 3072×384, oito células 384×384, âncora (230,360), escala 0,5, pés em y=61. Avanço tem ciclo de 780 ms e cadência 2,3× na investida. Corpo 44×124 e contato 58×90 excluem a bandeira. O efeito azul herdado permanece oculto; linhas amarelas simples são desenhadas pelo guardião. Há diferenças pequenas de proporção e resíduos coloridos nas bordas das folhas, documentados na etapa de arte; conferir visualmente em partida.

`cena_sinalizador_impedimento.tscn` herda a bola inimiga do Neymar; script estende `script_bola_neymar.gd`. Mantém movimento horizontal, dano único, expiração de 3 s, remoção em parede e ao perder jogador vivo. Velocidade 420 px/s; sprite da bola oculto, sinalizador amarelo de 18×8 desenhado em separado. Grupo próprio `sinalizadores_impedimento`, retirado do grupo de bolas do Neymar. Não altera o projétil da arbitragem. Som reutilizado de chute, a substituir futuramente por efeito mecânico se desejado.

## Chefe e portão

Guardião derrotado libera apenas o chefe, não o estádio. Chefe mantém seis vidas e componente original que abre o portão somente na derrota. Não foi criado bloqueio extra, nova arena, nova fase ou outro sistema de combate. A aparência e ataques definitivos VAR-01 ainda pertencem à próxima etapa.

## Verificação

Godot 4.7.2 headless: `verificacoes/verificar_impedimento.gd`, zero falhas. Confirma herança, ativação, repouso, cinco vidas, aviso seguro, direção capturada, alternância dos ataques, recuperação, pausa de personagem/sinalizador, acerto e remoção do sinalizador, cancelamento por dano, alcance, saída da tela, jogador ausente/derrotado, carrinho sem dano duplicado, derrota por cinco ataques, remoção do sinalizador em parede e apoio no terreno real. Na fase real confirma chefe suspenso antes da derrota do guardião, restauração da camada/processamento, chefe ainda com seis vidas, portão fechado após guardião e aberto somente após chefe.

Regressões Mbappé, Haaland, Neymar e resistência: zero falhas. Logs em `verificacoes`. Permanecem mensagens ambientais sobre certificados, UIDs inválidos com carregamento bem-sucedido pelo caminho textual, preferências do editor sem escrita fora do workspace durante importação e recursos ainda em uso ao encerrar. Não houve conferência visual em janela do jogo nesta etapa; verificar espaço, animação da bandeira e dificuldade em partida.
