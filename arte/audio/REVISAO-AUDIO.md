# Revisão de áudio e identidade sonora

## Requisitos já ligados

| Exigência | Implementação existente preservada |
|---|---|
| Ataque curto | Carrinho.mp3 ao iniciar carrinho |
| Chute | Chutando_a_bola.mp3 no disparo efetivo |
| Dano no jogador | Dano_jogador.mp3 na perda de vida |
| Dano nos inimigos/chefe | Resistencia com som_dano por base de inimigo/chefe; som sobrevive à remoção do corpo |
| Músicas distintas | Música_introdução, Música_fase e Música_tela_game_over; tela final tem Música_venceu_o_jogo |
| Itens | Pegando_vida.mp3 nas coletas |

Neymar mantém SomChute no lançamento da bola. Impedimento mantém seu SomAtaque, associado ao sinalizador/investida. Não foram trocados arquivos ou ganhos do jogador/músicas sem audição. Em particular, os ganhos positivos herdados para chute/dano do player ainda precisam de conferência auditiva de equilíbrio.

## Efeitos adicionados

Oito WAVs originais por síntese determinística em `Sons/Identidade`, sem samples externos ou voz. Gerador reproduzível: `node verificacoes/gerar_sons_identidade.cjs`. PCM mono 16 bits/22050 Hz, durações 0,16–0,85 s. Picos de amostra medidos 0,153–0,419, abaixo de clipping dos arquivos isolados; isto não garante ausência de saturação na mixagem completa.

- VAR-01: carga crescente ao entrar em CARGA; laser e impacto separados nos mesmos instantes de ataque já existentes; pane ao entrar em ATORDOADO. SomCarga para ao sair da carga, inclusive interrupção. Volume de carga -14 dB; ataque continua -8 dB. Não altera janelas de desvio/dano.
- Mbappé: whoosh de arrancada, uma vez na mudança de estado, -12 dB. Condição exclui Impedimento, que já tem seu SomAtaque, evitando dupla reprodução herdada.
- Haaland: passo grave quando avança, intervalo mínimo 0,6 s, -14 dB. Não altera animação ou velocidade.
- Muralha: sinal curto na transição do chão para salto ascendente, -13 dB; não toca durante queda inicial ou todo frame no ar.
- Sentença: apito curto em vez de reutilizar Carrinho.mp3, no mesmo evento de lançamento.

`script_sons_identidade.gd` toca efeitos transitórios no canal Efeitos e os remove ao terminar. Adição/reprodução diferidas evitam mutação da árvore em momentos indevidos. Ganhos de eventos separados da preferência global. Sons atravessam Efeitos → Master; músicas continuam Musica → Master. Não foi criada voz do Siu, nova BGM ou música especial de chefe.

## Validação e audição

Godot 4.7.2 headless: áudio, VAR-01, Mbappé, Haaland e obrigatórios — cinco verificações com zero falhas. Teste específico confirma oito recursos válidos sem loop, SFX obrigatórios e dano por inimigo, roteamento de música/efeitos, reprodução da arrancada, início e cancelamento da carga e reprodução da pane. Regressões preservam comportamento/ataques. Logs `verificacoes/sons-*.log`.

Sem audição pelo agente ou inspeção em janela nesta etapa. `previa-sons.html` permite ouvir os arquivos isolados; fontes locais e estrutura foram verificadas por script, sem inspeção no navegador real. Depois conferir em partida mistura com BGM, intensidade de apito/laser e frequência dos passos. Persistem mensagens ambientais de certificado e recursos em uso ao encerrar. Áudios herdados permanecem no projeto; não houve revisão de origem/licenciamento deles nesta etapa.
