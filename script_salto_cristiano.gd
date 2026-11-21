extends Sprite2D
## Escolhe poses pela física existente; não aplica impulso nem move o corpo.

const FOLHA = preload("res://arte/animacoes/cristiano/salto-v1-alinhada.png")

var _quadro: int = 0
var _tempo_ar: float = 0.0
var _tempo_queda: float = 0.0
var _tempo_pouso: float = 0.0
var _bloqueio: float = 0.0
var _estava_no_ar: bool = false

func _ready() -> void:
	texture = FOLHA
	centered = false
	offset = Vector2(-140, -240)
	region_enabled = true
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	visible = false
	_atualizar_recorte()

func atualizar(delta: float, direcao: int, no_chao: bool, velocidade_y: float, permitido: bool, parado: bool) -> bool:
	_bloqueio = maxf(0.0, _bloqueio - delta)
	if not permitido or _bloqueio > 0.0:
		_reiniciar()
		return false

	scale = Vector2(0.5 * direcao, 0.5)
	if not no_chao:
		_tempo_pouso = 0.0
		_tempo_ar += delta
		_estava_no_ar = true
		if velocidade_y < -120.0:
			_tempo_queda = 0.0
			_quadro = 1 if _tempo_ar < 0.07 else 2
		elif absf(velocidade_y) <= 120.0:
			_tempo_queda = 0.0
			_quadro = 3
		else:
			_tempo_queda += delta
			_quadro = 4 if _tempo_queda < 0.12 else 5
	else:
		if _estava_no_ar:
			_tempo_pouso = 0.16
		_estava_no_ar = false
		_tempo_ar = 0.0
		_tempo_queda = 0.0
		# Aterrissagem apenas visual: movimento/ataque nunca fica bloqueado.
		if not parado or _tempo_pouso <= 0.0:
			_reiniciar()
			return false
		_quadro = 6 if _tempo_pouso > 0.08 else 7
		_tempo_pouso = maxf(0.0, _tempo_pouso - delta)

	visible = true
	_atualizar_recorte()
	return true

func interromper(duracao: float = 0.0) -> void:
	_bloqueio = maxf(_bloqueio, duracao)
	_reiniciar()

func _reiniciar() -> void:
	visible = false
	_estava_no_ar = false
	_tempo_ar = 0.0
	_tempo_queda = 0.0
	_tempo_pouso = 0.0
	_quadro = 0
	_atualizar_recorte()

func _atualizar_recorte() -> void:
	region_rect = Rect2(_quadro * 256, 0, 256, 256)
