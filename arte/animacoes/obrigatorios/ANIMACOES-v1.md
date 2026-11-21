# Muralha e Sentença — primeira etapa de animações

Atualização: corrida do goleiro adicionada e ambos integrados à fase. Ver `INTEGRACAO.md` para uso das folhas, limitações e testes. O texto abaixo registra a etapa original de arte.

Prévia conjunta: `previa-goleiro-arbitragem.html`. Criadas pela ferramenta integrada imagegen duas folhas de oito quadros: `salto-v1.png` (Muralha) e `lancamento-v1.png` (Sentença). Referências originais preservadas. Nenhum script de gameplay ou cena foi alterado nesta etapa; antigos goleiro e árbitro ainda estão na fase.

## Exportação

`preparar-animacoes.ps1` recorta fontes em quatro colunas por duas fileiras e exporta folhas 3072×384, células 384×384, âncora (192,360), dezesseis quadros individuais e metadados. Procura colunas transparentes próximas das divisões nominais (até 48 px) para não cortar botas/luvas que ultrapassam ligeiramente a célula gerada. Centro da âncora continua baseado na coluna nominal, sem recentrar cada pose pela mão ou pela luva. Se não encontrar separação transparente, interrompe a exportação para revisão.

Escala fixa por personagem, calculada pela maior altura visível da sua folha, preservando compressão entre poses. Salto com altura máxima de arte 260 px; lançamento 232 px. A escala proposta de jogo 0,5 é apenas metadado, ainda não aplicada; calibrar altura ereta, cabeça e apoio de pés na integração. Para salto, a altura de voo desenhada não equivale ao salto físico do Godot: ao integrar, usar os estados de subida/queda/aterrissagem e evitar duplicar deslocamento vertical.

## Movimento e prévia

Muralha: preparação, compressão, impulso, bloqueio aéreo, descida, aterrissagem e retorno. Tempos 120,120,90,110,140,110,120,150 ms (960 ms). Ainda não existe folha dedicada de corrida terrestre; produzi-la antes de considerar a substituição visual completa do goleiro. Usar pose pronta para repouso e quadros do salto para bloqueio, preservando perseguição/salto obrigatórios.

Sentença: ergue cartão, avisa, prepara lançamento, abre mão, estende e recolhe braço. Tempos 120,120,180,120,90,110,120,140 ms (1000 ms); primeiro quadro de mão aberta aos 540 ms. A folha mostra amarelo na mão e vermelho junto ao corpo. A prévia alterna a cor do projétil desenhado separado, sem afirmar que há duas folhas de arremesso. Integrar disparo real de cartões amarelos/vermelhos na próxima etapa, mantendo base de movimento e dano e sem desconfigurar variantes de outros projéteis.

Controles de reprodução, pausa, reinício, quadro a quadro, ritmo, espelhamento, escolha de cor e visibilidade do cartão ilustrativo. O cartão se move somente na página, sem colisões/dano. A imagem contém pequenas variações de proporção e resíduos coloridos de contorno a refinar.

## Verificação

Exportador concluído com limites de célula, tolerância alpha de cantos e separação transparente entre sprites. Quadro exportado do goleiro inspecionado como imagem. DOM/canvas simulados confirmaram dimensões, dezesseis quadros, carregamento, controles, pausa e lançamento após aviso. Não houve conferência em navegador real nem testes de gameplay, pois este não mudou nesta etapa.

## Prompts — ferramenta integrada imagegen

### Salto do Muralha

Use case: identity-preserve. Eight-frame jumping block animation of EXACT original goalkeeper Muralha in supplied reference. Preserve original face, medium brown skin, short black curls, petrol TEAL long-sleeve jersey white1, teal shorts/socks, charcoal guards with copper edges, black/turquoise boots, BIG white/dark grey goalkeeper gloves with turquoise grip. EXACT FOUR EQUAL COLUMNS TWO EQUAL ROWS landscape1536x1024, one full body in each384x512 cell, SIDE VIEW FACING LEFT consistently, stable local body center x192 and same physical scale throughout. Sequence:1 low ready with open gloves,2 deep knee compression gloves pull back,3 pushes off extending legs gloves swing forward,4 airborne knees tuck gloves up ahead,5 airborne blocking reach both large gloves toward LEFT in front of face,6 descends knees bend gloves still ahead,7 soft landing deep knee compression with boots planted,8 returns ready similar1. Show jump POSES without large vertical translations in cells: align each pose's lowest boot to same near y480 baseline for export, preview/engine provides vertical travel. Keep adult anatomy and realistic joint motion, visibly different poses, no ball, no horizontal diving or falling flat. Full hair,fingers,boots comfortably inside each cell with transparent gutters. Detailed crisp PIXEL ART with discrete clusters and dark contours, same shading as reference, not smooth painting/3D/chibi. TRUE alpha0 transparent background outside sprites, NO floor,shadows,haze,glow,gradient,colored matte,labels,grid,watermark,extra fingers or characters. Preserve costume and face in every frame.

### Lançamento do Sentença

Use case: identity-preserve. Eight-frame referee card THROW animation of exact original Sentenca in reference. Preserve olive skin, original middle-aged angular clean-shaven face, dark swept hair grey temples, MAGENTA referee shirt black collar/pockets, black shorts and knee socks, black/magenta boots, compact SILVER forearm/shin guards, headset microphone and whistle. EXACT FOUR EQUAL COLUMNS TWO EQUAL ROWS landscape1536x1024, one full body per384x512 cell, SIDE VIEW FACING LEFT consistent, stable body center x210 and boots on near y480 baseline, same adult proportions and physical scale. Eight clear sequential poses:1 ready with yellow card at chest and red card kept at opposite hip,2 forward hand lifts YELLOW card to eye level,3 holds card overhead warning,4 draws throwing forearm back with elbow bent ready to flick,5 flicks hand LEFT with open fingers and releases yellow card (do NOT draw airborne card),6 extended throwing arm empty, red card still at hip,7 retracts throwing hand,8 ready returns with yellow card at chest and red at hip. Two arms only, stable original face and outfit, no hand swaps, no guns or magic weapon. Give safe margins for reaching hand, raised card,hair,boots, no crossing cell boundaries. Crisp detailed PIXEL ART with discrete clusters/dark outlines same as reference; no smooth painting,3D,chibi. TRUE fully alpha0 background outside sprites, no floor/shadow/gradient/haze/glow,labels,grid,watermark,extra characters or floating projectiles. Runtime draws actual moving cards separately. Both cards plain solid rectangular yellow/red, no text.
