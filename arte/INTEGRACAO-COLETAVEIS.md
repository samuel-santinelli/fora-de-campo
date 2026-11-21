# Vida, bolas e coletas

Revisão inicial: vida/dano/derrota já existiam; chute não tinha estoque e a fase não continha coletas. Implementação reutiliza os mesmos ataques, projéteis, colisões do jogador e percurso.

## Regras

- Vida máxima/inicial: 10, preservando valor anterior. Kit recupera até 2, sem ultrapassar 10 e sem reviver personagem derrotado.
- Bolas iniciais: 10; capacidade 20. Reserva repõe até 5.
- Só o disparo efetivo desconta uma bola, dentro de spawnar_bolar. Preparar e cancelar chute antes do disparo não gasta; a proteção de um projétil por chute permanece.
- Sem bolas, não inicia outro chute nem cria projétil. Carrinho segue disponível sem gasto.
- Recurso cheio não consome item. Se recurso cair enquanto ainda toca o item, pode coletar sem precisar sair/entrar.
- Contato só aceita ScriptGlobal.personagem; inimigos não recolhem. Consumo protegido contra duplicação entre sinal e atualização física. Som/removal são diferidos para não alterar árvore dentro do callback físico.
- Reinício pelo fluxo existente repõe vida e munição e recria as coletas, sem alterar volumes/configurações.

## Percurso e visual

`script_itens_fase.gd` adiciona onze áreas sob Coletaveis na fase. Reservas em x560, 1530, 2930, 3790, 4890, 6040, 7010; kits em x1250, 3400, 5680, 6800. Centro y574 local da fase, ao alcance do personagem no piso contínuo. Nenhum item na escadaria ou exigindo plataforma nova. Sem checkpoints, respawn periódico ou bloqueios de avanço.

`script_coletavel.gd`: ícones por formas de pixels (bolsa vermelha com cruz clara, reserva azul/cinza com a textura da bola existente), bordas douradas, flutuação visual discreta e área circular fixa. Não foram geradas novas imagens. Reutiliza som Pegando_vida.mp3 no canal Efeitos. Os ícones são acabamento simples, não arte raster detalhada nova.

HUD substitui retrato antigo por painel com VIDA atual/máxima e BOLAS atual/máxima. Contador de bolas destaca vazio em âmbar. Nós da pausa preservados, sem captura de cliques pelo painel. Layout inicial fixo no canto superior esquerdo dentro da camada HUD existente.

## Validação

Cinco verificações headless Godot 4.7.2 com zero falhas: coletas/munição, chute, pausa, percurso e dano/derrota. Teste específico usa contatos físicos com itens na fase real para cura, limites e coleta posterior; confirma recurso cheio preservando item, um gasto por disparo, bloqueio sem bolas, carrinho disponível, rejeição de cura após derrota e atualização do HUD. Regressões preservam cancelamento do chute, trajetória/ataque, congelamento, travessia e derrota.

Logs `verificacoes/coletaveis-*.log`. Persistem mensagens ambientais de certificado e recursos em uso ao encerrar. Sem inspeção visual em partida ou avaliação final de dificuldade. Distribuição inicial oferece até 45 bolas contando estoque e reservas, suficiente em princípio para os inimigos se acertar, com carrinho como alternativa. Isso não garante facilidade: perseguidores e tiros perdidos podem exigir ajustes após jogar o percurso inteiro. Itens usam posições fixas; não foram acrescentadas fases.
