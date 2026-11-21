# Configurações gerais — áudio e tela

Atualização: a pedido do usuário, opções de tela removidas em 08/11/2026. Configurações agora contém somente áudio. As seções abaixo registram a versão anterior; detalhes atuais em `../AJUSTES-JOGABILIDADE-v1.md`.

Interpretação de altura do jogo: tamanho da janela (largura × altura). Não altera altura do salto, física ou escala do personagem.

Painel à esquerda mantém largura 440, arte do vestiário e interruptor próprio; altura 480 para os controles adicionais, com escala máxima 1,0. Abas Áudio e Tela evitam mostrar todas as opções simultaneamente. Sem nova arte raster. Ajuda fixa, sem tooltip. Ordem de Tab/Shift+Tab segue os controles da aba visível.

## Áudio

Três sliders 0–100%: principal (Master), música (Musica), personagens e efeitos (Efeitos). Volume zero realmente zera o canal. Master controla o conjunto; controles individuais preservam os volumes de cada AudioStreamPlayer. Silenciar áudio continua sendo opção independente no Master.

Novo autoload Preferencias, em `script_preferencias.gd`, cria os canais secundários e os envia ao Master. Ao adicionar um AudioStreamPlayer/2D/3D à árvore com stream definido e bus Master, roteia arquivos cujo nome começa com Música/Musica para Musica e os demais para Efeitos. Isso cobre as faixas existentes e os sons de combate, inclusive áudio de dano criado em execução. Não muda timbre, volume individual ou arquivo de áudio. Caso novos players recebam stream somente depois de entrar na árvore, atribuir seu bus explicitamente ou chamar `_rotear_audio` após definir stream.

Não há vozes separadas atualmente. Personagens e efeitos inclui chutes, carrinho, dano e sons de inimigos. Não promete canal exclusivo de voz.

## Tela

Resoluções de janela: 960×540, 1152×648, 1280×720 e 1600×900; tela cheia e botão Aplicar tela. Tamanho de janela desabilitado em tela cheia. No desktop a janela solicitada é limitada à área útil do monitor para permanecer acessível. Em modo incorporado (`--wid`) do Godot, controles de exibição ficam desabilitados com instrução para executar em janela separada. Na web, resolução é controlada pelo navegador; opção desabilitada e ajuda específica. Tela cheia via navegador precisa de conferência no build web.

Volumes e estado de exibição permanecem durante a sessão e entre cenas/reinícios de partida. Não há salvamento em disco ao fechar o jogo. Nenhum reset de vida ou pontos altera volumes.

## Validação

Godot 4.7.2 headless: configurações, auditoria das telas e menu inicial — três verificações com zero falhas. Teste ampliado confirma três canais independentes e valores reais no AudioServer, volume zero, roteamento de música e efeito dinâmico, abas, resolução aplicada na janela de teste, estado de tela cheia, desativação do seletor, valores ao reabrir e mute geral. Verifica controles dentro do painel em três tamanhos de janela e preservação das variáveis da partida.

Logs `verificacoes/gerais-*.log`. Headless não valida mudança de modo físico da janela, execução incorporada ou tela cheia do navegador. Não houve inspeção em janela real nem audição. Conferir em execução separada e, depois, nos builds desktop/web. Persistem mensagens ambientais de certificados e recursos em uso ao encerrar.

Referências técnicas consultadas: [AudioServer](https://docs.godotengine.org/en/stable/classes/class_audioserver.html), [DisplayServer](https://docs.godotengine.org/en/stable/classes/class_displayserver.html).
