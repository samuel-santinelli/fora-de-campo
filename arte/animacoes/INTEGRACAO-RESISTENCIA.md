# Resistência dos inimigos — base para os rivais

`script_resistencia_inimigo.gd` concentra vida, retorno visual de dano e derrota em um nó `Resistencia` dentro do corpo dos inimigos existentes. `receber_dano(quantidade)` nos três scripts encaminha os acertos para esse nó. IA, movimentação, detecção, animações e ataques próprios continuam nos scripts originais.

## Configuração inicial

- Inimigo atirador: 1 vida, som `Sons/Dano_inimigo.mp3`.
- Inimigo perseguidor: 1 vida, som `Sons/Dano_inimigo2.mp3`.
- Chefão existente: 6 vidas, som `Sons/Dano_chefão.mp3`, abre portão ao chegar a zero.

`vida_maxima` é exportada no nó Resistencia, permitindo configurar Haaland e outros rivais depois, sem outra lógica de vida. Os números atuais são provisórios de balanceamento. Não foram criados os personagens novos nesta etapa.

Bola e carrinho causam 1 de dano. Um conjunto de identificadores é reiniciado ao começar cada carrinho e impede múltiplos descontos do mesmo alvo naquela execução. Inimigos que sobrevivem recebem um clarão de 120 ms; sua cor original é restaurada. O áudio é criado fora do corpo, para não ser cortado ao derrotar o inimigo. Não há invulnerabilidade adicional nem mudança na velocidade dos inimigos.

Somente o componente do chefão abre o portão ao esgotar sua vida. O caminho legado para alvos simples sem método de dano foi preservado, mantendo compatibilidade com objetos e verificações isoladas existentes. O RayCast da bola agora também detecta alvos quando nasce dentro da colisão, importante para tiros muito próximos; máscara e método de detecção existentes foram preservados.

## Validação no Godot 4.7.2

`verificar_resistencia_inimigos.gd`: zero falhas. Instancia as cenas reais com IA desativada no teste; confirma inimigo comum com uma vida, dano zero, derrota sem vida negativa, áudio sobrevivendo à remoção, inimigo com três vidas atingido por bola/carrinho/bola, proteção contra dano duplicado do mesmo carrinho, restauração da cor, chefão sobrevivendo aos cinco primeiros tiros e portão abrindo apenas no sexto.

Na primeira execução, o teste ainda deixava a IA do perseguidor ativa ao entrar na árvore; foi desativada após adicionar a cena. O teste de tiros próximos também revelou o caso de RayCast dentro do chefão, corrigido com `hit_from_inside`.

Regressões de carrinho, chute e dano/derrota passaram. Logs em `verificacoes`; testes headless, sem conferência visual da fase. Permanecem os avisos do ambiente já observados sobre certificados e recursos MP3 ao encerrar.

## Próximos passos

Adaptar Mbappé a partir do perseguidor existente, primeiro visual e depois arrancada. Haaland poderá usar a mesma base com mais vida e velocidade menor; Neymar e Messi reaproveitarão movimento e disparo existentes com pequenas variações. Manter juiz lançando cartões e goleiro saltador ou VAR perseguidor para cumprir o enunciado. O VAR-01 final precisa continuar claramente sendo um cartão vermelho com braços e pernas.

Coletáveis de vida, munição limitada, cenário próprio, telas, exportações e página do itch.io continuam pendentes no escopo acadêmico. A Cabeçada de Impacto permanece extra opcional.
