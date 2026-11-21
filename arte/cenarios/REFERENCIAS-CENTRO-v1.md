# Praça do Neymar e corredor do Mbappé — referências v1

Atualização: integração ao jogo concluída em `INTEGRACAO-CENTRO.md`. As pendências abaixo registram a criação das referências anterior à montagem.

Imagens criadas pela ferramenta integrada imagegen: `praca-neymar-v1.png` e `corredor-mbappe-v1.png`. Fontes opacas preservadas no projeto, inspecionadas na saída do gerador. A rua existente foi usada como referência de estilo e iluminação. São referências novas, ainda NÃO consumidas pelo Godot; apenas quadra/rua estão integradas nesta etapa.

## Identidade

Praça: espaço aberto com cobertura de descanso, bancos, jardineiras, pintura verde/amarela discreta e pequena quadra ao fundo. Corredor: acesso semiaberto ao estádio, pilares e grades repetidos horizontalmente e luzes frias. Ambos preservam o entardecer azul e o estádio à direita, sem personagens ou texto na imagem. Elementos decorativos devem permanecer atrás da passagem, sem novas colisões.

O corredor tem uma faixa magenta discreta na parede herdada da referência, embora a intenção principal seja azul/cinza; avaliar se interfere no contraste antes da integração. Pilares e cobertura pertencem ao fundo: não devem ser apresentados como plataformas utilizáveis. Não foram geradas novas plataformas ou obstáculos.

## Prévia

`previa-ambientes.html` agora permite escolher entre quatro ambientes e sobrepor o adversário correspondente: Muralha, Sentença, Neymar ou Mbappé, além de Cristiano. Adicionadas configurações por ambiente para tamanho de célula e âncora dos sprites: obrigatórios usam 384×384; Neymar/Mbappé usam 256×256. A guia do chão para as imagens novas fica aproximadamente em y460 na prévia; isso não define a altura do terreno no Godot.

Testes com DOM/canvas simulados confirmaram os nove arquivos usados, as quatro opções, associação de personagem/célula e controles de personagem/guia. Sem inspeção em navegador real. Nenhuma cena, script de gameplay ou colisão foi alterada nesta etapa.

## Próxima integração

Alinhar recorte vertical ao topo real do piso de cada imagem: ele difere ligeiramente dos 724 px usados nos dois fundos anteriores. Não reutilizar esse corte sem conferir. Posicionar painéis perto do trecho de Neymar (x3150) e Mbappé (x4050), com transições na subida/fim da rua e entre praça/corredor. Preservar plataforma de Haaland, câmera, pontos de spawn e geometria já validados.

Não são imagens seamless; misturar bordas e/ou preparar módulos em vez de repetir literalmente o estádio. Usar o corredor como fundo e aplicar revestimento do chão à colisão real. Verificar contraste de uniforme amarelo do Neymar e azul do Mbappé, bola dourada e rastro azul. A arte dos trechos finais continua pendente.

## Prompts — ferramenta integrada imagegen

### Praça

Use case: stylized-concept. NEW environment reference for detailed PIXEL ART 2D SIDE-SCROLLING football platformer FORA DE CAMPO. Third zone: OPEN SPORTS PLAZA for agile dribbler Neymar. Input access-street image is style, pixel density, dusk palette, framing and floor height reference ONLY: create clearly DIFFERENT plaza composition, do not repeat same tree, booth, lamp placements or stadium crop. Landscape1672x941 or matching16:9. Foreground STRICT ORTHOGRAPHIC SIDE VIEW, continuous flat walkway top exactly at about77% height, clear LEFT-to-RIGHT playable lane, light worn concrete top rim, dark masonry/soil cutaway below. Midground entirely BEHIND lane: spacious public sports square with low planters, restrained green/yellow geometric paint on low back wall (NO letters), benches, small fenced futsal area farther back, a modest open canopy for resting athletes. Low objects behind lane, no fake platforms or obstacles across front. More open negative space and soft vegetation than referee street, no inspection booth. Background urban silhouettes and stadium appearing slightly closer to RIGHT, dusk blue sky with muted clouds and a few warm amber lights, same time/weather as reference. Discrete crisp PIXEL ART clusters, dark contours, controlled limited shading. Keep background lower contrast at character height so yellow Neymar, red/gold Cristiano and gold ball are clear; green/yellow accents subtle, no saturated wall behind yellow torso. No people, enemies, characters, balls, vehicles, HUD,labels,readable signs,logos,watermark. No floor perspective in playable lane, no isometric view, no 3D,photorealism,blur,glow fog or painted gradients. Opaque full background. Art-direction reference, not a tile atlas or new level.

### Corredor

Use case: stylized-concept. NEW adjacent environment reference for detailed PIXEL ART 2D SIDE-SCROLLING football platformer FORA DE CAMPO, fourth zone: STADIUM ACCESS CORRIDOR for fast rival Mbappe. Input image is pixel-art style, dusk lighting, floor height and palette reference only, NOT composition to duplicate. Wide landscape1672x941 or16:9. Long outdoor/semi-covered PEDESTRIAN stadium approach shown STRICT SIDE ELEVATION, not a tunnel vanishing into center, not top-down/isometric. Horizontal clear playable foreground LEFT to RIGHT, flat concrete path top at about77% image height, light solid rim, darker masonry cutaway underneath. Behind lane: long low steel railings, repeating thin stadium-support columns aligned horizontally, sparse overhead canopy beams with subtle cool blue strip fixtures, modest painted track bands parallel to movement BEHIND lane, darker blue-grey stadium access wall. Architectural repetition and left-to-right lines communicate speed but keep empty space between pillars, no fence or pillar crossing the playable foreground. Distant stadium facade closer to RIGHT, some dusk blue sky visible above and between canopy, small warm windows for continuity. Palette muted blue/steel/grey with restrained CYAN lights, no neon cyberpunk, no yellow/orange hazard motif (reserved for later guard), no huge red panels. Background at player height low contrast so navy Mbappe, red/gold Cristiano and blue trail remain legible. Different from neighborhood plaza: no big trees, benches, practice goal or inspection booth dominating. Detailed crisp pixel clusters and dark clean contours, coherent limited shading matching reference. No people,characters,enemies,balls,vehicles,HUD,text,logos,watermarks. No foreground props/fake platforms, no motion blur, glow fog, photo,3D or smooth painted gradients. Complete opaque background; art-direction reference only, not collision geometry or new level.
