# Apresentações com retratos e combate — 12/11/2026

## Sete rivais

As apresentações pequenas foram substituídas por cartões com a imagem de cada personagem, nome, título, frase curta, ataque e uma dica de defesa. As imagens vêm das artes aprovadas existentes, recortadas por AtlasTexture; não são criados novos desenhos inconsistentes para cada tela.

A fase congela enquanto o cartão está aberto. Ele aparece uma vez por rival por partida, avança automaticamente após 4 s e pode ser encerrado com o botão, Espaço/Enter ou Esc após 0,45 s. A primeira entrada tem fade/deslocamento curto; as demais usam a mesma estrutura. Não há diálogo em várias páginas ou navegação obrigatória. Teclas repetidas não pulam o cartão acidentalmente. O espaço usado para seguir não vira carrinho ao retomar.

Só o cartão processa durante a pausa; o menu de pausa não se sobrepõe. Remover a fase também desfaz a pausa do cartão. A música da fase continua. Deslocamento, vida, projéteis e IA não avançam enquanto o retrato está aberto. VAR só é apresentado após a liberação do guardião.

Os cartões usam dimensões explícitas, com layout compacto abaixo de 720 px. Os testes de tamanho foram atualizados para a nova apresentação maior; as dicas de comandos continuam pequenas. HUD.apresentar_rivais permite desativar as apresentações em cenas de teste, sem mudar o padrão da partida.

## Haaland

Nova folha com seis poses próprias de ombrada, em `animacoes/haaland/ataque-ombrada-v1.png`. Duração visual 0,72 s; mantém o dano de um ponto do contato e a resistência existente. Prompts e integração em `animacoes/haaland/OMBRADA-v1.md`.

## VAR-01

O laser deixa de ser uma faixa horizontal perto dos pés. A origem é o olho da textura de espera, transformado pelo próprio Sprite2D. A mira acompanha o corpo do Cristiano nos primeiros 55% da carga de 1,1 s e fica travada no restante. É possível provocar a mira, pular após o travamento ou acertar uma bola durante a carga para interromper.

O aviso, a animação do olho e o feixe usam a mesma trajetória. O disparo tem brilho, raios curtos e pequeno recuo do sprite. Tanto a colisão quanto o desenho partem do olho; paredes e chão limitam o alcance. Dano é calculado pela interseção do segmento inclinado com o corpo do jogador, considerando os 14 px do feixe, uma vez por disparo. A onda de choque permanece separada.

## Conferência

As 35 verificações Godot passaram nesta revisão. Logs `verificacoes/final-retratos-*.log`. Os testes de retrato exercitam os sete rivais, pausa com input de movimento ativo, conclusão automática, botão de seguir, prevenção de repetição e liberação de pausa ao remover a fase. Os quatro tamanhos lógicos de tela continuam cobertos.

Testes próprios de retratos/pausa/retomada, tamanho de cards, seis quadros da ombrada, reação a dano e geometria do laser. Os testes de mecânicas isoladas desativam os retratos para não misturar tempo de UI e combate. O jogo normal mantém todas as apresentações ativas.

Validação automatizada não substitui a inspeção visual em partida. As novas builds precisam ser recarregadas no navegador com Ctrl+F5 para conferir os retratos, a animação e a posição final do olho.
