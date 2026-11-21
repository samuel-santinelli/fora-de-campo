extends Node2D
## A arte nova contem o navio e a prancha; aqui existe somente a colisao alinhada.
const LAYOUT = preload("res://script_layout_percurso.gd")
func _ready() -> void:
	var corpo := StaticBody2D.new()
	corpo.name = "DesembarqueNavio"
	corpo.collision_layer = 1
	corpo.collision_mask = 0
	var colisao := CollisionPolygon2D.new()
	var pontos := PackedVector2Array()
	for ponto in LAYOUT.RAMPA_FONTE:
		pontos.append(Vector2(LAYOUT.INICIO_NAVIO, 0) + ponto * LAYOUT.ESCALA_FUNDO)
	colisao.polygon = pontos
	corpo.add_child(colisao)
	add_child(corpo)
