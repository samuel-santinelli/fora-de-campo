# Posto de fiscalização — integração do Impedimento

Sexto painel integrado à fase contínua, reutilizando a referência aprovada `fiscalizacao-impedimento-v1.png` intacta. Início x5850, corte da fonte y816, altura do fundo 607 e escala uniforme 607/816. Fim aproximado x7094; o Impedimento em x6350 fica no miolo opaco do painel.

Transição de entrada de 120 px sobre a área de serviço, que termina perto de x5994. O painel anterior permanece opaco por trás durante toda a mistura. A saída se dissolve na base neutra da entrada do VAR-01, cuja arte ainda está pendente.

Revestimento do piso estendido até x7090. A partir de x5850 usa a alvenaria inferior da própria referência, recortada por UV em renderização, com borda clara contínua sobre a superfície real. Cabine, scanners, grades e cancelas são fundo decorativo; não receberam colisões. Não foram criadas barreiras, plataformas, novas fases ou mudanças de comportamento.

Plataforma do Haaland, terreno, posições de inimigos, câmera, ataques e sequência Impedimento/VAR-01/portão preservados. A prévia HTML identifica agora os seis ambientes como integrados; permanece uma comparação ilustrativa das referências, não uma reprodução do mapa completo.

## Verificação

Godot 4.7.2 headless: ambientes, percurso, Impedimento e VAR-01 — quatro verificações com zero falhas. Confirmam sobreposição completa dos painéis, cobertura dos encontros, extensão do piso, travessia com movimento e pulo reais, combate do guardião, liberação do chefe e ataques do VAR-01. Logs em `verificacoes/fiscalizacao-*.log`.

Persistem mensagens ambientais de certificados, preferências do editor fora do workspace e recursos em uso ao encerrar. Não houve inspeção visual em janela do jogo nem medição de desempenho web nesta etapa. Conferir em partida contraste da bandeira do Impedimento, piso e bordas de transição. Próximo cenário: entrada principal do estádio para o VAR-01.
