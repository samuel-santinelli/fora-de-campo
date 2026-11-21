# FORA DE CAMPO — capturas de divulgação

Autor: **Samuel Santinelli Mantovani**. Base acadêmica: professor **Leandro Fernandes da Mota**.

19 arquivos PNG: **cinco peças promocionais com frases** e **14 capturas sem sobreposição editorial**. As capturas são Full HD; as cinco edições mantêm o enquadramento panorâmico em resolução alta, registrada individualmente em `manifesto.json`. Abra `galeria.html` para revisar, filtrar e baixar as imagens. O ZIP atualizado é `entrega/ForaDeCampo-Prints-HD.zip`.

## Origem das imagens

Os pixels foram renderizados pelo Godot 4.7.2 a partir de **`builds/Windows/ForaDeCampo.pck`**, o pacote que acompanha o executável distribuído. O utilitário externo `verificacoes/capturar_divulgacao.gd` prepara posição, câmera, resolução e estados de combate para registrar cada ação. O motor executado é o console Godot da mesma versão, carregando o PCK exportado, não as cenas e artes soltas do workspace. A interface mantém enquadramento lógico 1152×648, com saída Full HD em Canvas Items.

Posteriormente, a pedido do autor, cinco imagens foram editadas com **imagegen** para receber frases em branco/dourado e fundo discreto de contraste no céu. Elas são peças de divulgação, identificadas na galeria, e substituem as versões sem frase nos mesmos arquivos. As outras 14 mantêm os pixels da captura original. O jogo também utiliza arte assistida por IA. As cenas preparadas para registro não constituem uma gravação de uma partida completa. Prompts em `PROMOCIONAIS-PROMPTS.md`.

As versões anteriores dessas cinco imagens foram substituídas na pasta de divulgação e no ZIP. A pasta antiga `entrega/capturas/`, com a galeria anterior, foi removida a pedido do autor. Esta é a seleção atual para o site e o trabalho. O utilitário de captura bruta grava em `entrega/capturas-renderizadas/`, para não sobrescrever acidentalmente as peças aprovadas.

## Ordem sugerida no itch.io

1. `18-desvio-do-laser.png` — combate contra o chefe e desvio visível.
2. `14-superchute-em-chamas.png` — ataque carregado em ação.
3. `07-haaland-navio.png` — identidade do cenário viking.
4. `16-arrancada-do-mbappe.png` — rival em movimento e pulo.
5. `17-cartao-vermelho.png` — arbitragem e projétil obrigatório.
6. `15-carrinho-relampago.png` — ataque de curto alcance.
7. `03-treino.png` — frase sobre o caminho até a final.
8. Incluir também início/configurações/pausa/derrota/vitória e os demais ambientes para cobrir integralmente o enunciado. Na galeria, as cinco peças com frase aparecem juntas no filtro inicial; as duas ações sem frase ficam em Percurso.

O colapso do VAR-01 e a vitória revelam o final; se quiser, deixe essas imagens por último. Os nomes numerados também permitem ordenar as telas e o percurso para o relatório acadêmico.

## Créditos para copiar no site

Desenvolvimento e adaptação: Samuel Santinelli Mantovani.

Base de programação e estrutura: projeto fornecido pelo professor Leandro Fernandes da Mota.

Projeto acadêmico com adaptação de personagens, cenários, interface, combate e áudio. Contém artes e código produzidos com assistência de inteligência artificial.

Página informada pelo autor: https://samuel-santinelli.itch.io/fora-de-campo. O autor confirmou o teste das versões Web e Windows. A publicação do fonte é a próxima etapa após estes materiais.
