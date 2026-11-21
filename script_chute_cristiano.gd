extends Node2D
## Arte e clarão do chute, sincronizados ao AnimationPlayer existente.

const FOLHA = preload("res://arte/animacoes/cristiano/chute-v1-alinhada.png")
const DURACOES = [0.08, 0.09, 0.09, 0.08, 0.06, 0.07, 0.07, 0.06]

var _sprite: Sprite2D
var _quadro: int = 0
var _tempo: float = 0.0

func _ready() -> void:
	_sprite = Sprite2D.new()
	_sprite.texture = FOLHA
	_sprite.centered = false
	_sprite.position = Vector2(-192, -240)
	_sprite.region_enabled = true
	_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_sprite.region_rect = Rect2(0, 0, 384, 256)
	add_child(_sprite)
	visible = false

func atualizar(direcao: int, ativo: bool, tempo: float) -> bool:
	if not ativo:
		interromper()
		return false
	visible = true
	scale = Vector2(0.5 * direcao, 0.5)
	_tempo = tempo
	_quadro = 7
	var fim: float = 0.0
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
	queue_redraw()

func _draw() -> void:
	if not visible or _tempo < 0.34 or _tempo >= 0.44:
		return
	var intensidade: float = 1.0 - (_tempo - 0.34) / 0.1
	var raio: float = roundf(13.0 * intensidade)
	var ponto := Vector2(107, -36)
	var dourado := Color(0.96, 0.77, 0.37, intensidade)
	draw_rect(Rect2(ponto - Vector2(raio, 0), Vector2(raio * 2 + 1, 2)), dourado)
	draw_rect(Rect2(ponto - Vector2(0, raio), Vector2(2, raio * 2 + 1)), dourado)
	draw_rect(Rect2(ponto - Vector2.ONE, Vector2(3, 3)), Color(1.0, 0.97, 0.83, intensidade))
