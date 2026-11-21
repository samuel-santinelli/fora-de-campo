extends SceneTree
var falhas: int = 0
func _initialize() -> void:
	call_deferred("_executar")
func _exigir(valor: bool, mensagem: String) -> void:
	if not valor:
		falhas += 1
		push_error(mensagem)
func _aguardar(n: int) -> void:
	for i in range(n):
		await process_frame
func _executar() -> void:
	var global = root.get_node("ScriptGlobal")
	global.resetar_variaveis()
	var fase = load("res://cena_fase.tscn").instantiate()
	fase.get_node("HUD").apresentar_rivais = false
	root.add_child(fase)
	current_scene = fase
	await _aguardar(30)
	var guardiao = fase.get_node("Impedimento/CharacterBody2D")
	guardiao.receber_dano(5)
	await _aguardar(2)
	fase.get_node("Chefao/Chefao").receber_dano(6)
	await _aguardar(270)
	_exigir(not fase.get_node("Portao/Area2D/CollisionShape2D").disabled, "Derrota do chefe deve habilitar portão.")
	# Saltar somente o trajeto já testado, atravessando a área física real do portão.
	global.personagem.global_position = Vector2(12510, 553)
	Input.action_press("ir_para_direita")
	for i in range(50):
		await process_frame
		if is_instance_valid(current_scene) and current_scene.scene_file_path == "res://cena_final.tscn":
			break
	Input.action_release("ir_para_direita")
	await _aguardar(3)
	_exigir(current_scene.scene_file_path == "res://cena_final.tscn", "Atravessar portão deve carregar tela final real.")
	if current_scene.scene_file_path != "res://cena_final.tscn":
		quit(1)
		return
	var tela = current_scene
	_exigir(tela.get_node("Sprite2D").texture.resource_path.ends_with("vitoria-v1.png"), "Usar arte aprovada.")
	_exigir(tela.get_node("Button").has_focus(), "Focar retorno ao início.")
	for tamanho in [Vector2i(1152,648), Vector2i(640,480), Vector2i(1920,1080)]:
		root.size = tamanho
		await _aguardar(2)
		var viewport: Vector2 = tela.get_viewport_rect().size
		for caminho in ["Button", "TextoVitoria/Marca", "TextoVitoria/Titulo", "TextoVitoria/Mensagem", "TextoVitoria/Aviso"]:
			var rect: Rect2 = tela.get_node(caminho).get_global_rect()
			_exigir(rect.position.x >= 0 and rect.position.y >= 0 and rect.end.x <= viewport.x and rect.end.y <= viewport.y, "Manter controle no viewport: " + caminho)
		var titulo: Rect2 = tela.get_node("TextoVitoria/Titulo").get_global_rect()
		var mensagem: Rect2 = tela.get_node("TextoVitoria/Mensagem").get_global_rect()
		_exigir(mensagem.position.y - titulo.end.y >= 27 * tela.get_node("TextoVitoria").scale.y, "Separar mensagem do título.")
	root.size = Vector2i(1152,648)
	var vidas: int = global.qtd_vidas
	tela.get_node("Button").pressed.emit()
	tela.ir_para_inicio()
	await _aguardar(4)
	_exigir(current_scene.scene_file_path == "res://cena_inicio.tscn" and current_scene._tempo < 0, "Retornar ao menu utilizável.")
	_exigir(global.qtd_vidas == vidas, "Retorno deve preservar valores até iniciar nova partida.")
	global.personagem = null
	global.portao = null
	current_scene.queue_free()
	await process_frame
	print("Verificação da vitória: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
