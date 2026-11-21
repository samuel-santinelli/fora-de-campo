extends RefCounted
const DADOS = {
	"Inimigo2/CharacterBody2D": {"imagem": preload("res://arte/animacoes/obrigatorios/salto-v1-alinhado.png"), "titulo": "O GOLEIRO", "frase": "Essa passagem tem dono.", "ataque": "Salta na sua direção.", "defesa": "Desvie do salto e contra-ataque no pouso."},
	"Inimigo1/CharacterBody2D": {"imagem": preload("res://arte/animacoes/obrigatorios/lancamento-v1-alinhado.png"), "titulo": "A ARBITRAGEM", "frase": "Seu próximo passo está sob julgamento.", "ataque": "Lança cartões amarelos e vermelhos.", "defesa": "Pule os cartões e devolva uma bola."},
	"Neymar/CharacterBody2D": {"imagem": preload("res://arte/animacoes/neymar/parado-v1.png"), "titulo": "O DRIBLADOR", "frase": "Tenta acompanhar o drible.", "ataque": "Faz fintas e lança bolas.", "defesa": "Espere a finta e ataque de longe."},
	"Mbappe/CharacterBody2D": {"imagem": preload("res://arte/animacoes/mbappe/parado-v1.png"), "titulo": "O RELÂMPAGO", "frase": "Piscou, passou.", "ataque": "Dispara uma arrancada em linha reta.", "defesa": "Quando surgirem as setas, prepare o pulo."},
	"Haaland/CharacterBody2D": {"imagem": preload("res://arte/animacoes/haaland/parado-v1.png"), "titulo": "O TANQUE", "frase": "Do navio, direto para o seu caminho.", "ataque": "Resiste aos golpes e avança com ombradas.", "defesa": "Use bolas à distância. Pule para trocar de lado."},
	"Impedimento/CharacterBody2D": {"imagem": preload("res://arte/animacoes/impedimento/parado-v1.png"), "titulo": "O GUARDIÃO", "frase": "A final ainda não está liberada.", "ataque": "Alterna investidas e sinalizadores.", "defesa": "Pule o disparo e ataque após a investida."},
	"Chefao/Chefao": {"imagem": preload("res://arte/animacoes/var-01/parado-v1.png"), "titulo": "A DECISÃO FINAL", "frase": "A última decisão é minha.", "ataque": "Carrega o olho, mira e dispara.", "defesa": "Espere a mira travar e pule. Uma bola cancela a carga."},
}
