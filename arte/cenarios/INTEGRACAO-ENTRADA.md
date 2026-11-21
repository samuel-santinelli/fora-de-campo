# Entrada do VAR-01 — integração

Atualização posterior: o portão recebeu acabamento próprio em `cena_portao_estadio.tscn`; detalhes em `INTEGRACAO-PORTAO.md`. A observação abaixo sobre largura da arte original registra a situação anterior a essa adaptação.

Sétimo painel da fase contínua integrado com `entrada-var01-v1.png`, sem modificar a imagem. Início x6720, corte y816 e escala uniforme 607/816. O centro aproximado do túnel na fonte (x1452) fica em x7800,35 no mundo, alinhado ao centro do portão existente em x7800. Chefe continua em x7450. Transição de entrada de 120 px sobre o posto de fiscalização.

A imagem termina perto de x7963,75. A margem restante até x8050 usa a última coluna de pixels do muro externo, desenhada por região de textura. Isso mantém a escala do túnel e a cobertura do limite da câmera. O painel final permanece opaco, sem dissolver em fundo neutro. Os outros painéis também ficam opacos sob a entrada do painel seguinte.

Revestimento do terreno até x8050; a partir de x6720 usa a alvenaria inferior do próprio painel. Piso e plataformas continuam desenhados sobre as mesmas colisões. Nenhuma posição, câmera, vida, ataque ou condição de vitória foi alterada. Não foram adicionadas colisões às câmeras, pilares ou túnel de fundo.

O portão original e sua animação foram preservados. Sua arte tem largura aproximada de 333 px no mundo, maior que a abertura ilustrada do túnel; alinhamento central não significa acabamento visual concluído. Conferir a sobreposição em partida e adaptar o visual do portão numa etapa própria. A luz do túnel não dispara vitória: a área funcional continua sendo habilitada pela animação após derrotar o chefe.

## Validação

Godot 4.7.2 headless: ambientes, percurso, Impedimento e VAR-01 — quatro verificações com zero falhas. Confirmam sete painéis, cobertura e sobreposição dos encontros, margem final até x8050, alinhamento central do túnel, travessia com movimento e pulo reais, ataques do chefe e abertura do portão somente após a derrota do chefe. Logs `verificacoes/entrada-*.log`.

Persistem mensagens ambientais sobre certificados, preferências do editor fora do workspace e recursos em uso ao encerrar. Não houve inspeção visual em janela do jogo nem medição de desempenho web. Conferir contraste do laser, mistura dos painéis, extensão da margem direita e sobreposição do portão. A prévia HTML continua ilustrativa, sem portão funcional nem reprodução da câmera do jogo.

Próxima etapa sugerida: revisão do percurso em partida e acabamento do portão; depois revisar telas, áudio e itens contra os requisitos acadêmicos. A montagem dos fundos está integrada, mas isso não encerra todos os requisitos do trabalho.
