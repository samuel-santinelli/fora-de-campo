extends ProgressBar
## Indicador visual ligado à resistência existente; sem colisão ou regra de dano.
var resistencia: Node

func _ready() -> void:
	show_percentage = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	focus_mode = Control.FOCUS_NONE
	z_index = 20
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	max_value = resistencia.vida_maxima
	value = resistencia.vida_atual
	size = Vector2(96, 10) if resistencia.abre_portao else Vector2(64, 8)
	var fundo := StyleBoxFlat.new()
	fundo.bg_color = Color("0a1423")
	fundo.border_color = Color("d4b477") if resistencia.abre_portao else Color("778494")
	fundo.set_border_width_all(1)
	add_theme_stylebox_override("background", fundo)
	var preenchimento := StyleBoxFlat.new()
	preenchimento.bg_color = Color("c8464c")
	add_theme_stylebox_override("fill", preenchimento)
	resistencia.vida_alterada.connect(_atualizar)
	# Esperar os scripts dos personagens ajustarem textura/escala do sprite.
	_posicionar.call_deferred()

func _posicionar() -> void:
	var corpo := get_parent()
	var topo: float = -60
	var centro: float = 0
	var colisao: CollisionShape2D = corpo.get_node_or_null("CollisionShape2D")
	if colisao != null and colisao.shape is RectangleShape2D:
		topo = colisao.position.y - colisao.shape.size.y / 2
		centro = colisao.position.x
	var sprite: Sprite2D = corpo.get_node_or_null("Sprite2D")
	if sprite != null and sprite.texture != null:
		topo = minf(topo, sprite.position.y + sprite.get_rect().position.y * sprite.scale.y)
	position = Vector2(centro - size.x / 2, topo - size.y - 12)

func _atualizar(atual: int, maxima: int) -> void:
	max_value = maxima
	value = atual
	visible = atual > 0
