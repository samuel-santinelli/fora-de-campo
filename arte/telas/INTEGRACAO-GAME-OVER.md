# Game over — integração da versão 2

Cena `cena_game_over.tscn` mantém UID, música, volume e conexões originais. Fundo trocado para `game-over-v2.png`, aprovado pelo usuário: Cristiano caído, capa rasgada, uniforme danificado e armadura quebrada. Imagens anteriores permanecem no disco. Nenhuma nova imagem foi gerada na integração.

`script_game_over.gd` organiza fundo proporcional com recorte cover e painel discreto em formato estreito. Título FIM DE JOGO, mensagem e aviso são Labels reais criados em execução. Os mesmos ButtonReiniciar e ButtonSair recebem textos Tentar novamente / Voltar ao início e estilo dourado/azul inclinado, com foco visível. Reiniciar recebe foco ao abrir; as conexões e caminhos dos botões permanecem iguais. Textos/estilos novos aparecem em execução, não no layout estático do editor.

Callbacks preservam o reset já existente, agora com guarda contra comandos repetidos e troca de cena diferida. Exibir a derrota não redefine valores; escolher uma ação redefine vidas e pontos. Reiniciar abre diretamente a fase; voltar abre o menu com a abertura disponível. Não adiciona checkpoint, fase, sistema de lesão ou mecânica de armadura quebrada: os danos da ilustração são narrativos.

## Verificação

Godot 4.7.2 headless, três verificações com zero falhas:

- `verificar_game_over.gd`: versão correta da arte, foco inicial, valores mantidos ao exibir, reset ao escolher ação, transições reais para fase/menu e bloqueio de comandos concorrentes; botões/título/aviso contidos no viewport em janelas 1152×648, 640×480 e 1920×1080; proporção do fundo preservada.
- `auditar_telas.gd`: conexões, músicas distintas e pausa/retomada.
- `verificar_reacoes_cristiano.gd`: reações de dano e derrota preservadas.

Logs `verificacoes/game-over-*.log`. Persistem mensagens ambientais de certificado e recursos em uso ao encerrar. Sem inspeção visual em janela nesta etapa. Conferir no Godot o enquadramento, leitura dos botões, navegação de teclado e música. A página `previa-game-over.html` permanece uma referência artística sem ações de jogo.

Próxima tela: vitória após atravessar os portões, com mensagem coerente com chegar à final, sem afirmar que a partida final já foi vencida.
