extends Node2D

var _final_agendado: bool = false

func _ready() -> void:
	ScriptGlobal.portao = self

func ir_para_final(body: Node2D) -> void:
	if body.name == "Personagem" and ScriptGlobal.qtd_vidas > 0 and not _final_agendado:
		_final_agendado = true
		get_tree().call_deferred("change_scene_to_file", "res://cena_final.tscn")
