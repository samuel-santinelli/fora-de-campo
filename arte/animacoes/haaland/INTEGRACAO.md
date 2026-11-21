# Haaland — O Tanque integrado

`cena_haaland.tscn` herda `cena_inimigo2.tscn`; `script_haaland.gd` estende `script_inimigo2.gd`. Reutiliza CharacterBody2D, gravidade 10, move_and_slide, contato por Area2D, ativação por tela, som de dano e componente Resistencia. O goleiro original e seu salto permanecem intactos. Não altera Mbappé nem os sistemas do jogador.

Na fase, instância Haaland na posição local (2520,405), sobre a plataforma elevada antes do chefão. O personagem pode cair da borda ao perseguir: não usa navegação, salto nem novos projéteis. Mantém juiz, goleiro, Mbappé e chefão na mesma fase.

## Comportamento

- Avanço terrestre de 180 px/s, abaixo dos 380 px/s de perseguição do Mbappé.
- Ativa ao entrar na tela, com jogador válido, vivo e a até 560 px na horizontal. Fora da tela/alcance ou sem jogador vivo, interrompe movimento horizontal e contato, mantendo gravidade.
- Quatro pontos de vida configurados no componente existente, contra dois do Mbappé. Bola e carrinho causam um ponto por ataque; um mesmo carrinho não desconta repetidamente.
- Acerto não fatal pausa o avanço e contato por 250 ms, dando tempo para contra-atacar. Não cria invulnerabilidade: outros ataques distintos continuam válidos. Dano zero não interrompe.
- Contato usa o dano original de um ponto. Não recebe dano extra de força nem nova investida nesta etapa; identidade vem de porte, ritmo e resistência.
- Pausa do jogo congela movimento, reação e animação. Colisões impedem atravessar paredes. A derrota remove o corpo sem abrir o portão, reservado ao chefão.

## Visual e altura

Capa viking e oito quadros aprovados em `avanco-v1-alinhado.png`, células 320×320, âncora (140,300); parado em `parado-v1.png`. Ritmo de 960 ms por ciclo. Sprite escala 0,5, pés na posição local y=61; espelhamento pela âncora, sem deslocar o corpo. O AnimationPlayer herdado fica parado para não sobrescrever os novos quadros.

A exportação já inclui a diferença de 20%: altura visual ereta aproximadamente 139 px contra 116 px do Mbappé/Cristiano. Não aplicar outro fator 1,2. Corpo 52×130, com base alinhada aos pés; contato 68×100 acompanha tronco e pernas, excluindo capa. Raiz continua em escala 1. A proporção refere-se à altura ereta, preservando compressão e oscilação entre quadros.

Permanecem pequenos resíduos coloridos nas bordas da folha gerada, já identificados na prévia; uma futura limpeza da arte pode refiná-los sem mudar combate.

## Verificação

Godot 4.7.2, headless: `verificacoes/verificar_haaland.gd`, zero falhas. Confirma base herdada, ativação e alcance, quatro vidas, altura alpha relativa, escala/corpo, perseguição nos dois sentidos, quadros, pausa, contato, reação, parada sem jogador vivo, bola/carrinho com quatro ataques distintos, parede e apoio na plataforma real. Também confirma preservação dos inimigos obrigatórios e salto do goleiro.

Regressões `verificar_mbappe.gd` e `verificar_resistencia_inimigos.gd`: zero falhas. Logs em `verificacoes`. Permanecem avisos conhecidos do ambiente sobre certificados, preferências do editor fora do workspace na importação e recursos de áudio ainda em uso ao encerrar algumas verificações. Não houve inspeção visual em janela do jogo nesta etapa; falta conferir em partida o tamanho, a capa e o equilíbrio do encontro.
