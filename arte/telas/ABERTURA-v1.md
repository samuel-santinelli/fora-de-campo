# Abertura do menu — aceno, sorriso e Siu

Atualização posterior: sequência integrada no Godot; detalhes em `INTEGRACAO-INICIO.md`. A seção de integração pendente abaixo registra o planejamento original da prévia.

`previa-inicio.html` agora contém a proposta de botões angulares, metal escuro e dourado, faixa vermelha/verde e foco visível. A versão anterior foi preservada em `previa-inicio-v1.html`; `inicio-v1.png` permanece intacta.

Ao clicar em Iniciar jogo: menu sai à esquerda; fundo limpo aparece com Cristiano animado; duas poses alternadas de aceno e brilho no sorriso; preparação, salto com braços elevados, descida e aterrissagem com braços abertos; anel dourado e SIUUU!; passagem dourada encerra a prévia. Duração aproximada 3,18 s. No Godot a troca de cena deve ocorrer uma única vez ao término ou ao pular. A prévia mostra um aviso explícito de conclusão, sem simular uma fase real.

Seis poses-chave raster com desenho próprio e movimento de salto por código, não vídeo nem animação contínua de muitos quadros. Cabeça e roupa variam ligeiramente entre as poses geradas; há franja colorida em algumas bordas, que deve ser avaliada sobre o fundo. O salto é uma interpretação curta da comemoração, sem rotação completa contínua. O fundo limpo mantém a composição mas apresenta pequenas diferenças de arquitetura em relação à capa. A passagem entre capa e camadas usa dissolução curta. Conferir essas limitações na prévia antes de levar ao Godot.

## Arquivos

- `inicio-fundo-v2.png`: estádio sem Cristiano e bola, 1672 × 941, opaco.
- `cristiano-abertura-v1.png`: folha com transparência real, 1254 × 1254. Ferramenta não seguiu a grade/tamanho solicitados, portanto não dividir em células iguais.
- `preparar-abertura.ps1`: identifica limites alfa por regiões inspecionadas; não pinta ou modifica a imagem.
- `cristiano-abertura-v1.json`: seis recortes, âncoras e dimensões reais.
- `abertura-dados.js`: cópia dos metadados carregável por script local, sem fetch bloqueado em file://.
- `previa-abertura.js`: relógio da sequência, desenho dos recortes e efeitos; sem dependências externas.

Quadros mantêm uma escala comum baseada no primeiro personagem, em vez de esticar cada pose à mesma altura. O salto desloca a âncora, não a câmera. Não foram modificados sprites, movimentação ou combate do jogo.

## Interação e verificação

Cliques repetidos em Iniciar são bloqueados durante a sequência. Pular animação e Esc concluem; Rever abertura volta ao menu. Movimento reduzido respeitado: pula a sequência. Não há áudio nem voz nesta versão; SIUUU! é texto e animação. Nenhuma gravação ou voz sintética foi criada. Configurações e Sair continuam demonstrativos.

`node verificacoes/verificar_previa_abertura.cjs`: passou. Verifica recursos locais, seis recortes válidos, término da sequência, efeito SIUUU!, cliques repetidos, repetição, pular, Esc e movimento reduzido com DOM/canvas simulados. Não houve inspeção no navegador real. A adaptação de formatos estreitos permanece demonstrativa; conferir recorte do personagem na execução local.

## Integração pendente

As cenas e scripts do Godot permanecem iguais nesta etapa. Na integração, reaproveitar botões/callbacks e música existentes, resetar variáveis só ao começar nova partida e usar uma única transição guardada contra cliques repetidos. Sem lógica nova no personagem jogável. Preservar início rápido com opção de pular. Não anunciar o menu como integrado ainda.

## Prompts — ferramenta integrada imagegen

### Fundo separado

Edit this approved pixel-art game title image. Remove ONLY Cristiano Ronaldo, his entire red cape, the football, and their cast shadow/gold glow on ground. Reconstruct the stadium wall and pavement naturally behind them. Preserve all other architecture, sky, lighting, cameras, lamps, tunnel, image dimensions and pixel-art rendering exactly. Keep the empty dark left UI space. No character, ball, text, UI or new objects. Full opaque clean background plate for animating the original character as a separate layer.

### Poses do Cristiano

Create a transparent-background animation SPRITE SHEET of the EXACT Cristiano Ronaldo character from the supplied approved title artwork. Detailed pixel art matching his recognizable face, swept dark hair/shaved sides, red Portugal7 jersey, green shorts, red socks, gold shoulder/forearm/shin armor and gold football boots, red cape with gold border. No ball. SIX full-body frames arranged precisely THREE equal columns by TWO equal rows, no labels, no borders, no background, real alpha transparency. Each frame contains ONE character, same head/body size across frames, generous transparent padding, complete hands/cape/boots. Canvas1536x1536, eachcell512x768; ground-contact baseline around720 within eachcell; standing character height about620pixels. Read order left to right top row then bottom row. Frame1: facing viewer three-quarter, friendly toothy smile, right open hand raised to wave. Frame2: same stance with raised open hand tilted other way, waving at viewer. Frame3: crouch preparing jump, knees flexed, hands drawing up, cape follows. Frame4: airborne trademark SIU celebration, torso twisting, both arms raised over head, knees bent, body visibly elevated but same anatomical size. Frame5: rotation approaching landing, arms sweeping down and outward, legs spreading. Frame6: iconic SIU landing pose, feet wide planted, torso proud, both straight arms down and outward, open hands, mouth open celebrating, cape settles. Same adult athletic proportions and consistent character identity in allsix, no chibi/cartoon shrink. Maintain actual pixel-art shading, no photoreal or smooth3D. No lettering, speech, stars, effects or cast floor shadows. All visible backdrop must be truly transparent. This is a short animation for an academic game menu.
