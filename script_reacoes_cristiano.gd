extends Sprite2D
## Reações visuais; vida e movimento continuam no personagem existente.

const FOLHA_DANO = preload("res://arte/animacoes/cristiano/dano-v1-alinhada.png")
const FOLHA_DERROTA = preload("res://arte/animacoes/cristiano/derrota-v1-alinhada.png")
const TEMPOS_DANO = [0.05, 0.06, 0.08, 0.08, 0.10, 0.13]
const TEMPOS_DERROTA = [0.08, 0.10, 0.12, 0.13, 0.14, 0.15, 0.18, 0.30]

var _modo: StringName = &""
var _tempo: float = 0.0
var _quadro: int = 0

func _ready() -> void:
	centered = false
	offset = Vector2(-192, -240)
	region_enabled = true
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	visible = false

func receber_dano(direcao: int) -> void:
	if _modo == &"derrota":
		return
	_modo = &"dano"
	_tempo = 0.0
	texture = FOLHA_DANO
	scale = Vector2(0.5 * direcao, 0.5)
	_mostrar_quadro(0)

func iniciar_derrota(direcao: int) -> void:
	if _modo == &"derrota":
		return
	_modo = &"derrota"
	_tempo = 0.0
	texture = FOLHA_DERROTA
	modulate = Color.WHITE
	scale = Vector2(0.5 * direcao, 0.5)
	_mostrar_quadro(0)

func esta_ativa() -> bool:
	return _modo != &""

func derrota_concluida() -> bool:
	return _modo == &"derrota" and _tempo >= 1.2

func atualizar(delta: float) -> bool:
	if not esta_ativa():
		return false
	_tempo += delta
	if _modo == &"dano" and _tempo >= 0.5:
		_modo = &""
		modulate = Color.WHITE
		visible = false
		return false
	var tempos: Array = TEMPOS_DERROTA if _modo == &"derrota" else TEMPOS_DANO
	var fim: float = 0.0
	var quadro: int = tempos.size() - 1
	for indice in range(tempos.size()):
		fim += tempos[indice]
		if _tempo < fim:
			quadro = indice
			break
	modulate = Color(1.5, 1.5, 1.5) if _modo == &"dano" and quadro in [1, 2] else Color.WHITE
	_mostrar_quadro(quadro)
	return true

func _mostrar_quadro(quadro: int) -> void:
	_quadro = quadro
	region_rect = Rect2(quadro * 384, 0, 384, 256)
	visible = true
