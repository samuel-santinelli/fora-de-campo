# VAR-01 — caminhada e golpe integrados

`script_var01.gd` seleciona as folhas de caminhada, golpe e repouso no Sprite2D existente. `cena_chefao.tscn` inicia na pose parada exportada. Células de 384×384, âncora (192,360), escala 0,6 e pés na posição local y=90. Raiz e colisão originais não foram redimensionadas. Tamanho ereto visual próximo de 192 px, compatível com a integração anterior.

## Seleção e sincronização

- AVANCO com deslocamento: oito quadros de caminhada em ciclo de 980 ms. Parar interrompe o ciclo e usa pose parada.
- GOLPE: quadros 1–4 durante os 600 ms de aviso.
- ONDA: retoma a folha em 600 ms, começando no quadro 5, com o punho no chão no momento do impacto. Continua impacto/retorno sem reiniciar preparação.
- RECUPERACAO após ONDA: continua a partir de 1050 ms da folha e mantém o último quadro quando termina. Não repete impacto durante a pausa.
- RECUPERACAO após laser, CARGA, LASER e ATORDOADO: pose base exportada e efeitos separados já existentes. Não há novas folhas específicas de laser/atordoamento nesta etapa.

Espelhamento ocorre pela âncora dos pés e acompanha direção travada do ataque. Removido o deslocamento artificial da pose para baixo durante GOLPE, pois a flexão agora está nos desenhos. A posição da colisão e os efeitos de laser/onda mantêm seus valores anteriores. Clarão de dano continua no Sprite2D pelo componente compartilhado.

Sem mudanças em alcance, dano, vidas, movimento, velocidade do laser, contra-ataque pela bola, bloqueio pelo guardião ou abertura do portão. Nenhuma arte nova gerada nesta etapa. Permanecem pequenos resíduos de contorno e diferenças de proporção das folhas geradas; conferir durante partida.

## Verificação

Godot 4.7.2 headless: `verificar_animacoes_var01.gd`, zero falhas. Confirma repouso, avanço de quadros, espelhamento, preparação até 590 ms, impacto aos 600 ms, sustentação, continuidade para recuperação, fim sem repetição, interrupção da sequência, preservação do corpo e pausa.

Regressões `verificar_var01.gd`, `verificar_impedimento.gd` e `verificar_resistencia_inimigos.gd`: zero falhas. Confirmam combate, bola cancelando laser, desvio por altura/lado, alcance da onda, sequência guardião/chefe e abertura do portão. Logs `verificacoes/animacao-var01-*.log`. Permanecem mensagens ambientais de certificados e recursos em uso ao sair em algumas execuções. Não houve conferência visual em janela de jogo; validar em partida o punho, o ponto de saída da onda e a transição de tamanho entre poses.
