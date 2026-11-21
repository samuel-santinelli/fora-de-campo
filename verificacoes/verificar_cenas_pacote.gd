extends SceneTree
var falhas: int = 0
func _initialize() -> void:
	call_deferred("_executar")
func _executar() -> void:
	var global = root.get_node("ScriptGlobal")
	for caminho in ["res://cena_inicio.tscn", "res://cena_fase.tscn", "res://cena_configuracoes.tscn", "res://cena_game_over.tscn", "res://cena_final.tscn"]:
		global.resetar_variaveis()
		var recurso = load(caminho)
		if recurso == null:
			falhas += 1
			continue
		var cena = recurso.instantiate()
		root.add_child(cena)
		for i in range(12):
			await process_frame
		global.personagem = null
		global.portao = null
		cena.queue_free()
		await process_frame
	print("Verificação das cenas do pacote exportado: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
