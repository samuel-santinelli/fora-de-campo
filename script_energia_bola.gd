extends Node2D
## Efeito gráfico separado da bola e da detecção de acerto.

var direcao: int = 1
var impacto: bool = false
var fogo: bool = false
var _tempo: float = 0.0

func _process(delta: float) -> void:
	_tempo += delta
	if impacto and _tempo >= 0.22:
		queue_free()
		return
	queue_redraw()

func _draw() -> void:
	if impacto:
		var progresso: float = minf(1.0, _tempo / 0.22)
		for indice in range(10):
			var ponto := Vector2.from_angle(float(indice) * TAU / 10.0) * (4.0 + progresso * 16.0)
			var cor := Color(1.0, 0.40 if fogo else 0.87, 0.10 if fogo else 0.48, 1.0 - progresso)
			draw_rect(Rect2(ponto - Vector2(2, 0), Vector2(5, 1)), cor)
			draw_rect(Rect2(ponto - Vector2(0, 2), Vector2(1, 5)), cor)
		return
	if fogo:
		_desenhar_chamas()
		return
	for indice in range(6, 0, -1):
		var cor := Color("ffe59a") if indice % 2 == 0 else Color("d7a333")
		cor.a = (1.0 - float(indice) / 8.0) * 0.65
		var ponto := Vector2((-9 - indice * 6) * direcao, 1 + (indice % 3) * 2)
		if direcao < 0:
			ponto.x -= 12 + indice
		draw_rect(Rect2(ponto, Vector2(12 + indice, 1)), cor)
	for indice in range(16):
		var angulo: float = float(indice) * TAU / 16.0 + _tempo * 2.0
		var ponto := Vector2.from_angle(angulo) * (12.0 + sin(_tempo * 15.0)) + Vector2(0, 3)
		var cor := Color("fff0b8") if indice % 2 == 0 else Color("e9b343")
		cor.a = 0.8
		draw_rect(Rect2(ponto.round(), Vector2.ONE), cor)

func _desenhar_chamas() -> void:
	# Cauda em blocos, sempre atrás da bola e espelhada na direção do chute.
	draw_set_transform(Vector2(0, 3), 0, Vector2(direcao, 1))
	var oscilacao: float = roundf(sin(_tempo * 37.0) * 5.0)
	draw_circle(Vector2.ZERO, 21, Color(1.0, 0.45, 0.08, 0.18), false, 4, false)
	var externa := PackedVector2Array([Vector2(15, -5), Vector2(5, -16), Vector2(-14, -13), Vector2(-35, -20 + oscilacao), Vector2(-30, -10), Vector2(-60, -14), Vector2(-48, -4), Vector2(-90 - oscilacao, 0), Vector2(-55, 7), Vector2(-66, 16), Vector2(-35, 10), Vector2(-42, 22 - oscilacao), Vector2(-17, 14), Vector2(5, 16), Vector2(15, 5)])
	draw_colored_polygon(externa, Color("ef611d"))
	var interna := PackedVector2Array([Vector2(8, -8), Vector2(-12, -9), Vector2(-35, -12 + oscilacao * 0.5), Vector2(-28, -4), Vector2(-65, 0), Vector2(-29, 6), Vector2(-40, 13), Vector2(-12, 8), Vector2(8, 8)])
	draw_colored_polygon(interna, Color("ffc54d"))
	draw_colored_polygon(PackedVector2Array([Vector2(3, -4), Vector2(-12, -4), Vector2(-39, 0), Vector2(-12, 4), Vector2(3, 4)]), Color("fff1ae"))
	for i in range(10):
		var fase: float = fposmod(_tempo * 2.8 + i * 0.173, 1.0)
		var ponto := Vector2(-15 - fase * 95, sin(i * 2.4 + fase * 5.0) * (6 + fase * 18)).round()
		draw_rect(Rect2(ponto, Vector2(3, 2)), Color(1.0, 0.8, 0.2, (1.0 - fase) * 0.85))
	draw_set_transform(Vector2.ZERO)
