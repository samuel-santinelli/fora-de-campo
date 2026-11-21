extends Node2D
## Visual sincronizado ao AnimationPlayer original do ataque próximo.

const FOLHA = preload("res://arte/animacoes/cristiano/carrinho-v1-alinhada.png")
const DURACOES = [0.05, 0.05, 0.06, 0.08, 0.08, 0.06, 0.06, 0.06]

var _sprite: Sprite2D
var _quadro: int = 0
var _tempo: float = 0.0
var _impacto: float = 0.0

func _ready() -> void:
	_sprite = Sprite2D.new()
	_sprite.texture = FOLHA
	_sprite.centered = false
	_sprite.position = Vector2(-192, -240)
	_sprite.region_enabled = true
	_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(_sprite)
	visible = false
	_sprite.region_rect = Rect2(0, 0, 384, 256)

func atualizar(delta: float, direcao: int, ativo: bool, tempo: float) -> bool:
	_impacto = maxf(0.0, _impacto - delta)
	if not ativo:
		interromper()
		return false
	visible = true
	scale = Vector2(0.5 * direcao, 0.5)
	_tempo = tempo
	var fim: float = 0.0
	_quadro = 7
	for indice in range(DURACOES.size()):
		fim += DURACOES[indice]
		if tempo < fim:
			_quadro = indice
			break
	_sprite.region_rect = Rect2(_quadro * 384, 0, 384, 256)
	queue_redraw()
	return true

func interromper() -> void:
	visible = false
	_quadro = 0
	_impacto = 0.0
	queue_redraw()

func mostrar_impacto() -> void:
	_impacto = 0.12
	queue_redraw()

func _draw() -> void:
	if not visible:
		return
	if _quadro >= 2 and _quadro <= 4:
		var fase: float = fmod(_tempo * 12.0, 1.0)
		for indice in range(5):
			var cor := Color("e8b745") if indice % 2 == 0 else Color("fff0ad")
			cor.a = 0.85 * (1.0 - float(indice) / 6.0)
			var ponto := Vector2(-42 - indice * 23 - roundf(fase * 15), -19 + (indice % 3) * 4)
			draw_rect(Rect2(ponto, Vector2(30 + indice * 3, 2 + indice % 2)), cor)
		for indice in range(6):
			var ponto := Vector2(-120 + indice * 16 - roundf(fase * 28), -25 + (indice * 7) % 23)
			draw_rect(Rect2(ponto, Vector2(2, 2)), Color(1.0, 0.86, 0.46, 0.6))
	if _impacto > 0.0:
		var cor := Color(1.0, 0.86, 0.40, _impacto / 0.12)
		for indice in range(8):
			var deslocamento := Vector2.from_angle(float(indice) * TAU / 8.0) * (10.0 + (0.12 - _impacto) * 120.0)
			draw_rect(Rect2(Vector2(148, -30) + deslocamento, Vector2(4, 4)), cor)
