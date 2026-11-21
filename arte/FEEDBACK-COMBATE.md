# Superchute, alerta de sobrevivência e goleiro

Implementação de 08/11/2026, mantendo os sistemas de combate existentes.

- Superchute: câmera aproxima até 4,5% durante a carga, com deslocamento leve em direção ao chute. Ao nascer a bola de dano 2, dispara foco de até 7,5% e tremor de até 5 px durante 0,24 s, com retorno ao longo de 0,42 s. Chute comum não dispara tremor. A velocidade da partida permanece normal. Pausa congela o efeito e derrota restaura os valores da câmera.
- Vida crítica: ativa com 1–3 pontos de vida. Bordas vermelhas pulsantes, centro transparente, aviso abaixo dos recursos. Intensidade aumenta com a perda de vida; pulsação congela na pausa. Ao curar acima de 3 pontos, desaparece suavemente. HUD e painel de pausa ficam acima da sobreposição.
- Muralha: animação legada de corrida desabilitava a colisão de ataque; a adaptação visual interrompia a animação antes de alcançar a chave de ataque. Agora perseguição e salto mantêm a física existente sem executar essas trilhas antigas. Área própria acompanha o corpo; contato real dá dano com intervalo de 0,9 s. Também verifica sobreposição persistente, para não depender de sair e entrar novamente. Inativo ou derrotado não dá dano. RayCast acompanha a direção do salto.

Scripts: `script_camera_impacto.gd`, `script_alerta_vida.gd`, `script_muralha.gd`; integração no personagem e HUD.

Teste `verificacoes/verificar_feedback_combate.gd`: carga e disparo reais pelo Input, aproximação e tremor, restauração da câmera, chute comum, vida crítica, cura, pausa, derrota, contato físico do goleiro, intervalo e novo contato após intervalo. Logs `verificacoes/feedback-*.log`.

Verificações automatizadas executadas em modo headless. A intensidade e a aparência dos efeitos ainda precisam ser conferidas em partida; testes sem janela não substituem essa avaliação visual.
