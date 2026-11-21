# Praça e corredor — integração ao percurso

`script_ambientes_iniciais.gd` agora monta quatro painéis com recortes próprios. Usa os PNGs existentes, intactos; nenhuma nova imagem foi gerada nesta etapa. Sem alterações de física, colisões, posições dos personagens, câmera ou comportamento de combate.

| Ambiente | Início X | Corte vertical da fonte | Altura do fundo no mundo |
|---|---|---|---|
| Quadra | 0 | 724 | 607 |
| Rua | 1280 | 724 | 607 |
| Praça | 2560 | 739 | 607 |
| Corredor | 3650 | 738 | 607 |

Escala uniforme por imagem definida pela altura do recorte. Praça alcança aproximadamente x3933 e cobre Neymar em x3150. Corredor alcança aproximadamente x5025 e cobre Mbappé em x4050. Limites de recorte foram ajustados pela inspeção das referências; a camada de terreno à frente desenha o topo na geometria física real, inclusive no fim da subida.

## Transições e terreno

Mistura de entrada em 120 px; painel anterior permanece opaco por trás durante a transição inteira. Isso evita a faixa de fundo neutro que surgiria ao reduzir a opacidade de ambos ao mesmo tempo. Somente o painel final se dissolve no fundo neutro, onde a próxima arte ainda está pendente. Miolo opaco desenhado em uma chamada, com faixas estreitas somente nas bordas; não gera uma textura panorâmica de 8050 px nem redesenha continuamente por script.

Revestimento do piso estendido até x5050. Antes do corredor mantém alvenaria do início; no corredor usa região inferior da sua própria referência, com topo em concreto de tom mais frio. O recorte usa UV de renderização, sem modificar arquivos de imagem. Colisão da subida, piso contínuo e plataforma de Haaland preservados. Elementos do fundo (canopy, bancos, grades e pilares) não recebem novas colisões.

Áreas de Haaland, Impedimento e VAR-01 ainda usam base neutra e terreno provisório. Não considerar o acabamento visual da fase concluído. As imagens não são seamless; mistura e repetição de elementos do estádio podem precisar de refinamento visual.

## Validação

Godot 4.7.2 headless: verificar_ambientes.gd, verificar_percurso.gd, verificar_neymar.gd, verificar_mbappe.gd e verificar_impedimento.gd — zero falhas. Ambientes confirma quatro fontes, recortes, sobreposição por toda a transição, cobertura dos encontros fora da mistura e extensão do terreno. Regressões confirmam travessia, apoio, ataques dos rivais e sequência guardião/chefe/portão.

Permanecem mensagens ambientais de certificados, preferências do editor fora do workspace e recursos ainda em uso ao sair. Não houve inspeção em janela do jogo nem medição de desempenho web. Validar em partida contraste do amarelo do Neymar, azul do Mbappé/rastro, bordas dos painéis e alinhamento aparente do chão. A prévia HTML compara referências e personagens, não reproduz a renderização completa do mapa.
