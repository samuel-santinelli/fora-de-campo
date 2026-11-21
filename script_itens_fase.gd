extends Node2D
const ITEM = preload("res://script_coletavel.gd")

func _ready() -> void:
	# Apoios no piso contínuo; sem mudar terreno ou colisões do percurso.
	for x in [650, 2200, 4000, 5750, 7900, 9750, 11550]:
		_adicionar(x, ITEM.Tipo.BOLAS, 5)
	for x in [1800, 5300, 7400, 11000]:
		_adicionar(x, ITEM.Tipo.VIDA, 2)

func _adicionar(x: float, tipo: int, quantidade: int) -> void:
	var item := Area2D.new()
	item.set_script(ITEM)
	item.tipo = tipo
	item.quantidade = quantidade
	item.position = Vector2(x, 574)
	item.name = ("Vida" if tipo == ITEM.Tipo.VIDA else "Bolas") + str(int(x))
	add_child(item)
