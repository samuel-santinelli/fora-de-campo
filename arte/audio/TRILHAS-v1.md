# Identidade musical — FORA DE CAMPO

Cinco composições instrumentais originais, sintetizadas localmente em `verificacoes/gerar_trilhas.cjs`. Sem samples, gravações de torcida, vozes ou faixas externas. WAV estéreo, PCM 16 bits, 22050 Hz; importação Godot com repetição para frente. Composição, durações, BPM, tamanho e RMS em `Sons/Trilhas/composicoes.json`.

| Cena | Composição | BPM | Duração |
|---|---|---:|---:|
| Inicial | O Sete Entra em Campo | 112 | 34,29 s |
| Fase | Da Orla à Final | 128 | 60 s |
| Configurações | Antes do Apito | 92 | 41,74 s |
| Game Over | Ainda Há Revanche | 72 | 26,67 s |
| Final | Portões da Final | 124 | 30,97 s |

Direção: eletrônica de jogo esportivo, com bateria, baixo, palmas sintetizadas, arpejos, acordes sustentados e melodia de metais sintetizados. Menu e fase compartilham motivos em mi menor; chegada usa uma variação mais luminosa em sol maior. Configurações reduz percussão e densidade; derrota usa melodia descendente e arranjo espaçado. A fase tem trecho intermediário mais contido antes da retomada.

Substituição nas cinco cenas existentes, preservando os arquivos MP3 anteriores para histórico. As faixas novas começam com `musica-`, mantendo o roteamento automático para o canal Musica e os controles de volume existentes. Os efeitos dos personagens permanecem no canal Efeitos.

Loops compostos em compassos completos. Caudas de notas, delay e reverberação são somadas circularmente. Arquivos normalizados com pico abaixo de 0,8, sem saturação de PCM; essa verificação técnica não substitui a avaliação auditiva. O volume de cada cena foi mantido.

Ouvir em [previa-trilhas.html](previa-trilhas.html). A audição das faixas não foi validada pelo agente nesta sessão. Testes verificam carregamento, duração, estéreo, loop, reprodução e canal de áudio nas cinco cenas.

## Superchute

Bola comum mantém 350 px/s e rastro dourado. Superchute passa de 480 para 720 px/s, mantendo dano 2 e consumo de uma bola. Chamas laranja/douradas, núcleo claro, faíscas e impacto alaranjado são efeitos desenhados em código, com contorno em blocos e direção espelhada. A cauda fica atrás do sprite, deixando a bola de futebol visível. Câmera e tremor da etapa anterior permanecem.

O RayCast já percorre o deslocamento do próximo frame; o teste `verificar_superchute_fogo.gd` verifica paredes finas nos dois sentidos na nova velocidade. Não se altera movimento do jogador ou física global.
