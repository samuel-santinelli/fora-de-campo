extends Sprite2D
## Ciclo visual aprovado; não altera velocidade, gravidade ou colisões.

const FOLHA = preload("res://arte/animacoes/cristiano/corrida-v3-alinhada.png")
const DURACOES = [0.075, 0.065, 0.060, 0.065, 0.075, 0.065, 0.060, 0.065]

var _quadro: int = 0
var _tempo_quadro: float = 0.0
var _bloqueio: float = 0.0

func _ready() -> void:
	texture = FOLHA
	centered = false
	offset = Vector2(-140, -240)
	region_enabled = true
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	visible = false
	_atualizar_recorte()

func atualizar(delta: float, direcao: int, pode_correr: bool) -> bool:
	_bloqueio = maxf(0.0, _bloqueio - delta)
	if not pode_correr or _bloqueio > 0.0:
		_reiniciar()
		return false
	visible = true
	scale = Vector2(0.5 * direcao, 0.5)
	_tempo_quadro += delta
	while _tempo_quadro >= DURACOES[_quadro]:
		_tempo_quadro -= DURACOES[_quadro]
		_quadro = (_quadro + 1) % DURACOES.size()
	_atualizar_recorte()
	return true

func interromper(duracao: float = 0.0) -> void:
	_bloqueio = maxf(_bloqueio, duracao)
	_reiniciar()

func _reiniciar() -> void:
	visible = false
	_quadro = 0
	_tempo_quadro = 0.0
	_atualizar_recorte()

func _atualizar_recorte() -> void:
	region_rect = Rect2(_quadro * 256, 0, 256, 256)
