# Telas — diagnóstico e direção da adaptação

Estado atual: configurações adaptadas em `telas/INTEGRACAO-CONFIGURACOES.md`. Todas as telas listadas receberam adaptação visual. A análise abaixo preserva o diagnóstico original e suas atualizações intermediárias; revisão visual em partida e demais requisitos de itens, áudio e entrega continuam necessários.

Atualização mais recente: tela final integrada em `telas/INTEGRACAO-VITORIA.md`, com mensagem de chegada à final e retorno ao menu. Entre as telas analisadas, resta adaptar visualmente configurações. As observações de pendências abaixo registram etapas anteriores.

Atualização: menu inicial e abertura integrados em `telas/INTEGRACAO-INICIO.md`; pausa adaptada em `telas/INTEGRACAO-PAUSA.md`; derrota v2 integrada em `telas/INTEGRACAO-GAME-OVER.md`. Corrigido reset ao iniciar nova partida; botões de início e derrota agora têm texto real. Pausa informa P/Esc e oferece Continuar. A análise abaixo registra o estado anterior à adaptação. Vitória e configurações ainda aguardam adaptação visual.

Análise dos scripts, cenas, Input Map e imagens atuais. Nesta etapa nenhuma tela, imagem de produto, botão ou regra de gameplay foi modificada. O nome FORA DE CAMPO continua sendo o título de trabalho; o projeto ainda se chama `As aventura de um jogador` em project.godot.

## O que existe e pode ser reaproveitado

| Tela | Estrutura e comportamento atuais | Adaptação necessária |
|---|---|---|
| `cena_inicio.tscn` | Três botões conectados a iniciar fase, configurações e sair; música com autoplay | Trocar fundo com jogador antigo e brasão; título, narrativa e textos em controles reais; manter callbacks |
| `cena_pausa.tscn` | Sobreposição dentro do HUD, process_mode ALWAYS; P ou Esc congela e retoma a árvore | Corrigir instrução ENTER; painel legível, controles e identidade visual; manter congelamento |
| `cena_game_over.tscn` | Reiniciar redefine variáveis e abre fase; sair redefine variáveis e abre início; música própria | Trocar jogador azul 10 e placar Brasil; botões reais Tentar novamente / Voltar ao início |
| `cena_final.tscn` | Botão volta ao início; música de vitória própria | Substituir comemoração com personagens antigos; mensagem sobre chegada à final, coerente com objetivo, sem afirmar conquista do campeonato |
| `cena_configuracoes.tscn` | CheckButton silencia o bus Master; botão retorna ao início | Reorganizar visual e explicar que silencia todo áudio, não só música; manter AudioServer |

`cena_fase.tscn` já contém a fase principal e o HUD. São cinco telas de interface mais a fase, sem necessidade de criar outro fluxo ou novas fases.

## Problemas confirmados

1. Botões de início, derrota e vitória têm propriedade `text` vazia. Os nomes que aparecem estão desenhados nas imagens. São áreas de clique sobre a ilustração, o que vincula o layout a coordenadas fixas e dificulta leitura por teclado/acessibilidade. Usar textos e estilos nos botões existentes ao trocar o fundo; não sobrepor novos rótulos aos antigos sem remover a arte anterior.
2. A pausa pede ENTER, mas o Input Map usa P e Esc. O teste confirma que a ação `pausa` congela e retoma. Corrigir a instrução quando adaptar o painel.
3. `script_inicio.gd.iniciar_jogo()` não chama `ScriptGlobal.resetar_variaveis()`. O reinício pelo game over já chama; a volta pela vitória não. Uma nova partida iniciada depois da vitória pode herdar vidas e pontuação. Fazer reset no início de uma nova partida, sem alterar o estado ao apenas abrir configurações ou voltar ao menu.
4. Layouts são baseados em offsets absolutos próximos de 1152 × 648, com fundos escalados de forma não uniforme; a janela usa stretch canvas_items/expand. Na adaptação, usar anchors/containers para botões e recorte proporcional do fundo. Validar janela padrão, formato largo e formato mais estreito, pensando na exportação web.
5. Tela final atual afirma campeão do torneio. A história do projeto termina ao chegar ao estádio para a final, após vencer VAR-01. Texto sugerido: `A FINAL É SUA.` / `O VAR-01 caiu. Os portões se abriram. Cristiano chegou ao estádio.` Não criar outra partida de futebol.

## Áudio — somente inventário inicial

Início e configurações usam Música_introdução.mp3; fase usa Música_fase.mp3; derrota usa Música_tela_game_over.mp3; final usa Música_venceu_o_jogo.mp3. Início, fase e derrota apontam para arquivos distintos, cumprindo a separação estrutural exigida. Não houve audição nesta etapa, nem avaliação de volume, loop ou autorização de distribuição das faixas. Não é necessário substituir músicas apenas para redesenhar as telas.

## Primeira adaptação: início

Manter os três botões e suas conexões. Composição proposta: título em texto real no lado esquerdo, resumo curto `Atravesse os bloqueios. Derrube o VAR-01. Chegue à final.`, botões Iniciar / Configurações / Sair e uma linha discreta de controles. Cristiano de Portugal 7, armadura dourada e capa à direita; estádio ao entardecer e presença distante do VAR, coerentes com os cenários. Nome provisório alterável sem gerar novamente a imagem.

Não desenhar textos, menus ou botões dentro da próxima imagem de fundo. Reaproveitar referências aprovadas do Cristiano para manter o rosto, uniforme e proporções. Usar fundo com área menos carregada atrás do menu. Paleta azul escuro, dourado e vermelho pontual; botões com foco visível além do hover. Para web, revisar apresentação do botão Sair quando preparar exportação, pois fechar a aba não equivale a encerrar o executável.

Controles confirmados no Input Map: A/D ou setas esquerda/direita; W ou seta para cima para pular; Espaço para carrinho; C para chute; P/Esc para pausa. Existe ação de cabeçada em Shift+Espaço; não anunciá-la como mecânica final sem revisar sua execução e conflito com carrinho.

Ordem: início → pausa → derrota → vitória → configurações/HUD, mantendo botões e callbacks onde possível. Corrigir reset ao integrar o novo menu. Só depois revisar coleta de vida e munição: elas não devem ser anunciadas como prontas nesta análise das telas.

## Validação realizada

`verificacoes/auditar_telas.gd`, Godot 4.7.2 headless: zero falhas. Instanciou início, configurações, game over e final; confirmou oito conexões de controles e quatro players de música configurados, comparou as músicas de início/derrota/fase e exerceu pausa/retomada na fase real. Também registrou textos vazios dos botões. Log: `verificacoes/auditoria-telas.log`.

As três imagens antigas foram inspecionadas diretamente. Não houve inspeção das telas em janela real nem acionamento de todos os callbacks de troca de cena. As pendências acima resultam de inspeção dos scripts e recursos, além do teste restrito descrito. Mensagens ambientais de certificado e recursos em uso ao encerrar permanecem no log.
