# Estado da entrega — 21/11/2026

## Jogo

| Requisito | Situação |
|---|---|
| Andar, pular, ataque próximo e bola | Implementados; carrinho e chute com identidade própria |
| Vida, munição, coletas e derrota | Implementados e testados |
| Arbitragem que atira cartões | Sentença lança cartões amarelos e vermelhos |
| Goleiro perseguidor que salta | Muralha persegue e salta |
| Três inimigos e chefão | Sete adversários contando VAR-01 |
| Chefão cartão vermelho com ataque | VAR-01 com cartão no corpo, braços/pernas, laser e golpe no chão; visual aprovado pelo autor do projeto |
| Início, fase, pausa, game over e final | Integrados e testados |
| Sons de ações e inimigos | Efeitos originais; substituídos os MP3s herdados de pulo/chute/carrinho/dano/coleta |
| Músicas distintas | Início, fase e derrota com trilhas próprias |
| Web e Windows | ZIPs exportados e conferidos; tamanhos e hashes em `pacotes.json` |

As 36 verificações Godot passaram na última alteração de gameplay, incluindo derrotas individuais e colapso do chefe. O teste das derrotas passou também dentro do PCK Web. O usuário testou e aprovou os ajustes. Este registro não substitui a avaliação acadêmica do professor.

## Materiais da página

- Descrição, objetivo, história e comandos: `PAGINA-ITCH.md`.
- Imagens atuais para o site e o trabalho: `divulgacao-v1/`, com início, configurações, sete ambientes, pausa, derrota, vitória e ações de combate. A pasta antiga de capturas foi removida.
- Guia de publicação: `PUBLICAR-ITCH.md`.
- Seleção de divulgação em `divulgacao-v1/`: 19 PNGs, com cinco peças promocionais com frases e 14 capturas Full HD sem sobreposição editorial. Galeria local e ZIP `ForaDeCampo-Prints-HD.zip` atualizados. As versões antigas foram substituídas e a galeria anterior foi removida.
- Código editável: `ForaDeCampo-CodigoFonte.zip`, produzido por `empacotar-fonte.ps1`; manifesto em `fonte-manifesto.json`.

O ZIP do fonte foi extraído em uma pasta separada e importado novamente pelo Godot. Os testes das cinco cenas e das sete derrotas passaram nessa cópia, sem depender do cache original. Quantidade, tamanho e hash atuais em `fonte-pacote.json`. Esse ZIP contém o projeto editável e as dependências das cenas; capturas e executáveis são materiais separados da entrega.

As capturas usam o jogo renderizado pelo Godot, com posicionamento e estados preparados para registrar as telas. As prévias HTML de arte não foram usadas como screenshots do jogo.

## Falta concluir fora do projeto local

1. Inserir os prints e os créditos na página do itch.io. Autor: Samuel Santinelli Mantovani. Professor: Leandro Fernandes da Mota.
2. Publicar o código no GitHub ou Drive e conferir o acesso do professor.
3. Registrar a URL do fonte e inserir prints do site no trabalho/Classroom.

Página informada pelo autor: https://samuel-santinelli.itch.io/fora-de-campo. O autor confirmou o jogo Web funcionando e o teste do download Windows. A ferramenta de leitura Web não conseguiu abrir o endereço nesta sessão; a confirmação de funcionamento é do autor. O requisito do site ainda depende da inclusão dos prints e dos créditos; o link do código-fonte permanece pendente.
