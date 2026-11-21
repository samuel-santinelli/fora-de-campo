# Área de serviço do Haaland — referência v1

`servico-haaland-v1.png`, criada pela ferramenta integrada imagegen com o corredor do Mbappé como referência de estilo/luz. Fonte opaca salva no projeto e inspecionada na saída do gerador. Ainda não integrada à fase: nenhuma cena, script de gameplay ou colisão foi modificada nesta etapa.

## Aparência

Pátio de manutenção do estádio com portões de carga, vigas, tubulações, equipamentos atrás de um muro baixo e iluminação âmbar. Mantém céu de entardecer e estádio próximo. Concreto e metal reforçam a presença do Haaland sem adicionar objetos viking ao cenário. Portões fechados pertencem ao fundo, não bloqueiam o caminho horizontal do jogador.

A imagem deixou o piso mais baixo que nas referências anteriores: topo da faixa sólida frontal próximo de y816, em vez de 724/738. Não reutilizar automaticamente o corte vertical dos outros painéis. Na integração, ajustar escala pelo chão real e recorte inspecionado, evitando sobrepor uma segunda linha de chão à geometria.

## Prévia e plataforma

`previa-ambientes.html` agora inclui quinta opção, área do Haaland, com sprite parado existente em célula 320×320, âncora (140,300), escala 0,5. Guia de chão ilustrativa y508; superfície da plataforma 140 px acima. A plataforma é um desenho separado da página, sem colisão ou nova arte raster. A diferença de altura do Haaland já está no sprite exportado, sem multiplicar novamente por 1,2.

A plataforma real continua em x5200, largura 285, com superfície perto de y467 na fase. A futura arte deve acompanhar essa superfície, preservando a colisão de mão única e a passagem, sem usar a referência de fundo como física. Não inserir novas caixas ou portões na faixa de combate.

Prévia verificada com DOM/canvas simulados: cinco ambientes e arquivos associados, recorte do sprite Haaland, apoio visual na plataforma e controles. Não houve inspeção em navegador real nem teste de gameplay, pois ele não foi alterado.

## Próxima etapa

Integrar painel após corredor, com sobreposição suficiente para transição inteira de 120 px e corte próprio. Uma posição inicial próxima de x4750 pode cobrir Haaland em x5200; confirmar cobertura e reserva para fiscalização do Impedimento em x6350. Preparar revestimento de concreto/metal da plataforma separadamente, sem redimensionar colisões. Conferir contraste do uniforme vermelho e capa de pele sobre a parede cinza. Esta referência não é seamless nem atlas de tiles.

## Prompt — ferramenta integrada imagegen

Use case: stylized-concept. NEW environment art-direction reference for detailed PIXEL ART 2D SIDE-SCROLLING football platformer FORA DE CAMPO. Fifth zone: STADIUM SERVICE YARD for heavy armored rival Haaland. Supplied stadium corridor is reference ONLY for crisp pixel art, dusk palette, floor height and visual world. Create a distinct maintenance/loading yard, not repeated cyan pedestrian canopy. Wide landscape1672x941 or16:9. Strict orthographic SIDE VIEW at foreground, horizontal playable lane clear LEFT to RIGHT. Flat worn concrete foreground top around77% image height with readable pale rim and dark masonry/soil cross-section beneath. BEHIND walking lane: massive concrete stadium service facade, broad CLOSED loading-bay roller doors in muted steel grey, dark metal braces and exposed pipes, restrained maintenance equipment parked deep behind low divider wall, practical warm amber worklights. Partial stadium roof and blue-hour dusky sky above. Heavy industrial shapes, visible bolts, modest wear and damp patches, muted slate/charcoal/concrete with small amber/copper accents, keeping red Norway jersey and grey fur cape readable. A couple of low dark service crates deep in background, NO crates or vehicles blocking foreground. NO yellow/orange checkerboard banners or inspection-booth imagery reserved for later guard. NO red glowing camera fortress reserved for final boss. Do NOT draw a raised playable platform into background: Haaland has an existing elevated platform that will be drawn separately aligned to game collision. Leave uncluttered wall space in middle-right behind where that platform will go; no ledges pretending to be jumpable. Crisp pixel clusters, dark coherent outlines, limited detailed shading matching reference, not photoreal, smooth painting, 3D or isometric. No people,characters,enemies,balls,HUD,text labels,readable signs,logos,watermark,foreground fog or glow bloom. Complete opaque background, not tile atlas.
