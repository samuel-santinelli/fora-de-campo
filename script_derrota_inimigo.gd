extends Node2D
## O corpo sai do combate; esta animação independente termina antes de liberar o portão.
signal concluida

const CONFIG = {
	"script_muralha.gd": ["muralha", 135.0, 1.25],
	"script_sentenca.gd": ["sentenca", 113.0, 1.25],
	"script_inimigo1.gd": ["sentenca", 113.0, 1.25],
	"script_inimigo2.gd": ["muralha", 135.0, 1.25],
	"script_mbappe.gd": ["mbappe", 115.0, 1.15],
	"script_neymar.gd": ["neymar", 115.0, 1.35],
	"script_haaland.gd": ["haaland", 138.0, 1.65],
	"script_impedimento.gd": ["impedimento", 162.0, 1.7],
	"script_var01.gd": ["var-01", 208.0, 3.8],
	"script_chefao.gd": ["var-01", 208.0, 3.8],
}
const FOLHAS = {
	"muralha": preload("res://arte/animacoes/derrotas/muralha-v1.png"),
	"sentenca": preload("res://arte/animacoes/derrotas/sentenca-v1.png"),
	"mbappe": preload("res://arte/animacoes/derrotas/mbappe-v1.png"),
	"neymar": preload("res://arte/animacoes/derrotas/neymar-v1.png"),
	"haaland": preload("res://arte/animacoes/derrotas/haaland-v1.png"),
	"impedimento": preload("res://arte/animacoes/derrotas/impedimento-v1.png"),
	"var-01": preload("res://arte/animacoes/derrotas/var-01-v1.png"),
}
const QUEDA = preload("res://Sons/Identidade/queda-rival.wav")
const TANQUE = preload("res://Sons/Identidade/queda-tanque.wav")
const ROBO = preload("res://Sons/Identidade/desligamento-robo.wav")
const VAR = preload("res://Sons/Identidade/colapso-var.wav")
const LIMITES = preload("res://script_limites_derrotas.gd").QUADROS
var identidade: String = ""
var duracao: float = 1.25
var tempo: float = 0.0
var quadro: int = 0
var _altura: float = 115.0
var _espelhar: bool = false
var _sprite: Sprite2D
var _portao: Node2D
var _velocidade_y: float = 0.0
var _chao_y: float = 0.0

func configurar(corpo: CharacterBody2D, abrir_portao: bool) -> void:
	var arquivo: String = corpo.get_script().resource_path.get_file()
	var dados: Array = CONFIG.get(arquivo, CONFIG["script_inimigo2.gd"])
	identidade = dados[0]
	_altura = dados[1]
	duracao = dados[2]
	var original: Sprite2D = corpo.get_node("Sprite2D")
	# A arte olha à esquerda; conservar a orientação exibida pelo inimigo.
	_espelhar = original.scale.x < 0
	var forma: CollisionShape2D = corpo.get_node("CollisionShape2D")
	var pes: Vector2 = forma.global_position + Vector2(0, forma.shape.get_rect().end.y * absf(forma.global_scale.y))
	global_position = pes
	_chao_y = pes.y
	# Se o último acerto ocorrer no salto, a derrota cai até a plataforma abaixo.
	var consulta := PhysicsRayQueryParameters2D.create(pes, pes + Vector2(0, 1300), 1, [corpo.get_rid()])
	var colisao := corpo.get_world_2d().direct_space_state.intersect_ray(consulta)
	if not colisao.is_empty():
		_chao_y = colisao.position.y
	if abrir_portao and is_instance_valid(ScriptGlobal.portao):
		_portao = ScriptGlobal.portao
	add_to_group("derrotas_inimigos")
	z_index = 2
	_sprite = Sprite2D.new()
	_sprite.texture = FOLHAS[identidade]
	_sprite.hframes = 3
	_sprite.vframes = 2
	_sprite.centered = false
	var primeiro: Array = LIMITES[identidade][0]
	_sprite.offset = Vector2(-256, -primeiro[3])
	_sprite.scale = Vector2(-1 if _espelhar else 1, 1) * (_altura / float(primeiro[3] - primeiro[1] + 1))
	_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(_sprite)
	var som := AudioStreamPlayer.new()
	som.stream = VAR if identidade == "var-01" else ROBO if identidade == "impedimento" else TANQUE if identidade == "haaland" else QUEDA
	som.bus = &"Efeitos"
	som.volume_db = -7.0
	add_child(som)
	som.play()

func _process(delta: float) -> void:
	tempo += delta
	if global_position.y < _chao_y:
		_velocidade_y += 1200.0 * delta
		global_position.y = minf(_chao_y, global_position.y + _velocidade_y * delta)
	# Reservar o final para a pose caída, seguida de uma saída suave.
	quadro = mini(5, int(tempo / (duracao * 0.78) * 6))
	_sprite.frame = quadro
	_sprite.offset.y = -LIMITES[identidade][quadro][3]
	_sprite.modulate.a = 1.0 - clampf((tempo / duracao - 0.86) / 0.14, 0, 1)
	if identidade == "var-01":
		_sprite.position.x = sin(tempo * 63.0) * (2.0 if tempo < 1.7 else 0.0)
		_sprite.modulate = Color(1.25, 0.7, 0.6, _sprite.modulate.a) if tempo < 1.5 and int(tempo * 17) % 3 == 0 else Color(1, 1, 1, _sprite.modulate.a)
		queue_redraw()
	if tempo >= duracao:
		if is_instance_valid(_portao) and not _portao.is_queued_for_deletion():
			_portao.get_node("AnimationPlayer").play("abrir")
		concluida.emit()
		queue_free()

func _draw() -> void:
	if identidade != "var-01" or tempo > 2.8:
		return
	var centro := Vector2(0, -_altura * (0.7 if quadro < 3 else 0.25))
	var forca: float = 1.0 - tempo / 2.8
	for i in range(7):
		var fase: float = fmod(tempo * 2.0 + i * 0.143, 1.0)
		var direcao := Vector2.from_angle(i * TAU / 7.0 + tempo * 0.2)
		var inicio: Vector2 = centro + direcao * (7 + fase * 35)
		draw_line(inicio, inicio + direcao * 6, Color(1, 0.25 + fase * 0.5, 0.05, forca * (1-fase)), 2.0)
