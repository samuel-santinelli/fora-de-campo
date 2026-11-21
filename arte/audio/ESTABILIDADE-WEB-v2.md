# Estabilidade Web, áudio e interface — 12/11/2026

## Áudio

O modo Stream aplicado anteriormente foi retirado após o relato de estalos/engasgos ao manter teclas pressionadas, inclusive nos menus. Voltamos ao modo Sample, que delega a reprodução à Web Audio API, adequado ao export sem threads.

A correção principal está na criação dos canais: `AudioServer.add_bus()` foi substituído pelo aumento de `AudioServer.bus_count`. O template 4.7.2 instalado contém a implementação problemática de `Bus.addAt(-1)`, que pode reordenar os canais JavaScript e desconectar Master. Aumentar a contagem usa outro caminho, preservando a ordem dos canais e seus controles.

Referência primária: [Godot #119026](https://github.com/godotengine/godot/issues/119026), incluindo os relatos de 4.7.2 e a alternativa baseada em bus_count. Não modificamos o JavaScript do motor nem os modelos oficiais. A solução fica no projeto e é repetida em cada exportação.

O teste `verificar_audio_js.cjs` extrai o objeto de áudio do JavaScript real exportado e exerce a criação por contagem com nós de áudio simulados. Confere índice do Master, conexão à saída, roteamento, volume e mute. É uma verificação do grafo, não uma audição do navegador.

Na primeira entrada Web da sessão, há um botão “CLIQUE PARA ENTRAR”, avisando que o clique libera o som. Os navegadores podem bloquear áudio antes de interação; o jogo não tenta contornar essa política. A confirmação permanece ao retornar ao menu na mesma sessão. Windows não recebe essa tela adicional.

## Interface

- Pausa usa SVG próprio, em vez de um caractere dependente da fonte.
- Setas e símbolos de comandos foram substituídos por nomes de teclas/textos disponíveis na fonte padrão: ESQ, DIR, CIMA, OK e separadores simples. Acentos em português foram mantidos.
- Ícones de saúde e bola mantêm as imagens e passam a ter ajuste explícito de proporção/tamanho. Testes conferem pixels com alpha nos recursos carregados.
- Os percentuais de volume ficam na linha do nome do canal, acima do slider, em uma área alinhada à direita. Não intersectam a barra.

## Vida baixa

O shader aplicado à área inteira foi substituído por bordas desenhadas em faixas, sem renderizar ou alterar a resolução do jogo. O desenho é atualizado até 30 vezes por segundo enquanto visível. O pulso acompanha vida crítica, reduz após cura e é removido junto com a fase. Não muda o zoom, viewport ou qualidade das capas.

## Limites da conferência

Resultado desta revisão: 34 verificações Godot passaram, mais o teste do grafo JavaScript. A verificação de estabilidade/interface também passou carregando os recursos diretamente do PCK Web exportado, incluindo os pixels dos ícones e o layout dos percentuais. Ambos os ZIPs foram regenerados. Logs `final-estabilidade-*.log` e `estabilidade-pacote-web.log`; hashes atuais em `entrega/pacotes.json`.

`verificar_estabilidade_web.gd` exercita entrada, teclas repetidas nos menus, reprodução marcada como ativa, layout dos percentuais, imagens dos ícones e recuperação da vida crítica. Os testes sem janela não comprovam ausência de estalos audíveis ou a aparência final no navegador. É necessário recarregar a build com Ctrl+F5 e testar música, corrida, chute mantido, pausa, cura e retorno aos menus.
