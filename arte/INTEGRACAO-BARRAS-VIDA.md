# Barras de vida — Cristiano e inimigos

Atualização de ícones: coração junto à barra do Cristiano e bola junto ao contador de munição, ambos 24 × 24, em SVG de interface com formas em pixels e borda dourada (`arte/telas/ui/saude-hud.svg`, `bola-hud.svg`). Barra recuada 30 unidades, preservando margem direita. Sem alteração nos recursos. Verificação das barras ampliada confirma separação dos ícones, com zero falhas; log `verificacoes/icones-hud.log`. Sem inspeção em janela nesta etapa.

Cristiano: barra fixa no HUD, verde com borda dourada, vermelha ao restarem 3 pontos ou menos. Substitui o contador numérico de vida; nome do personagem acima e contador de bolas preservado abaixo. Usa a mesma vida máxima 10 e reflete dano/cura sem alterar regras. Painel 300 × 102 no canto superior esquerdo da camada de interface, sem acompanhar câmera do mundo.

Inimigos: `script_resistencia_inimigo.gd` cria ProgressBar como filha do corpo usando `script_barra_vida_inimigo.gd`. Sinal vida_alterada atualiza preenchimento imediatamente após dano. Barras comuns 64 × 8; VAR-01 96 × 10 com borda dourada. Preenchimento vermelho e fundo escuro. Posicionamento calculado após ajuste inicial dos sprites pelos scripts, acima do topo entre sprite e colisão, com margem. Como filhas do corpo, acompanham movimento e salto e são removidas com a derrota.

Muralha/Sentença continuam com 1 ponto e caem com um acerto; Mbappé 2, Neymar 3, Haaland 4, Impedimento 5 e VAR-01 6. Não aumentou resistência para justificar barras. O chefe mantém barra cheia durante a espera pelo guardião. Barras sempre visíveis enquanto o corpo existe, naturalmente fora da câmera quando o inimigo está fora da tela. Não criam colisões, capturam mouse ou recebem foco.

Estilos nativos do Godot com bordas retas e filtro nearest, sem novos arquivos raster, novas animações de dano ou números sobre a cabeça. O topo da barra usa altura de pé estável; poses agachadas não fazem o indicador oscilar a cada quadro. Pode exigir ajuste fino visual para recortes com muito espaço transparente.

## Validação

Godot 4.7.2 headless: barras, coletas e Impedimento — três verificações com zero falhas. Teste específico confirma vida inicial, dano, cura, cor crítica, posição fixa da interface ao mover câmera, sete barras com resistências originais, posicionamento acima da colisão, acompanhamento do corpo, atualização imediata ao dano e remoção na derrota. Regressões preservam coletas/munição e sequência guardião/chefe/portão.

Logs `verificacoes/barras-*.log`. Persistem mensagens ambientais de certificados e recursos em uso ao encerrar. Sem inspeção visual em janela real nesta etapa. Conferir barras sobre cabeças, contraste e espaço do HUD em partida. A posição lógica é validada; acabamento visual ainda deve ser observado no jogo.
