extends Node2D

var _arrancando: bool = false
var _avisando: bool = false
var _tempo: float = 0.0

func atualizar(arrancando: bool, avisando: bool, direcao: int, tempo: float) -> void:
	_arrancando = arrancando
	_avisando = avisando
	_tempo = tempo
	visible = arrancando or avisando
	scale = Vector2(-0.5 * direcao, 0.5)
	queue_redraw()

func _draw() -> void:
	if _avisando:
		draw_rect(Rect2(24, -230, 3, 9), Color("b6efff"))
		draw_rect(Rect2(24, -218, 3, 3), Color("b6efff"))
	if _arrancando:
		var fase: float = fmod(_tempo * 14.0, 1.0)
		for indice in range(5):
			var cor := Color("b6efff") if indice % 2 == 0 else Color("37a5ee")
			cor.a = (1.0 - float(indice) / 6.0) * 0.6
			var ponto := Vector2(85 + indice * 17 + roundf(fase * 12.0), -22 + (indice % 3) * 4)
			draw_rect(Rect2(ponto, Vector2(26 + indice * 3, 2)), cor)
