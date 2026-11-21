# Quadra e rua — primeira integração ao mapa

`AmbientesIniciais` na cena Fase usa `script_ambientes_iniciais.gd`, atrás dos personagens (z_index -20) e com filtro nearest. Carrega os dois PNGs existentes, sem gerar imagens novas ou outra textura de 8050 px. Quadra começa em x0; rua em x1280, com faixas de mistura de aproximadamente 120 px no início e fim. A rua termina perto de x2682. O fim usa fundo neutro, enquanto as zonas restantes aguardam arte própria.

Fontes mantidas intactas. Fundos são recortados apenas na renderização: linhas 0–724 das imagens, altura de destino 607 px. Isso coloca o topo do piso inicial junto da geometria real. Cada painel usa escala uniforme (607/724), evitando alongar o estádio por toda a fase. Cabine, alambrados, trave e barreiras permanecem decorativos atrás da faixa jogável, sem colisões novas.

Nuvens antigas ficam ocultas na instância da fase porque os novos fundos já incluem céu; cena/arquivo de nuvens e sua lógica foram preservados. Arte antiga fase1.png continua oculta e preservada. Fundo neutro azul cobre o restante do percurso para manter contraste, mas não é arte definitiva dessas zonas.

## Chão e plataformas

`script_terreno_provisorio.gd` continua seguindo os mesmos vértices das colisões. Nos primeiros 2800 px, desenha revestimento de alvenaria a partir de uma região inferior da referência da quadra, em módulos de até 128 px. Topo claro acompanha segmentos e rampas reais. Os vértices físicos não foram alterados, inclusive escada perto de x2320 e plataforma de Haaland em x5200.

Bloco inicial recebe frente de concreto e tampa legível no topo real. Plataformas e piso depois de x2800 mantêm visual provisório. Não há novo TileMap, novos obstáculos, travas, mudanças de posições de inimigos ou alterações na câmera. O material de terreno é uma primeira montagem e pode precisar de ajustes de tamanho de tijolos e transição; não é um atlas artístico final.

## Validação

Godot 4.7.2 headless: verificar_ambientes.gd, verificar_percurso.gd, verificar_obrigatorios.gd e verificar_impedimento.gd — zero falhas. Verificam texturas e escala/corte, ordenação visual, arte antiga oculta, geometria e câmera preservadas, apoio dos obrigatórios, travessia real com movimento/pulo e sequência guardião/chefe/portão.

Permanecem mensagens ambientais sobre certificados, preferências do editor sem acesso de escrita fora do workspace e recursos ainda em uso ao sair. Não houve inspeção visual em janela de jogo nem medição de FPS/memória em build web. Os testes confirmam montagem e comportamento, não qualidade visual final. Conferir em partida bordas de mistura, contraste de personagem/cartões, escada e altura aparente da cabine/alambrado.

Próxima arte: praça esportiva do Neymar e corredor do Mbappé, continuando a paleta e mantendo faixas de chão e saída de tela desobstruídas. A página previa-ambientes.html continua comparando as referências com personagens em escala ilustrativa; ela não reproduz as colisões do jogo.
