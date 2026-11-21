# Carrinho Relâmpago integrado

`Personagem/CarrinhoCristiano` usa a folha aprovada `carrinho-v1-alinhada.png` e `script_carrinho_cristiano.gd`. O controlador visual lê o tempo do AnimationPlayer original: oito quadros em 500 ms, sem relógio de ataque independente. Células 384×256, escala 0,5 e âncora (192,240); apoio no personagem em (4,5;57), igual aos demais visuais.

Rastro dourado desenhado durante os quadros de deslize e efeito breve de impacto ao acertar, sem imagens adicionais. A arte original do carrinho foi preservada na biblioteca como referência, mas fica oculta durante o ataque novo. Chute ainda usa arte original.

## Comportamento

- Uma execução por pressionamento de Espaço, com som uma vez. Segurar a tecla não repete o ataque.
- Impulso de 650 px/s entre 100 e 320 ms, usando o `move_and_slide()` do personagem. Duração total permanece 500 ms. O impulso funciona mesmo sem segurar direção e respeita paredes.
- A direção do ataque é capturada ao iniciar. Visual, impulso e área de ataque usam essa direção.
- Área próxima existente espelhada e deslocada para a frente/baixo para acompanhar a chuteira. Forma de ataque e sinal `body_entered` reaproveitados, com janela original de 100–500 ms. Fora do ataque a transformação da área retorna ao estado original.
- Pulo, saída do chão ou dano cancelam o carrinho e desligam sua área de ataque. Pausa congela corpo, animação e efeitos.
- O encerramento de ataques libera a animação normal verificando `AnimationPlayer.is_playing()`. Isso evita manter a flag `animando` presa depois de uma animação concluída.
- Ataques só iniciam quando o personagem não está em outro ataque; evita reiniciar áudio e sobrepor chute ao carrinho. Chute mantém sua animação e método de disparo.

Vidas, valor de dano, eliminação de inimigos, abertura do portão, parâmetros de andar/pular e colisão física do jogador não foram reimplementados. Não há invulnerabilidade extra nem passagem por obstáculos baixos: a colisão corporal continua em pé nesta etapa, mesmo com a arte abaixada.

## Validação no Godot 4.7.2

`verificar_carrinho_cristiano.gd`: zero falhas. Testa cena real sobre piso isolado, início visual, janela de dano, pausa, acerto em inimigo à frente e preservação de inimigo distante atrás, deslocamento curto, ausência de repetição ao segurar, inversão para a esquerda, cancelamento por pulo e dano, parede e preservação de parâmetros/colisão.

`verificar_corrida_cristiano.gd`: zero falhas, com expectativa atualizada para a arte nova do carrinho. Testes de salto e espera também passaram. Execuções headless; conferência visual no cenário ainda fica para o usuário.

A folha precisou ser importada antes dos testes; a primeira execução anterior à importação acusou recurso sem loader. Após importar, não houve erros de análise ou falhas nas verificações. Permanecem os avisos já observados de certificados e recursos MP3 ao encerrar o motor, além de preferências do editor fora do workspace durante importação. Logs na pasta `verificacoes`.

Próxima etapa: arte e efeito do Chute de Energia, reaproveitando o projétil atual.
