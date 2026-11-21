# Compatibilidade do áudio Web — 12/11/2026

> Atualização: esta tentativa com Stream foi substituída pela [correção de estabilidade v2](ESTABILIDADE-WEB-v2.md). O estado atual usa Sample e corrige a criação dos canais com bus_count; a versão abaixo é histórica.

Relato: música e efeitos permanecem inaudíveis mesmo após clicar em Iniciar e jogar a build Web pelo servidor HTTP.

O projeto usa canais Musica e Efeitos criados em runtime. O modo padrão de áudio Web é Sample, que passa a reprodução e a mistura para a Web Audio API. A configuração foi alterada para **Stream** apenas na Web (`audio/general/default_playback_type.web=0`), usando a mistura do próprio Godot e preservando os canais e controles de volume existentes. Não altera a configuração de áudio do Windows nem força volumes/mute escolhidos pelo jogador.

Essa é uma correção de compatibilidade para o sintoma relatado; a causa exata não foi confirmada por console do navegador. A inspeção automática do navegador não estava disponível nesta sessão. A audição no navegador precisa ser confirmada pelo usuário.

Referência: [Godot — áudio na exportação Web](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html#audio-playback). Stream permite usar o mixer do Godot e seus recursos de áudio, mas pode aumentar a latência em uma exportação sem threads. Os worklets existentes continuam sendo disponibilizados pelo servidor local. Não se habilitam threads ou permissões adicionais do navegador.

Após nova exportação, recarregar http://127.0.0.1:8765/ com Ctrl+F5, clicar dentro do jogo e testar música, chute, pulo e dano. Se continuar sem som, conferir as configurações de volume do jogo e se a aba/site foi silenciado. O código de reprodução automática do motor não foi modificado.
