# Corrida integrada ao jogador

`Personagem/CorridaCristiano` usa `script_corrida_cristiano.gd` e a folha aprovada `corrida-v3-alinhada.png`. O ciclo tem oito quadros, 530 ms, escala 0,5 e a mesma âncora do repouso: (4,5; 57) relativa ao corpo. Mãos e capa são apenas visuais.

`script_personagem.gd` escolhe o visual após `move_and_slide()`: espera quando parado no chão, corrida ao mover-se no chão, arte original durante pulo e ataques. Cada controlador é atualizado mesmo estando oculto para reiniciar corretamente o ciclo e contar o bloqueio de dano. Dano interrompe os dois visuais novos por meio segundo. Corrida e espera ficam pausadas junto com o personagem.

Sem alteração na velocidade de 500, gravidade, força do pulo, colisões, área de ataque, disparo ou funcionamento do chefão. As artes de pulo e ataques continuam antigas nesta etapa. A corrida tem os resíduos de borda já documentados na v3 aprovada; não houve nova geração.

## Testado no motor

Godot 4.7.2 encontrado nos processos ativos em `C:/Users/samue/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64.exe`.

- `verificacoes/verificar_espera_cristiano.gd`: zero falhas.
- `verificacoes/verificar_corrida_cristiano.gd`: zero falhas, executado com `--headless --fixed-fps 60`.

Verificações da corrida incluem ciclo completo, inversão, bloqueio por dano e a cena real do jogador sobre um piso isolado: andar, parar, mudar direção, pular, chutar, carrinho, pausar durante a corrida e preservação da colisão. O teste de espera cobre respiração, intervalo, gesto, direção, interrupção e dano.

Os comandos encerraram com código 0. O motor emitiu avisos de leitura do repositório de certificados e recursos de áudio MP3 ainda em uso ao encerrar; não houve falhas nas asserções nem erros de análise dos scripts. A importação também não conseguiu salvar preferências do editor fora do workspace; os recursos do projeto foram carregados com sucesso nos testes. Logs locais em `verificacoes/corrida-godot.log` e `verificacoes/espera-godot.log`.

Os testes foram sem janela. Falta a conferência visual no cenário pelo usuário: início da corrida, parada, troca de direção e transição para o pulo antigo. Próxima arte planejada: salto e queda.
