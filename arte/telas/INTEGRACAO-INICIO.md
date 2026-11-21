# Menu e abertura — integração ao Godot

`script_inicio.gd` agora usa a capa e os quadros aprovados na cena inicial existente, preservando seu UID, caminho, música e callbacks. Sprite do professor oculto; imagem antiga permanece no disco. Os três botões existentes são movidos para o nó Menu em runtime, mantendo conexões, e recebem texto real e StyleBoxFlat com inclinação, bordas douradas, estados de foco/hover/pressionado. Título e instruções são Labels reais, sem texto embutido no PNG. O título FORA DE CAMPO continua provisório.

O fundo conserva proporção com recorte cover. UI ajusta escala e posição conforme o viewport lógico; painel escuro em proporções estreitas melhora legibilidade. Os nós da nova composição aparecem em execução, não na montagem estática do editor. A prévia HTML continua disponível para consulta artística; a apresentação dos botões Godot usa recursos nativos e não reproduz exatamente o gradiente/clip-path do CSS.

## Abertura

Iniciar desabilita os três botões e executa 3,18 s de sequência. Menu sai à esquerda; fundo limpo dissolve sobre a capa; aceno alternado, brilho no sorriso, preparação, salto, descida, aterrissagem, SIUUU! e passagem dourada. A fase é carregada ao final. Botão Pular abertura e Esc também levam à fase. Guarda `_saindo` impede disparos repetidos. Apenas ao concluir/pular a abertura, `ScriptGlobal.resetar_variaveis()` redefine vidas e pontuação. Abrir configurações e voltar ao menu não redefine valores.

Imagens originais aprovadas preservadas. `script_dados_abertura.gd` contém os mesmos seis recortes/âncoras do JSON da prévia, em recurso carregável nas exportações sem depender de filtro para arquivos JSON. O teste confirma equivalência numérica dos dados. Não houve nova geração de arte nesta integração.

Os movimentos continuam sendo seis poses-chave com salto por deslocamento, não uma sequência fluida com muitos quadros. Permanecem pequenas variações de rosto/capa, franja colorida e diferença entre fundo limpo e capa documentadas em `ABERTURA-v1.md`. Não foi adicionada voz nem SFX novo: somente a música existente. Brilho e anel são efeitos nativos. Não há alteração no personagem jogável.

## Validação

Quatro verificações Godot 4.7.2 headless com zero falhas:

- `verificar_menu_inicio.gd`: cliques repetidos, término, botão pular, Esc e carregamento real da fase; reset de vidas/pontos, configurações/retorno preservando valores; título, botões e instruções contidos no viewport em janelas 1152×648, 640×480 e 1920×1080; recortes equivalentes à prévia.
- `auditar_telas.gd`: conexões, rótulos, músicas distintas e pausa/retomada na fase. Adaptado para localizar os botões dentro de Menu.
- `verificar_percurso.gd`: travessia com movimento e pulo reais.
- `verificar_portao_estadio.gd`: abertura e gatilho sincronizados.

Logs `verificacoes/menu-*.log`. Persistem mensagens ambientais de certificado, preferências do editor fora do workspace e recursos em uso ao encerrar em parte das execuções. Não houve inspeção visual em janela nesta etapa ou teste de build exportada. Conferir no jogo contraste, foco com teclado, recorte em janela estreita e transição para a fase. A opção de movimento reduzido existe na prévia HTML; não foi criada uma configuração equivalente no jogo nesta etapa. Pular está disponível no Godot.

Próxima tela: pausa, preservando o congelamento existente e corrigindo a instrução de ENTER para P/Esc.
