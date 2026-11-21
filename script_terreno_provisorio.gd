extends Node2D
## Piso continuo com a mesma textura dos panoramas, sem caixas ou plataformas desenhadas.
const REVESTIMENTO = preload("res://arte/cenarios/percurso-v2/01-treino.png")
const FIM_ARTE: float = 13000.0
func _draw() -> void:
	var terreno = get_parent()
	var pontos: PackedVector2Array = terreno.get_node("CollisionPolygon2D").polygon
	draw_colored_polygon(pontos, Color("333345"))
	var deslocamento: float = terreno.position.x
	var x: float = -deslocamento
	while x < FIM_ARTE - deslocamento:
		var largura: float = minf(160, FIM_ARTE - deslocamento - x)
		var origem: float = fposmod(x + deslocamento, 2000)
		draw_texture_rect_region(REVESTIMENTO, Rect2(x, -1, largura, 46), Rect2(origem, 588, largura, 136))
		x += largura
	draw_line(Vector2(-deslocamento, -1), Vector2(FIM_ARTE - deslocamento, -1), Color("d0bca4"), 2)
