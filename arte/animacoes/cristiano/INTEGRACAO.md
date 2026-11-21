# Integração da espera no jogador

`cena_jogador.tscn` inclui `Personagem/EsperaCristiano`, controlado por `script_espera_cristiano.gd`. O script do personagem chama o visual depois de mover o corpo. A colisão e as animações originais de corrida, pulo e ataques foram preservadas.

Ao ficar parado no chão, mostrar o novo Cristiano respirando. Após três segundos, executar uma vez o gesto de cabelo, olhar para quem joga e sorriso com brilhos; retornar à respiração e reiniciar o intervalo. Movimento, pulo e ataques ocultam o visual de repouso no mesmo processamento. A função de dano também interrompe o gesto, com bloqueio visual de meio segundo. A pausa da árvore congela os tempos porque são atualizados pelo personagem.

Escala visual 0,5: corpo com cerca de 116 pixels de altura, próximo do sprite anterior. A âncora dos pés fica em (4,5; 57) em relação ao corpo. O filtro nearest mantém bordas nítidas. O sprite é desenhado atrás do nó de brilhos para que o efeito seja visível sobre os dentes. A capa não altera colisões.

## Validação

Não foi localizado Godot no PATH, nos processos ativos ou na pasta Downloads. A integração ainda NÃO foi executada no motor. Foram conferidas as referências locais, dimensões do PNG e preservação das formas e trilhas de animação da cena.

Há uma verificação preparada em `verificacoes/verificar_espera_cristiano.gd`, ainda não executada. Com o executável disponível, importar o projeto e executar:

```powershell
& 'CAMINHO/DO/Godot_console.exe' --headless --path . --editor --import
& 'CAMINHO/DO/Godot_console.exe' --headless --path . --script res://verificacoes/verificar_espera_cristiano.gd
```

Conferir também no jogo: três segundos parado, gesto completo, troca de direção, interrupção por corrida/pulo/chute/carrinho, pausa durante o gesto, dano e alinhamento ao chão. As artes antigas reaparecem durante ações porque somente a espera foi substituída nesta etapa.
