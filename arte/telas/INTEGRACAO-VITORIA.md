# Tela final — integração

`cena_final.tscn` usa `vitoria-v1.png`, preservando UID, música, volume e conexão do botão original. `script_final.gd` adiciona textos reais: A FINAL É SUA; O VAR-01 caiu / Os portões se abriram / Cristiano chegou ao estádio. A história termina na chegada para disputar a final, sem afirmar conquista do campeonato. Imagem anterior preservada no disco; sem geração de nova arte nesta etapa.

Botão Voltar ao início usa dourado, inclinação e foco visível, com bloqueio de acionamento repetido. Retorno diferido ao menu original; valores não são redefinidos ao voltar, pois iniciar nova partida já faz esse reset. Fundo proporcional com recorte cover e painel discreto em janela estreita. Espaços calculados pela altura real dos textos: 28 unidades entre título e mensagem, 32 antes do botão e 24 antes do aviso. Composição criada em execução, como no início e game over.

O teste de passagem física encontrou erro preexistente em `script_portao.gd`: troca de cena imediata durante callback de colisão removia objetos físicos no momento indevido. Corrigida com call_deferred e guarda contra múltiplos agendamentos, mantendo nome Personagem e vidas positivas como condições do callback. Habilitação da área continua na animação do portão após derrota do chefe, sem nova condição ou colisão.

## Validação

Quatro verificações headless Godot 4.7.2 com zero falhas: vitória, auditoria das telas, portão do estádio e Impedimento. `verificar_vitoria.gd` derrota guardião e chefe na fase real, aguarda abertura, aproxima o jogador e atravessa a área física com movimento real; confirma chegada à cena final e retorno ao menu. Também confere arte, foco, espaçamento e controles em viewports correspondentes a janelas 1152×648, 640×480 e 1920×1080. Regressões preservam sequência e gatilho do portão.

Logs `verificacoes/vitoria-*.log`. O erro de remoção durante callback desapareceu após a correção. Persistem mensagens ambientais de certificado e recursos em uso ao encerrar. Não houve inspeção visual em janela nem teste de build exportada nesta etapa. Conferir arte, leitura, música e retorno no Godot; `cena_final.tscn` com F6 permite revisar diretamente a tela.

Próxima interface: configurações; depois revisar itens de vida/munição e áudio contra os requisitos acadêmicos.
