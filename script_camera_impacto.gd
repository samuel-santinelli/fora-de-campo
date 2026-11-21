extends Node
## Efeito local: preserva limites, movimento e velocidade da partida.
var _camera: Camera2D
var _zoom_base: Vector2
var _offset_base: Vector2
var _impacto: float = 0.0
var _tempo: float = 0.0
var _direcao: int = 1

func _ready() -> void:
	_camera = get_parent().get_node("Camera2D")
	_zoom_base = _camera.zoom
	_offset_base = _camera.offset

func superchute(direcao: int) -> void:
	_impacto = 0.42
	_tempo = 0.0
	_direcao = direcao

func _process(delta: float) -> void:
	var jogador = get_parent()
	if jogador._em_derrota:
		_camera.zoom = _zoom_base
		_camera.offset = _offset_base
		_impacto = 0
		return
	_impacto = maxf(0.0, _impacto - delta)
	_tempo += delta
	var carga: float = jogador.carga_chute / jogador.TEMPO_SUPERCHUTE if jogador.carregando_chute else 0.0
	var impulso: float = _impacto / 0.42
	var foco: float = 1.0 + maxf(carga * 0.045, impulso * 0.075)
	_camera.zoom = _camera.zoom.lerp(_zoom_base * foco, 1.0 - exp(-12.0 * delta))
	var direcao: int = jogador._direcao_chute if jogador.carregando_chute else _direcao
	var deslocamento := Vector2(direcao * maxf(carga * 12.0, impulso * 18.0), -carga * 5.0)
	var tremor: float = maxf(0.0, (_impacto - 0.18) / 0.24)
	deslocamento += Vector2(sin(_tempo * 135.0), cos(_tempo * 173.0)) * 5.0 * tremor
	_camera.offset = _offset_base + deslocamento
	if carga == 0.0 and _impacto == 0.0 and _camera.zoom.distance_to(_zoom_base) < 0.0001:
		_camera.zoom = _zoom_base

func _exit_tree() -> void:
	if is_instance_valid(_camera):
		_camera.zoom = _zoom_base
		_camera.offset = _offset_base
