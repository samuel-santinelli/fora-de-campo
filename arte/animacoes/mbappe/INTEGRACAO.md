# Mbappé — O Relâmpago integrado

`cena_mbappe.tscn` herda `cena_inimigo2.tscn`; `script_mbappe.gd` estende `script_inimigo2.gd`. Mantém CharacterBody2D, gravidade 10, movimento por `move_and_slide`, Resistencia, som de dano, detecção de tela e sinal de contato da base. A variante troca a perseguição com salto por perseguição terrestre e um ciclo curto de arrancada. O goleiro original e seu salto não foram substituídos.

Mbappé aparece em `cena_fase.tscn` na posição local (2230,548), após as plataformas centrais e antes do chefão. A fase agora possui juiz, goleiro e Mbappé, além do chefão. Sem nova fase.

## Comportamento inicial

- Ativa ao entrar na tela, perseguindo jogador válido com vidas e a até 560 pixels na horizontal.
- Persegue a 380 px/s por 1,2 s.
- Avisa parado por 240 ms, sem dano de contato.
- Arranca a 720 px/s por até 350 ms; trava a direção ao avisar, permitindo desvio do jogador. O contato pode causar dano durante perseguição e arrancada.
- Recupera por 800 ms, a até 90 px/s e sem dano de contato; depois retoma perseguição.
- Parede encerra a arrancada em recuperação, sem atravessar colisões. Sair da tela, do alcance ou ter jogador derrotado interrompe perseguição e contato.
- Não pula nem cria projéteis. Dano não fatal interrompe a arrancada e abre recuperação.
- Dois pontos de vida configuráveis no nó Resistencia; usa bola e carrinho atuais. Sons de dano herdados.

Valores exportados para balanceamento. A variante não usa navegação complexa e não sobe obstáculos que exijam salto. Conta apenas com terreno, gravidade e colisões existentes.

## Visual

Folha aprovada de oito quadros e pose parada, escala 0,5. Animação acelera na arrancada e reduz cadência na recuperação. A inversão usa a âncora dos pés, pois a folha original olha para a esquerda. Corpo e contato foram ajustados à silhueta menor, sem alterar o jogador ou o goleiro.

`script_efeito_arrancada.gd` desenha aviso e rastro azul em separado. Sem gerar nova arte nesta etapa. O rastro do jogo usa linhas e partículas simples; as cópias translúcidas do HTML eram apenas apresentação da prévia. Permanecem os resíduos de contorno já documentados na folha aprovada, a refinar posteriormente.

## Testado no Godot 4.7.2

`verificar_mbappe.gd`: zero falhas. Confirma herança da base, repouso antes de ativar, direção/espelhamento, perseguição, aviso sem contato, arrancada com direção travada, pausa, recuperação segura, desativação fora da tela, interrupção ao sofrer dano, derrota em dois acertos, parede, parada quando jogador perde vidas e posição apoiada no terreno real. Também confirma juiz, goleiro e chefão presentes, com salto do goleiro intacto.

Na primeira execução, a verificação pré-carregava o script antes dos autoloads e não reconhecia ScriptGlobal; passou a carregá-lo após a inicialização, como as outras verificações. O processo dessa execução interrompida foi encerrado; não foi fechado o processo preexistente do usuário. Execução final: zero falhas.

Regressões de resistência, chute, carrinho e dano/derrota executadas novamente. Testes headless, logs em `verificacoes`; ainda falta a conferência visual na fase pelo usuário. Permanecem os avisos já observados de certificados e recursos MP3 ao encerrar; a importação também tentou salvar preferências do editor fora do workspace.

Próximo rival: Haaland — O Tanque, usando perseguição mais lenta e resistência maior sobre as mesmas bases.
