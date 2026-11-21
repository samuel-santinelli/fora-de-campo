# Cristiano — espera especial v1

Folha de quatro poses gerada pela ferramenta integrada de imagens a partir de `arte/referencias/cristiano-pose-base-v2.png`. Preserva a direção visual aprovada e acrescenta o gesto de ajeitar o cabelo e um sorriso com brilho discreto. É uma primeira sequência de poses, ainda não uma animação final integrada ao Godot.

## Sequência

1. Respiração e postura neutra.
2. Levantar a mão em direção ao cabelo.
3. Ajeitar o cabelo, com balanço da capa.
4. Baixar o braço e sorrir, com pequeno brilho nos dentes.

Usar como espera especial após alguns segundos sem comandos, intercalada com respiração simples. Não repetir o sorriso e o gesto continuamente. Movimento ou ataque deve poder interromper a espera imediatamente.

## Revisão antes de integrar

O rosto mantém a referência visual, mas a geração não garante identidade pixel a pixel. Validar legibilidade na escala de jogo. A folha tem quatro poses completas; precisa de recorte, alinhamento dos pés e ajuste de duração, além de eventuais quadros intermediários para suavizar o retorno do braço. Conferir a anatomia dos braços levantados nos quadros centrais. Não alterar as colisões para acompanhar capa, mão ou brilho.

## Prompt utilizado

Use case: identity-preserve. Asset: four-frame special idle animation sprite strip for FORA DE CAMPO. Input image 1 is the APPROVED character identity and side-facing stance; preserve it strictly. Create exactly FOUR equally spaced full-body frames left to right in ONE HORIZONTAL ROW, same camera, same scale, same side view facing RIGHT, identical foot baseline and body position relative to each equal-width cell. Transparent background with clean alpha, absolutely no halo, glow, shadows, environment, grid, labels or words. Each figure fully inside its cell with ample spacing including raised hand and cape. Same detailed crisp pixel-art style as reference, realistic adult anatomy and recognizable Cristiano Ronaldo facial structure, same nose, jaw, eyes, hairline and skin tone throughout; NOT photorealistic painting or caricature. Same Portugal red jersey with green trim and number 7, green shorts, red socks, gold shoulder armor, forearm armor, shin guards, gold boots, short red cape with gold edging. Keep all outfit details and face identity consistent between frames. The only changes are acting and gentle breathing/cape movement. Frame 1: relaxed neutral idle, arms down, gentle inhale. Frame 2: near arm raises, hand at forehead beginning to sweep hair back, face still facing right. Frame 3: fingertips brushing through the top of his short hair with confident expression, subtle chest exhale, cape moves slightly; do not change haircut or facial identity. Frame 4: arm down again, small natural confident smile showing just a little white teeth, one TINY four-point golden-white glint exactly at mouth corner, not a large star covering face. Keep head profile and expression anatomically believable, no huge cartoon grin. Feet remain planted in exactly same locations, no walking or jumping, no football. This is a game animation keyframe sheet; no portraits or closeups, four complete figures in equal cells on wide canvas. Preserve original face as closely as possible; expression only changes slightly in final frame.
