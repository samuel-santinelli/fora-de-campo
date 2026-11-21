extends "res://script_bola_neymar.gd"
var vermelho: bool = false
func _ready() -> void:
	super._ready()
	velocidade = 550
	$Sprite2D.hide()
	get_parent().remove_from_group("bolas_neymar")
	get_parent().add_to_group("cartoes_sentenca")
func _draw() -> void:
	draw_rect(Rect2(-7, -10, 14, 20), Color("f93739") if vermelho else Color("ffe22c"))
	draw_rect(Rect2(-7, -10, 14, 20), Color("38212a"), false, 1)
