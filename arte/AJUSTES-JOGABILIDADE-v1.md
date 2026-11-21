> Atualização: a parte de cenários e obstáculos deste registro foi substituída pelo [percurso v2](cenarios/percurso-v2/DIRECAO-E-INTEGRACAO.md). Sem caixas ou arcos improvisados; Haaland usa o navio. Demais ajustes de combate, pausa e segurança do mapa foram preservados.

# Revisão de jogabilidade e percurso — 08/11/2026

Implementação dos ajustes solicitados após jogar o projeto.

## Configurações

Removidas aba Tela, resolução, tela cheia e função de aplicar janela. Restam três volumes e silenciar áudio, com fundo do vestiário preservado. Removidas também funções de exibição do autoload Preferencias. Painel reduzido a 440 × 450 e ordem de teclado atualizada. Esta decisão substitui as orientações de configuração de tela dos documentos anteriores.

## Nascimento, limites e obstáculos

Cristiano nasce em (220,547), sobre o piso do treino, em vez do antigo pedestal. A colisão do pedestal passa a ser parede do limite esquerdo (x-64..0, altura1600). Câmera limitada à esquerda em0. Se algum erro de geometria ou teleporte levar o personagem abaixo de y1100, dispara a derrota existente, evitando câmera controlável indefinidamente no vazio.

`script_acabamento_percurso.gd` adiciona seis caixas de serviço sólidas, com desenho acompanhando exatamente as áreas físicas, em x1080,2080,3520,4470,5890,6900. Alturas48–60, vencíveis com o salto existente. Acrescenta três degraus em4875,4935,4995 antes da doca do Haaland. Doca mantém dimensões285×138 e posição original, agora sólida, com base de concreto/metal, travessas e degraus, em vez de uma chapa suspensa com passagem por baixo. Reserva de bolas4890 movida para4800 para não nascer dentro do degrau.

Sem novas fases, portais de teleporte ou carregamentos. Adversários terrestres podem ser bloqueados pelas caixas; a travessia pelo jogador é validada, mas dificuldade de perseguidores precisa ser observada em partida.

## Ligação visual entre ambientes

Passagens de serviço do mesmo estádio nos seis pontos de emenda, repetindo metal, luminária, parafusos e sinalização; conduto contínuo atravessa os setores. A faixa de chão original continua alinhada às colisões. Cones de treino identificam a área inicial; doca fica ligada ao pátio industrial.

Arte raster aprovada preservada. Novos módulos usam desenhos nativos em formas de pixels; não foi gerada uma nova panorâmica nem redesenhados todos os objetos dos fundos. As passagens cobrem as emendas e criam continuidade arquitetônica; não garantem correspondência perfeita de todos os elementos pintados nos sete fundos. Elementos decorativos dos PNGs continuam ao fundo; apenas obstáculos físicos e terreno bloqueiam projéteis. Conferir composição em partida antes de considerar o acabamento encerrado.

## Pausa por botão

BotaoPausa no canto superior direito do HUD, reposicionado ao redimensionar viewport. Aciona a mesma pausa de P/Esc. Continuar da sobreposição retoma o jogo. Sem alterar configurações, reiniciar ou abandonar partida.

## Bola e superchute

RayCast da bola agora testa camadas1 (cenário) e4 (inimigos), acompanha o deslocamento seguinte e interrompe no primeiro sólido. Cenário nunca é removido ao receber impacto. Corpos simples da camada de inimigos mantêm fallback de eliminação. Não transforma todos os objetos pintados no fundo em colisões.

Novo comando: tocar C e soltar executa chute normal; segurar C por1s e soltar executa superchute. Enquanto carrega, Cristiano fica parado na pose de preparação, com arco dourado de carga. Normal: dano1, velocidade350. Super: dano2, velocidade480 e efeito de energia1,5vez maior. Ambos gastam uma bola no disparo efetivo, sem gasto ao carregar/cancelar. Direção capturada ao começar; pulo, carrinho ou dano cancelam carga. Soltar enquanto pausado funciona ao retomar. Menu e pausa informam os novos comandos.

## Haaland

Ao causar contato, anima um tranco de0,38s: três poses da folha de avanço existente, deslocamento/inclinação do tronco e impacto dourado. Não foi gerada uma folha de soco nova. Ele para o avanço durante esse gesto; dano sofrido interrompe o tranco, mantendo recuperação0,25s. Dano no jogador continua1, resistência do Haaland continua4.

## Verificação

As 26 verificações verificar_*.gd passaram com exit0 e zero falhas. Logs `verificacoes/revisao-jogabilidade-*.log`. Novo teste cobre nascimento no piso, recuo até a parede, botão de pausa/continuar, caixa bloqueando bola sem ser destruída, carga completa sem gasto, dano2 real e gasto único, gesto do Haaland e proteção contra queda no vazio. Percurso usa movimento/pulo reais até x7800, com inimigos removidos apenas na instância do teste; não valida dificuldade de combate. Testes antigos foram atualizados para liberação do chute ao soltar C, doca sólida e remoção das opções de tela, sem retirar as demais verificações.

A ferramenta de uso do computador falhou ao inicializar com `failed to write kernel assets ... os error3`, portanto não houve conferência em janela real. Sem screenshot validado dos módulos novos nesta etapa. Permanecem mensagens ambientais de certificados e recursos em uso ao encerrar. Próxima conferência em partida: passagem entre fundos, doca, colisão de caixas, posicionamento das barras durante tranco e cadência de C normal/super.
