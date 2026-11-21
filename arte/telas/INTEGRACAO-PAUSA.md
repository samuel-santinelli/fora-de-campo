# Pausa tática — integração

Cena de pausa existente preservada no mesmo caminho e UID, dentro do HUD/ParallaxBackground. Mantém process_mode ALWAYS e congelamento via SceneTree.paused. Substitui instrução incorreta de ENTER por painel com P/Esc e botão Continuar. Não cria nova cena de gameplay, música ou lógica de combate.

Painel azul escuro com bordas douradas, título PAUSA TÁTICA, identificação FORA DE CAMPO, frase curta e lembrete de controles. Botão dourado inclinado com foco visível; recebe foco ao abrir e libera foco ao fechar. Pode ser acionado por mouse ou navegação padrão do Godot. O fundo escurece a partida, que permanece visível. Sem raster novo ou dependências externas; estilos e containers nativos estão na cena, visíveis no editor.

`script_pausa.gd` centraliza o painel e dimensiona o escurecimento conforme viewport. Considera escala da UI e tamanho mínimo dos containers; usa coordenadas lógicas do canvas, não pixels físicos da janela. Continuar e P/Esc compartilham a mesma função de ativação/desativação, preservando a posição e estado da partida. Não há botão de abandonar/reiniciar para evitar aumentar o escopo.

## Validação

Três verificações Godot 4.7.2 headless com zero falhas:

- `verificar_pausa.gd`: abre pela ação real de pausa, confirma foco, congela jogador/inimigo mesmo com movimento pressionado; botão retoma movimento; reabre e retoma pelo atalho. Verifica painel e escurecimento em janelas 1152×648, 640×480 e 1920×1080.
- `auditar_telas.gd`: conexões das telas, músicas distintas e pausa/retomada.
- `verificar_menu_inicio.gd`: abertura e carregamento da fase preservados.

Logs `verificacoes/pausa-*.log`. Persistem mensagens de certificado, UID antigo de vida.png com fallback por caminho e recursos em uso ao encerrar; não são falhas dessas verificações. Não houve inspeção visual em janela nesta etapa. Conferir em partida contraste, foco e encaixe do painel. Abrir a fase, pressionar P/Esc, retomar com Continuar ou o mesmo atalho.

Próxima tela: game over, reutilizando reinício e retorno ao início existentes, com arte coerente com Cristiano de Portugal e os cenários aprovados.
