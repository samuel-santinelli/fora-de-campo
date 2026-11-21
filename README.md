# FORA DE CAMPO

Jogo de plataforma acadêmico em Godot. Cristiano atravessa um percurso até o estádio, enfrenta rivais e derrota o VAR-01 para disputar a final.

## Abrir o código

1. Instale Godot **4.7.2 Standard** (sem .NET).
2. Extraia o pacote de código em uma pasta própria e importe `project.godot` pelo gerenciador do Godot.
3. Aguarde a importação das imagens e dos áudios. O cache `.godot` será criado automaticamente.
4. Pressione **F5** para executar a cena inicial.

O projeto usa GDScript e o renderizador Compatibility. Não precisa de Node para jogar ou editar; Node e PowerShell são usados apenas nos utilitários de síntese, verificação e empacotamento.

## Controles

| Ação | Teclas |
|---|---|
| Mover | A/D ou setas esquerda/direita |
| Pular | W ou seta para cima |
| Carrinho | Espaço |
| Chutar | C: tocar e soltar |
| Superchute | C: segurar por 1 segundo e soltar |
| Pausar | P, Esc ou botão na tela |

Os controles são de teclado, para computador. O jogo contém fase única com sete ambientes conectados, coletas de saúde e bolas, apresentações dos rivais, pausa, derrota e conclusão no estádio.

## Estrutura

- `cena_inicio.tscn`, `cena_fase.tscn`, `cena_game_over.tscn`, `cena_final.tscn`: telas principais.
- `script_personagem.gd` e scripts das animações: protagonista.
- `script_resistencia_inimigo.gd`, `script_derrota_inimigo.gd`: vida e derrota dos adversários.
- `arte/`: imagens, animações e documentação de direção de arte.
- `Sons/Identidade/` e `Sons/Trilhas/`: efeitos e músicas usados no jogo.
- `verificacoes/`: testes e utilitários de desenvolvimento.
- `entrega/`: instruções, descrição para o itch.io e ferramentas de exportação.

Para exportar, instale os modelos da mesma versão do Godot. Os perfis atuais apontam para o cache local preparado por `entrega/instalar-modelos.ps1`; se usar os modelos instalados pelo editor, ajuste os campos de modelo personalizado em Exportar. Os modelos, builds e cache não fazem parte do pacote de código.

## Créditos

Desenvolvimento e adaptação: **Samuel Santinelli Mantovani**. Base de programação e estrutura: projeto fornecido pelo professor **Leandro Fernandes da Mota**. Artes novas: geração assistida por IA, com referências e prompts registrados nos documentos de `arte/`. Música e efeitos novos: síntese procedural pelos utilitários do projeto. Recursos herdados ainda referenciados permanecem identificados nos arquivos originais; não atribuir todo o projeto como criação do zero.

Jogo: https://samuel-santinelli.itch.io/fora-de-campo. O autor confirmou o funcionamento no navegador e do download Windows.

Código-fonte: https://github.com/samuel-santinelli/fora-de-campo.
