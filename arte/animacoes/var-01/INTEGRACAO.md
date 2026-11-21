# VAR-01 — primeira versão funcional

Atualização: caminhada e golpe integrados à cena, conforme `INTEGRACAO-ANIMACOES.md`. A prévia está em `previa-ataques.html`; prompts e fontes em `ANIMACOES-v1.md`. As descrições abaixo sobre pose única registram a primeira integração funcional, anterior à substituição por animações.

`cena_chefao.tscn` mantém raiz, corpo Chefao, colisão original, Resistencia de seis vidas, som de dano e abre_portao=true. Agora usa a referência `../../referencias/var-01-v1.png` e `script_var01.gd`, que estende `script_chefao.gd`. Caminho Chefao/Chefao preservado para o sequenciamento pelo Impedimento. AnimationPlayer e Timer antigos ficam parados; as funções antigas chamadas pelas animações foram neutralizadas na variante para impedir dano global ou disparos duplicados.

## Ataques

Aproxima a 100 px/s até cerca de 180 px do alvo. Após 0,9 s e dentro de 480 px, alterna laser e golpe no chão, com direção capturada antes do aviso. Mantém gravidade e move_and_slide. Fora da tela, sem jogador vivo ou no ar, cancela o ataque pendente. Não acompanha o jogador durante o aviso/execução do ataque.

Revisão de Campo: carga de 1,1 s com linha fina na altura exata do disparo; laser por 0,25 s, faixa de 14 px a 25 px acima dos pés do chefe. A linha parte de um ponto baixo na estrutura do cartão, alimentado visualmente pelo monitor. Essa escolha permite pular o laser sem alterar altura de salto. Raycast limita alcance ao terreno; feixe aplica um dano por disparo, somente se a faixa tocar a colisão real do jogador. Segue recuperação de 0,9 s.

Decisão Contestada: bola do jogador durante a carga causa dano normal e cancela o laser, deixando chefe atordoado por 1 s com estática no monitor. `script_bola.gd` passa a oferecer receber_bola(quantidade,ponto) para alvos que implementem; os outros continuam usando receber_dano. Carrinho e demais danos não cancelam especificamente o laser. Não há reflexão de feixe, bônus de dano nem nova munição.

Adaptação necessária: o chute atual sai rente ao chão e não pode ser usado no ar. Exigir impacto no monitor alto tornaria o contra-ataque impraticável. Por isso a bola pode acertar o corpo do cartão durante a carga e cortar a energia do monitor; não existe mira nova nem acerto obrigatório na cabeça. Um círculo amarelo no cartão indica a oportunidade. Fora da carga o cartão continua vulnerável, sem invulnerabilidade artificial; a proteção parcial do monitor é visual.

Decisão Final: preparação de 0,6 s com linha no chão, seguida de frente de onda que percorre até 220 px durante 0,45 s. Dano restrito à frente da onda, até 22 px de altura, uma vez por golpe. Salto, distância ou ficar no lado contrário evitam dano. Terreno limita propagação. Recupera por 0,9 s. Substitui o comportamento anterior de dano em qualquer jogador no chão dentro da tela.

## Visual e limitações

Primeira integração usa UMA pose da referência aprovada em escala 0,15 e âncora próxima dos pés, mantendo o tamanho de corpo existente. Cartão vermelho forma o torso, monitor e câmeras permanecem legíveis. Proteção, linha de aviso, laser, estática e onda são desenhos separados, sem gerar novos assets raster nesta etapa. O golpe desloca a pose ligeiramente para baixo, mas ainda não tem animação dedicada de braço batendo no chão; caminhada também usa a pose única. Refinamento de folhas de avanço, carga e impacto é a próxima etapa visual. Sons de ataque reutilizam o chute; sons distintos de laser e impacto ainda podem ser refinados.

Não implementado ataque de faixa elétrica, reflexão de laser ou nova fase. Corpo, vidas, combate do jogador, bloqueio pelo guardião e portão preservados. O chefe só fica atingível depois do Impedimento e sua derrota continua abrindo o estádio.

## Verificação

Godot 4.7.2 headless: `verificacoes/verificar_var01.gd`, zero falhas. Confirma apoio no chão, seis vidas, carga sem dano, pausa, interrupção por bola real na altura do chute, dano único do laser, desvio por altura e lado, aviso do golpe, onda de alcance curto, desvio por salto, bloqueio do feixe por terreno e cancelamento após derrota do jogador.

Regressões de resistência, Impedimento (incluindo liberação do chefe e portão), chute e carrinho: zero falhas. Logs em `verificacoes`. Permanecem mensagens ambientais sobre certificados e recursos ainda em uso ao sair. Testes não substituem conferência visual em partida; avaliar principalmente tempo de reação, alcance, efeito da onda e proporção da pose na fase.
