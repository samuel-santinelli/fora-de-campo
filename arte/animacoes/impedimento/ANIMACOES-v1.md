# O Impedimento — avanço e aviso v1

Registro da etapa de arte. Integração posterior concluída e documentada em `INTEGRACAO.md`; as observações abaixo sobre gameplay pendente descrevem o estado na criação da prévia.

Prévia em `previa-confronto.html`. Duas folhas criadas pela ferramenta integrada imagegen: `avanco-v1.png` e `aviso-v1.png`, oito poses em cada, quatro colunas por duas fileiras. Referência preservada em `../../referencias/impedimento-v1.png`. Nenhuma cena ou script de gameplay alterado nesta etapa; guardião ainda não integrado à fase.

## Exportação e ritmo

`preparar-animacoes.ps1` usa System.Drawing apenas para recortar, alinhar e redimensionar por vizinho mais próximo. Exporta folhas 3072×384, células 384×384, âncora (230,360), dezesseis PNGs individuais e pose parada. Avanço: 110,95,90,95,110,95,90,95 ms (780 ms). Aviso: 70,70,80,110,180,110,100,80 ms (800 ms), sustentando bandeira acima da cabeça antes de baixar para a investida.

Uma escala fixa por sequência, calibrada pela altura da primeira pose pronta (264 px), preserva a oscilação dentro de cada folha e reserva espaço para a bandeira erguida. Não redimensiona cada pose individualmente e não usa a altura máxima da bandeira para diminuir o robô. Essa calibração é aproximada: as folhas geradas têm pequenas diferenças de proporção e devem ser conferidas pelas posições do capacete e sola antes da integração. Linha de chão comum por fileira; âncora horizontal baseada no corpo, não no centro da bandeira.

Pose parada normalizada pela referência completa, sem tamanho definitivo no jogo. Célula maior reserva espaço para bandeira; a futura colisão deve acompanhar somente o corpo. Na escala de integração a definir, ajustar tamanho visual sem ampliar alcance de contato involuntariamente.

## Prévia

Sequência demonstrativa: avanço 900 ms, aviso 800 ms, investida 300 ms e recuperação 700 ms. Investida reutiliza avanço com cadência 2,3× e linhas de movimento desenhadas na página; não há nova folha de investida. Controles de pausa, reinício, quadro, modo isolado, ritmo e espelhamento. Referência parada ao lado.

Esses tempos e efeitos são apenas proposta visual. Ainda não implementados dano, deslocamento real da investida, sinalizador amarelo, posição na fase ou resistência. Reaproveitamento de gameplay previsto em `../../referencias/impedimento-v1.md`.

## Verificação e limitações

Exportação concluída com limites de células e fundo nos cantos conferidos. Um canto do aviso tem alpha 1/255; validação admite alpha até 2/255 como praticamente transparente, sem alterar pixels da fonte. Foram inspecionados quadros exportados: preservados visor, bandeira e silhueta, mas há resíduos vermelhos/amarelos em alguns contornos que precisam de limpeza posterior. Não considerar bordas totalmente limpas.

DOM/canvas simulados confirmaram dimensões, carregamento, dezesseis PNGs, controles, pausa, mudança de estados, investida e recuperação. Não houve execução em navegador real nem teste de gameplay no Godot nesta etapa. Referências anteriores preservadas.

## Prompts — ferramenta integrada imagegen

### Avanço

Use case: identity-preserve. Create a production sprite sheet of the exact original robot O Impedimento in the supplied reference. Preserve black/silver segmented armor, narrow amber helmet visor, metal football boots, yellow/orange shoulder/knee panels, and short mounted four-quadrant yellow/orange assistant-referee flag on forward LEFT forearm. EXACT EIGHT walking/advancing poses in FOUR EQUAL COLUMNS by TWO EQUAL ROWS on landscape1536x1024. Full body SIDE VIEW FACING LEFT throughout. Same helmet/body proportions and physical scale in all cells, planted soles share ground baseline near y480 within each 512px tall cell, robot helmet near y100. Hip near x230 within each384px wide cell, flag extends in front toward left, every flag corner and boot comfortably inside its own cell. Purposeful measured mechanical advance with natural articulated joints, opposite leg contacts, knee compression, passing pose and opposite contact; eight distinct sequential poses forming seamless loop. Small controlled opposite free-arm swing, forearm flag stays mounted and near chest height with only slight fabric flutter, no giant waving. One flag and two arms/two legs per pose. Crisp detailed pixel art, discrete clusters, dark contours, coherent metal highlights, same world/style as reference. TRUE fully transparent alpha0 background outside all eight sprites; no glow, haze, gradient, colored fringe, shadow, floor, dust, labels, grid or watermark. No extra figures, text, human skin, cape, weapons, monitor or red cards. Preserve flag geometry and identity.

### Aviso

Use case: identity-preserve. Eight-frame anticipation/FLAG WARNING sheet of the EXACT original robotic assistant-referee in supplied reference, O Impedimento. Preserve black/silver armor, narrow amber visor, metal football boots, four alternating yellow/orange quadrants on one mounted forearm flag, all robot proportions. EXACT FOUR EQUAL COLUMNS TWO EQUAL ROWS on1536x1024. Every cell384x512 contains one fully visible same-scale side-facing LEFT robot, consistent local hip x230, boot baseline y480. Keep robot HELMET at local y120 in every pose (body from y120 to480, about360 pixels high); leave space above to raise flag toward y20, without resizing body. ALL BOOTS STAY PLANTED IN SAME WIDE STANCE, two arms two legs, only torso/shoulder/flag-arm articulate. Frame1 ready flag at chest height,2 bends knees slightly arm begins lifting,3 elbow rises flag passes face without obscuring visor,4 flag raised above helmet,5 overhead flag held upright in unmistakable assistant-referee warning,6 slight torso forward lean with raised flag held,7 elbow lowers partly with front knee braced ready to launch,8 low tense poised-to-dash stance with flag angled forward. Clear arm progression, flag stays mechanically attached to SAME forearm, flag fabric visible left of pole, not a separate handheld flag swapping hands. Original robot, no humans. Crisp detailed pixel art and dark outlines, same style as reference, no 3D or painting. All heads, flag corners, boots completely inside own cells, transparent gutters. TRUE fully alpha0 background everywhere outside characters. NO background glow,haze,gradient,matte,shadow,floor,ghosts,speed lines,labels,grid,watermarks,extra arms or figures. No monitor head, red card, cape or weapons.
