# Salto e queda integrados

`Personagem/SaltoCristiano` usa `script_salto_cristiano.gd` e a folha aprovada `salto-v1-alinhada.png`. Escala 0,5, mesma âncora dos outros visuais: (4,5; 57) relativa ao corpo. Não houve nova geração de arte nesta integração.

## Seleção das poses

- Impulso: quadro 2 durante os primeiros 70 ms de subida.
- Subida: quadro 3 enquanto a velocidade vertical for menor que -120.
- Ápice: quadro 4 com velocidade vertical entre -120 e 120.
- Início da queda: quadro 5 durante os primeiros 120 ms de descida.
- Queda: quadro 6 até tocar o chão, inclusive ao cair de uma plataforma sem pular.
- Aterrissagem e recuperação: quadros 7 e 8 durante 160 ms, apenas parado. Andar ou atacar interrompe a recuperação.

O quadro de preparação do HTML não atrasa o comando de pulo no jogo. O controlador visual não escreve na posição ou velocidade do personagem. Impulso 800, gravidade 30, velocidade horizontal 500 e formas de colisão preservados. A pausa da árvore congela o visual e o corpo.

O personagem atualiza o salto primeiro, depois permite espera ou corrida quando aplicáveis, evitando sprites sobrepostos. Dano interrompe os três visuais novos por meio segundo. Ataques continuam usando a arte original nesta etapa.

## Validação no Godot 4.7.2

- `verificar_salto_cristiano.gd`: zero falhas. Inclui impulso sem atraso, subida, ápice, queda longa, queda de plataforma, direção, interrupção de aterrissagem por movimento/ataque e bloqueio de dano; também simula um pulo real na cena do jogador sobre um piso isolado e verifica pausa, aterrissagem, retorno à espera e parâmetros originais.
- `verificar_corrida_cristiano.gd`: zero falhas, expectativa de pulo atualizada para a nova arte. Inclui trocas de visual e preservação dos ataques.
- `verificar_espera_cristiano.gd`: zero falhas.

Execuções sem janela, com logs na pasta `verificacoes`. Permanecem os avisos do ambiente sobre certificados e recursos MP3 em uso ao encerrar, já observados antes desta alteração. Não houve falhas nas asserções ou erros de análise dos scripts.

Conferência visual no jogo ainda necessária: tamanho ao sair do chão, continuidade da capa e troca entre aterrissagem e repouso. Próxima etapa de arte: Carrinho Relâmpago e Chute de Energia.
