# Dano e derrota integrados

`Personagem/ReacoesCristiano`, com `script_reacoes_cristiano.gd`, usa as folhas aprovadas `dano-v1-alinhada.png` e `derrota-v1-alinhada.png`. Células de 384×256, escala 0,5 e âncora dos pés igual às outras ações. Nenhuma arte foi gerada novamente nesta etapa.

## Receber dano

A função existente `receber_dano()` desconta o valor global, limita vidas a zero, reproduz o som e interrompe ataques. O visual antigo deixa de ser mostrado: a reação de seis quadros ocupa 500 ms e depois cede à corrida, repouso ou salto conforme o movimento atual. Clarão breve nos quadros de impacto, sem uma regra nova de invulnerabilidade.

Movimentação e pulo continuam disponíveis durante dano não fatal. Ataques não podem começar enquanto a reação está ativa, evitando golpes invisíveis. Dano no ar não teletransporta, não altera velocidade nem aplica impulso. Golpes consecutivos continuam descontando vida como antes.

O golpe do chefão, que antes alterava o contador diretamente, agora chama a mesma função do personagem, incluindo reação e som. Há guarda para referência inválida ao personagem após trocar de cena.

## Derrota e Game Over

Ao chegar a zero, iniciar uma única animação de oito quadros por 1,2 segundos. Ignorar comandos de ação; manter gravidade e `move_and_slide()` para que o corpo continue caindo e colidindo. Área de ataque desligada; golpes adicionais não reiniciam a derrota nem deixam vidas negativas. O portão não aceita vitória com zero vidas.

Ao terminar, agendar uma única troca para `cena_game_over.tscn`, preservando a tela e os botões existentes. Pausar congela a animação e adia a troca. O personagem limpa sua referência global ao sair da árvore. Reiniciar usa o reset e a fase originais: dez vidas e estado novo do personagem.

O relógio de ações só é consultado se o AnimationPlayer estiver reproduzindo, pois ele fica parado durante a derrota. Isso evita o erro de consultar tempo de uma animação inexistente.

## Validação no Godot 4.7.2

`verificar_reacoes_cristiano.gd`: zero falhas. Inclui controlador das duas sequências e cena real com piso: vida descontada, arte correta, cancelamento de chute antes do disparo, bloqueio de ataques durante reação, movimento/pulo preservados, dano no ar e sem impulso, pausa, golpes sucessivos, integração do chefão, ausência de vitória após derrota, pose final, uma única troca para Game Over, referência global limpa e reinício na fase existente com vidas/estado restaurados.

Os tempos de dano, salto e aterrissagem são independentes: o teste aguarda a aterrissagem completa antes de exigir repouso. A verificação inicial também revelou leitura do relógio do AnimationPlayer parado, corrigida antes da execução final.

Regressões de espera, corrida, salto, carrinho e chute executadas novamente. Logs em `verificacoes`. Os testes são headless; a aparência final no cenário ainda precisa da conferência do usuário. Permanecem os avisos já observados do ambiente sobre certificados e recursos MP3 ao encerrar, sem relação com a seleção de poses. A importação de recursos continua emitindo aviso ao tentar salvar preferências do editor fora do workspace.

O sistema de vida não foi substituído. Coletáveis, munição limitada, resistência e identidade dos inimigos, cenário e telas ainda fazem parte das etapas seguintes do escopo maior.
