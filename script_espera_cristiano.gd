extends Node2D
## Visual de repouso; não controla movimento, colisões ou ataques.

const FOLHA = preload("res://arte/animacoes/cristiano/espera-especial-v3-alinhada.png")
const DURACOES = [0.30, 0.10, 0.10, 0.12, 0.16, 0.18, 0.65, 0.25]

@export var intervalo_gesto: float = 3.0

var _sprite: Sprite2D
var _quadro: int = 0
var _tempo_quadro: float = 0.0
var _tempo_espera: float = 0.0
var _tempo_respiracao: float = 0.0
var _bloqueio: float = 0.0
var _fazendo_gesto: bool = false

func _ready() -> void:
	_sprite = Sprite2D.new()
	_sprite.texture = FOLHA
	_sprite.centered = false
	_sprite.region_enabled = true
	_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_sprite.show_behind_parent = true
	add_child(_sprite)
	visible = false
	_atualizar_sprite()

func atualizar(delta: float, direcao: int, pode_descansar: bool) -> bool:
	_bloqueio = maxf(0.0, _bloqueio - delta)
	if not pode_descansar or _bloqueio > 0.0:
		_reiniciar()
		return false

	visible = true
	scale = Vector2(0.5 * direcao, 0.5)
	_tempo_respiracao += delta
	if _fazendo_gesto:
		_tempo_quadro += delta
		while _fazendo_gesto and _tempo_quadro >= DURACOES[_quadro]:
			_tempo_quadro -= DURACOES[_quadro]
			_quadro += 1
			if _quadro >= DURACOES.size():
				_quadro = 0
				_tempo_quadro = 0.0
				_tempo_espera = 0.0
				_fazendo_gesto = false
	else:
		_tempo_espera += delta
		if _tempo_espera >= intervalo_gesto:
			_fazendo_gesto = true
			_quadro = 0
			_tempo_quadro = 0.0

	_atualizar_sprite()
	queue_redraw()
	return true

func interromper(duracao: float = 0.0) -> void:
	_bloqueio = maxf(_bloqueio, duracao)
	_reiniciar()

func _reiniciar() -> void:
	visible = false
	_fazendo_gesto = false
	_quadro = 0
	_tempo_quadro = 0.0
	_tempo_espera = 0.0
	_tempo_respiracao = 0.0
	queue_redraw()

func _atualizar_sprite() -> void:
	_sprite.region_rect = Rect2(_quadro * 256, 0, 256, 256)
	# Respiração sutil; a âncora da sola permanece no mesmo lugar.
	var respiracao: float = 1.0
	if not _fazendo_gesto:
		respiracao += sin(_tempo_respiracao * TAU / 2.4) * 0.003
	_sprite.scale = Vector2(1.0, respiracao)
	_sprite.position = Vector2(-140.0, -240.0 * respiracao)

func _draw() -> void:
	if not _fazendo_gesto or _quadro != 6:
		return
	_desenhar_brilho(0.06, 0.23, Vector2(8, -200), 4.0)
	_desenhar_brilho(0.33, 0.16, Vector2(5, -200), 2.0)

func _desenhar_brilho(inicio: float, duracao: float, ponto: Vector2, raio: float) -> void:
	var fase: float = (_tempo_quadro - inicio) / duracao
	if fase < 0.0 or fase > 1.0:
		return
	var intensidade: float = sin(fase * PI)
	var tamanho: float = maxf(1.0, roundf(raio * intensidade))
	var dourado := Color(0.96, 0.80, 0.40, intensidade)
	var branco := Color(1.0, 1.0, 1.0, intensidade)
	draw_rect(Rect2(ponto - Vector2(tamanho, 0), Vector2(tamanho * 2 + 1, 1)), dourado)
	draw_rect(Rect2(ponto - Vector2(0, tamanho), Vector2(1, tamanho * 2 + 1)), dourado)
	draw_rect(Rect2(ponto - Vector2(1, 0), Vector2(3, 1)), branco)
	draw_rect(Rect2(ponto - Vector2(0, 1), Vector2(1, 3)), branco)
