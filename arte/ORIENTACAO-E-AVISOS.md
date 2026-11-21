# Orientação e leitura dos ataques — 12/11/2026

> Atualização: as apresentações pequenas foram substituídas por [cards com retratos e pausa da fase](APRESENTACOES-E-COMBATE-v2.md). A mira do laser agora também sai do olho e acompanha sua trajetória inclinada. As descrições de banner sem pausa e faixa horizontal abaixo são históricas.

Correção dos cards: substituído o dimensionamento automático dos PanelContainers por painéis com dimensões explícitas. Dicas têm até 580×122; apresentações até 380×126, com texto limitado ao interior. Textos não podem mais aumentar o painel durante mudanças de conteúdo ou exibição. `verificar_tamanho_cards.gd` passou com todas as dicas e apresentações em áreas lógicas de 1152×648, 640×480, 360×640 e 1920×1080, conferindo os limites imediatamente ao mostrar e nos frames seguintes. Orientação, pausa e barras de vida também passaram. Validação sem janela; ainda requer conferência visual em partida.

Implementação dos itens 1, 2 e 3 aprovados: ensinar comandos, apresentar rivais e destacar ataques. Sem alterações em dano, resistência, recursos, tempos de ataque ou dificuldade. Exportação e publicação continuam para outra etapa.

## Comandos no início

O HUD apresenta movimento, pulo, carrinho, chute e superchute em cartões discretos na parte inferior. Movimento é confirmado por deslocamento real; as outras ações são confirmadas por sinais do personagem. O chute só conta quando a bola é criada e consumida. Superchute também confirma o chute comum, se executado antes dele.

Após executar uma ação, há uma breve confirmação e a próxima dica aparece. Cada dica também avança após sete segundos de exposição, para não ocupar a tela durante toda a jornada nem obrigar o jogador a seguir o tutorial. Ações feitas antes da dica são lembradas e puladas. Nenhum comando é executado automaticamente; não há prêmio ou gasto adicional. O registro é local à partida e reinicia com a cena.

## Apresentações

Muralha, Sentença, Neymar, Mbappé, Haaland, Impedimento e VAR-01 recebem nome e subtítulo. O cartão dura 2,8 segundos, sem pausar o combate. Só aparece para um inimigo vivo, próximo e na região visível da câmera. Um cartão por vez; rivais já apresentados não se repetem ao voltar pelo mapa. VAR aguarda a liberação pelo guardião. Não são criadas cutscenes, travas ou novas arenas.

Cartões se ajustam à largura lógica do viewport. Apresentação fica centralizada no topo em telas largas e abaixo dos recursos em telas menores. Todas as áreas novas ignoram o mouse; painel de pausa fica acima delas. Dicas e apresentações congelam na pausa e somem na derrota.

## Sinais de perigo

- Goleiro: aviso de salto acima da barra e marca dourada junto aos pés durante a aproximação no chão. Indica o risco do salto existente, sem retardar sua execução.
- Mbappé: texto e setas azuis no chão apontam para a direção já travada da arrancada, durante os 0,24 s originais de preparação. Setas respeitam paredes; recuperação remove o aviso.
- VAR: faixa vermelha na altura e extensão do laser durante a carga; texto lembra que é possível pular ou interromper com bola. Golpe no chão recebe faixa laranja e orientação para pular. As faixas respeitam colisões e desaparecem quando a carga é interrompida. Tempos de carga, geometria de dano e sons existentes permanecem.

Scripts novos: `script_orientacao_fase.gd` e `script_sinal_ataque.gd`. Integração no HUD e nos três inimigos, mais sinais de ações no personagem.

## Conferência

`verificar_orientacao_fase.gd` exercita ações reais pelo Input, confirmação das dicas, apresentações dos sete inimigos, ausência de repetição, espera do VAR, reinício da partida, pausa, derrota e posicionamento dos painéis para área lógica de 640×480. Também confere os avisos dos três ataques e tempos originais de Mbappé/VAR.

Verificações executadas sem janela. Layout e leitura em combate ainda precisam de conferência visual em partida; não foi feita captura de tela desta implementação.
