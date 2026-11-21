extends "res://script_bola_neymar.gd"
## Mesmo projétil inimigo com sinal luminoso amarelo desenhado, sem bola.

func _ready() -> void:
	super._ready()
	velocidade = 420
	$Sprite2D.hide()
	get_parent().remove_from_group("bolas_neymar")
	get_parent().add_to_group("sinalizadores_impedimento")

func _draw() -> void:
	draw_rect(Rect2(-9, -4, 18, 8), Color("ffbd19"))
	draw_rect(Rect2(-5, -2, 10, 4), Color("fff3a1"))
