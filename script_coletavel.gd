extends Area2D
enum Tipo {VIDA, BOLAS}
@export var tipo: Tipo = Tipo.VIDA
@export var quantidade: int = 2
const BOLA = preload("res://Bola.png")
const SOM = preload("res://Sons/Identidade/coleta-campo.wav")
var consumido: bool = false
var _tempo: float = 0.0

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var forma := CircleShape2D.new()
	forma.radius = 25
	var colisao := CollisionShape2D.new()
	colisao.shape = forma
	add_child(colisao)
	body_entered.connect(_coletar)
	add_to_group("coletaveis")

func _physics_process(delta: float) -> void:
	_tempo += delta
	queue_redraw()
	# Permite recolher sem sair da área quando um recurso antes cheio é gasto.
	for corpo in get_overlapping_bodies():
		_coletar(corpo)

func _coletar(corpo: Node2D) -> void:
	if consumido or corpo != ScriptGlobal.personagem or ScriptGlobal.qtd_vidas <= 0:
		return
	var ganho: int = ScriptGlobal.recuperar_vida(quantidade) if tipo == Tipo.VIDA else ScriptGlobal.repor_bolas(quantidade)
	if ganho <= 0:
		return
	consumido = true
	hide()
	_finalizar.call_deferred()

func _finalizar() -> void:
	var som := AudioStreamPlayer.new()
	som.stream = SOM
	som.bus = &"Efeitos"
	som.volume_db = -8
	get_parent().add_child(som)
	som.finished.connect(som.queue_free)
	som.play()
	queue_free()

func _draw() -> void:
	draw_line(Vector2(-17, 23), Vector2(17, 23), Color("c6a366"), 2)
	draw_set_transform(Vector2(0, -sin(_tempo * 3) * 3))
	# Ícones em blocos de pixels: bolsa de primeiros socorros e reserva de bolas.
	draw_rect(Rect2(-19, -20, 38, 38), Color("142034"))
	draw_rect(Rect2(-17, -18, 34, 34), Color("8c3037") if tipo == Tipo.VIDA else Color("364b61"))
	draw_rect(Rect2(-17, -18, 34, 34), Color("d0ad66"), false, 2)
	if tipo == Tipo.VIDA:
		draw_rect(Rect2(-4, -12, 8, 23), Color("fff0cf"))
		draw_rect(Rect2(-11, -5, 22, 8), Color("fff0cf"))
	else:
		draw_texture_rect(BOLA, Rect2(-13, -14, 26, 26), false)
	draw_set_transform(Vector2.ZERO)
