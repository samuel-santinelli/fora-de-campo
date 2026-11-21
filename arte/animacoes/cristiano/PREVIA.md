# Prévia da espera especial

Abra `previa-espera.html` em um navegador. Não precisa de servidor nem instalação. Mantenha o HTML e `espera-especial-v2-alinhada.png` na mesma pasta.

## Arquivos

- `quadros-v2/quadro-01.png` até `quadro-08.png`: quadros transparentes de 256 × 256.
- `espera-especial-v2-alinhada.png`: folha horizontal de 2048 × 256.
- `espera-especial-v2-alinhada.json`: recortes de origem, escala comum, âncora e durações.
- `preparar-previa.ps1`: exportação reproduzível a partir da folha original, usando System.Drawing do Windows. Não altera o original.

O recorte e alinhamento são operações técnicas autorizadas para esta prévia. Não há redesenho ou geração adicional do personagem. A escala é comum aos oito quadros; a posição usa a sola e o centro da região das chuteiras, não a largura variável da capa. Sola em y=240; eixo de apoio em x=140. As células de 256 pixels servem para revisão. O seletor de 128 pixels mostra uma aproximação do tamanho pretendido no jogo.

Tempos iniciais: 300, 100, 100, 120, 160, 120, 180 e 300 ms. Pausa opcional de 2,2 segundos entre os gestos. Não há interpolação, respiração sintética nem brilho adicional; as variações vêm das oito poses existentes.

## Limites e revisão

A transição da mão entre os quadros 4 e 5 ainda pode saltar. A capa e o rosto variam ligeiramente entre as poses geradas. A prévia ajuda a decidir onde refinar; ainda não comprova uma animação final suave. Ao aprovar, integrar na cena existente sem alterar movimento ou colisões e permitir interrupção imediata por comandos.

Verificações feitas: inspeção visual da folha exportada; PNG de origem com transparência; oito recortes não vazios; nenhum retângulo de destino fora da célula; execução do JavaScript com DOM/canvas simulados verificando reprodução, avanço manual, seleção de quadro, inversão e escala. O HTML não foi validado em navegador real nesta etapa. As cenas e os scripts do jogo permanecem intactos.
