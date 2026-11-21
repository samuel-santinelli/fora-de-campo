# Chute de Energia integrado

`Personagem/ChuteCristiano` usa `script_chute_cristiano.gd` e a folha aprovada `chute-v1-alinhada.png`. Oito quadros sincronizados ao AnimationPlayer original, ação de 600 ms. Não houve nova geração de arte nesta integração.

## Disparo e visual

A chamada existente `spawnar_bolar` passou de 600 para 340 ms na trilha da animação, coincidindo com o quadro de contato. Um bloqueio por execução evita duplicar bolas. A direção é capturada ao iniciar o chute; virar durante a preparação não faz o projétil sair do lado oposto à arte. O som toca no contato, junto ao disparo.

Marker2D ajustado para (58,39), junto à nova chuteira. A posição da bola é definida antes de adicioná-la à árvore, usando coordenadas do mesmo pai. A folha usa células 384×256, escala 0,5 e âncora dos pés igual às demais ações.

`cena_bola.tscn`, `script_bola.gd` e a textura original `Bola.png` foram reaproveitados. A textura permanece intacta; a bola agora aparece com 18 pixels de diâmetro, adequados ao protagonista. `script_energia_bola.gd` desenha anel, rastro e impacto dourados em separado. A bola gira durante o voo. O impacto é criado no pai da bola e termina após 220 ms, sobrevivendo à remoção do projétil.

## Comportamento preservado e correções locais

- Velocidade do projétil permanece 350 px/s.
- Mesmo RayCast e máscara 4 de inimigos. Agora o vetor acompanha esquerda/direita e cobre o próximo deslocamento mais o raio visual. Não foi criado outro sistema de projéteis.
- Acerto continua eliminando inimigos e abrindo o portão se o alvo se chama Chefao. Vida/resistência dos inimigos ainda é uma etapa futura.
- Bola perdida é removida após seis segundos para evitar acúmulo de objetos.
- Pulo, dano ou saída do chão antes do contato cancelam a animação sem disparo atrasado. Bola que já saiu continua seu percurso.
- A pausa da árvore congela chute, bola e efeitos.
- Segurar C continua permitindo repetir chutes em animações completas, com uma bola por execução. Ainda não há munição limitada.
- Colisões físicas, movimento, pulo, vidas e dano do personagem preservados. O projétil mantém a máscara de inimigos; não foram acrescentados ricochetes ou colisão com terreno.
- A seleção visual depende do ataque em execução, evitando mostrar a arte antiga apenas por segurar uma tecla de ataque no ar.

## Validação

Godot 4.7.2, testes headless:

- `verificar_chute_cristiano.gd`: zero falhas. Cena real com piso, preparação sem bola, pausa antes do contato e durante voo, disparo aos 340 ms, bloqueio de duplicação, arte nova, rotação/energia, inimigos em ambas as direções, direção capturada, impacto, cancelamento por dano/pulo, portão do chefão e remoção por tempo de vida.
- Regressões de corrida, carrinho, salto e espera: zero falhas.

Logs em `verificacoes`. Permanecem os avisos do ambiente sobre certificados e recursos MP3 ao encerrar; importação não conseguiu salvar preferências do editor fora do workspace, mas os recursos foram carregados e os testes passaram. Não houve revisão gráfica no cenário nesta etapa.

Próxima arte: reação a dano e morte, para substituir os momentos restantes em que o sprite antigo ainda pode aparecer. Munição/coletáveis e resistência dos inimigos continuam pendências do escopo acadêmico maior.
