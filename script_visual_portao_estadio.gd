extends Node2D
## Acabamento em pixels, sincronizado à animação funcional já existente.
const ABERTURA := Rect2(-84, -136, 168, 227)
var abertura: float = 0.0

func _ready() -> void:
	# A escala da instância original continua valendo para a área de vitória.
	scale = Vector2.ONE / get_parent().scale
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

func _process(_delta: float) -> void:
	var animacao: AnimationPlayer = get_parent().get_node("AnimationPlayer")
	var sprite: Sprite2D = get_parent().get_node("Sprite2D")
	var progresso: float = abertura
	if animacao.is_playing() and animacao.current_animation == "abrir":
		# A área de vitória é habilitada aos 0,4 s: folhas recolhidas até lá.
		progresso = clampf(animacao.current_animation_position / 0.4, 0, 1)
	elif sprite.region_rect.position.y >= 1000:
		progresso = 1.0
	elif sprite.region_rect.position.y < 500:
		progresso = 0.0
	if not is_equal_approx(abertura, progresso):
		abertura = progresso
		queue_redraw()

func _folha(area: Rect2, esquerda: bool) -> void:
	if area.size.x < 1:
		return
	draw_rect(area, Color("303c50"))
	draw_rect(area, Color("172131"), false, 2)
	for y in range(int(area.position.y + 12), int(area.end.y - 8), 18):
		draw_line(Vector2(area.position.x + 2, y), Vector2(area.end.x - 2, y), Color("536078"), 2)
	var borda: float = area.end.x - 3 if esquerda else area.position.x + 1
	draw_line(Vector2(borda, area.position.y + 3), Vector2(borda, area.end.y - 3), Color("bba275"), 2)
	if area.size.x > 18:
		for y in [area.position.y + 7, area.end.y - 8]:
			draw_rect(Rect2(area.position.x + 6, y, 3, 3), Color("a0acbc"))

func _draw() -> void:
	# Folhas recolhem para dentro do batente; não invadem o espaço do combate.
	var largura: float = floorf(ABERTURA.size.x * 0.5 * (1.0 - abertura))
	_folha(Rect2(ABERTURA.position, Vector2(largura, ABERTURA.size.y)), true)
	_folha(Rect2(ABERTURA.end.x - largura, ABERTURA.position.y, largura, ABERTURA.size.y), false)
	for x in [ABERTURA.position.x - 5, ABERTURA.end.x]:
		draw_rect(Rect2(x, ABERTURA.position.y - 4, 5, ABERTURA.size.y + 4), Color("1e2a3c"))
		draw_line(Vector2(x + 1, ABERTURA.position.y), Vector2(x + 1, ABERTURA.end.y), Color("67758b"), 1)
	draw_rect(Rect2(ABERTURA.position.x - 5, ABERTURA.position.y - 7, ABERTURA.size.x + 10, 7), Color("45536a"))
	# Vermelho fechado, dourado liberado: sem confundir com o laser do chefe.
	var sinal := Color("e2b85d") if abertura >= 1.0 else Color("b84945")
	draw_rect(Rect2(-9, ABERTURA.position.y - 5, 18, 3), sinal)
