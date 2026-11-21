# Percurso atual — revisão v2

A versão atual usa sete novos panoramas ligados pela mesma orla, mapa de 13.000 px e Haaland desembarcando de um navio viking. Caixas, degraus, arcos e a doca provisória foram removidos.

[Prévia atual](percurso-v2/previa-percurso.html) · [Posições, integração e prompts](percurso-v2/DIRECAO-E-INTEGRACAO.md).

---

## Histórico v1 — substituído

As posições e descrições abaixo pertencem à versão anterior.

# Percurso contínuo — distribuição dos encontros

Revisão de 08/11: nascimento no piso, limite esquerdo fechado, seis obstáculos, degraus e doca sólida do Haaland, passagens de serviço ligando fundos. Detalhes em `../AJUSTES-JOGABILIDADE-v1.md`. Atualização substitui as descrições históricas abaixo de pedestal e plataforma vazada.

Entrada principal do VAR-01 integrada: `INTEGRACAO-ENTRADA.md`. Os sete ambientes cobrem a fase até x8050. Centro do túnel alinhado ao portão em x7800; nenhuma mudança nas posições ou colisões. Imagem e prompt original em `REFERENCIA-ENTRADA-v1.md`. Portão adaptado com folhas metálicas e animação sincronizada: `INTEGRACAO-PORTAO.md`. O usuário validou o cenário em partida; acabamento do novo portão ainda requer conferência visual.

Posto de fiscalização do Impedimento integrado à fase: `INTEGRACAO-FISCALIZACAO.md`. Sexto painel em `fiscalizacao-impedimento-v1.png`; prompt original em `REFERENCIA-FISCALIZACAO-v1.md`.

Área de serviço do Haaland integrada: `INTEGRACAO-SERVICO.md`. Usa `servico-haaland-v1.png` e deck metálico alinhado à plataforma existente. Fonte e prompt em `REFERENCIA-SERVICO-v1.md`.

Praça do Neymar e corredor do Mbappé integrados ao jogo: `INTEGRACAO-CENTRO.md`. Prévia das sete referências em `previa-ambientes.html`; prompts da praça/corredor em `REFERENCIAS-CENTRO-v1.md`. As seções abaixo preservam o histórico de criação do percurso.

Atualização de arte: quadra e rua integradas ao início da fase; detalhes em `INTEGRACAO-INICIO.md`. Fontes e prompts em `REFERENCIAS-v1.md`, comparação em `previa-ambientes.html`. Os demais trechos continuam provisórios. As descrições abaixo sobre terreno totalmente provisório registram a etapa inicial do percurso.

Mapa de consulta em `percurso.html`. Cena Fase ampliada para aproximadamente 8050 px; câmera ajustada apenas na instância da fase por script_encontro_impedimento.gd. Não altera movimentação, salto, dano, vidas ou duração dos ataques. Não cria novas fases, carregamentos, arenas ou travas para cada inimigo.

## Posições locais da fase

| Encontro | Antes | Agora | Ambiente a produzir |
|---|---|---|---|
| Muralha | (846,547) | (846,547) | Quadra de treino |
| Sentença | (1303,553) | (1850,553) | Rua com barreiras |
| Neymar | (1900,497) | (3150,547) | Praça esportiva |
| Mbappé | (2230,548) | (4050,548) | Corredor de acesso |
| Haaland | (2520,405) | (5200,405) | Área de serviço |
| Impedimento | (2670,547) | (6350,547) | Posto de fiscalização |
| VAR-01 | (2756,511) | (7450,511) | Entrada principal |
| Portão | (2868,516) | (7800,516) | Estádio |

Raiz Fase continua com deslocamento y=6. Posições de spawn podem ser corrigidas ligeiramente pelo move_and_slide ao apoiar no piso. Distâncias entre encontros a partir do segundo são aproximadamente 900–1300 px. Isso organiza apresentação e reduz concentração, mas não garante combate isolado: perseguidores podem acompanhar o jogador, e os rivais comuns não bloqueiam passagem. A sequência guardião/chefão e o portão continuam funcionando como antes.

## Terreno

Piso contínuo estendido até x8050. Subida central deslocada 700 px para a direita, começando perto de x2320, depois da arbitragem. Mantém degraus e desníveis existentes. Plataforma elevada que sustentava Haaland foi movida para x5200, com mesma largura/altura e colisão de mão única. Parede final movida para o fim do mapa.

A antiga imagem fase1.png permanece como recurso na cena e no disco, mas seu Sprite2D está oculto: ela não corresponde mais às posições das plataformas. `script_terreno_provisorio.gd` desenha o mesmo polígono e retângulos das colisões, com topo legível, sem nova textura grande ou processamento contínuo. Esse visual é provisório para validar espaço e caminho; NÃO representa o cenário final. Nuvens existentes preservadas. Substituir o desenho provisório por arte adequada depois de validar a distribuição.

Não foram produzidas imagens novas nesta etapa. Aumentar distância não exigiu novas cópias gigantes de fundo; o custo final dependerá dos futuros tiles, camadas e efeitos. Ainda não foi medido desempenho em build web.

## Validação

`verificar_percurso.gd`: zero falhas. Confirma ordem/espaçamento, apoio dos personagens, limite de câmera e travessia usando movimento/pulo reais até x7800, com inimigos removidos somente no ambiente temporário do teste. Isso valida a geometria navegável, não a dificuldade da partida completa.

Regressões de obrigatórios, Mbappé, Haaland, Neymar e Impedimento: zero falhas; o teste do Impedimento também verifica chefe e portão na fase real. Total seis verificações. Mensagens ambientais de certificados, UIDs com fallback por caminho e recursos em uso ao encerrar continuam presentes. O controle do mapa HTML foi verificado com DOM simulado; sem inspeção em navegador real.

Conferência em partida pendente: ritmo entre encontros, perseguição que atravessa trechos e legibilidade do terreno provisório. Não há barreiras novas obrigando a derrotar todos os rivais. Próxima etapa: referência artística da quadra e rua, seguida de módulos de cenário alinhados às plataformas; usar a ordem deste documento como fonte atual das posições. Documentos de integração mais antigos contêm posições históricas.
