extends SceneTree
## Capturas das cenas reais em execução. Não modifica o jogo ou seus recursos.
var destino: String = "res://entrega/capturas-renderizadas"
func _initialize() -> void:
	call_deferred("_executar")
func _aguardar(n: int = 4) -> void:
	for i in range(n):
		await process_frame
func _capturar(nome: String) -> void:
	await _aguardar(4)
	await RenderingServer.frame_post_draw
	var imagem: Image = root.get_texture().get_image()
	if imagem == null or imagem.is_empty():
		push_error("Renderização indisponível para " + nome)
		quit(1)
		return
	var erro: Error = imagem.save_png(destino.path_join(nome + ".png"))
	if erro != OK:
		push_error("Não foi possível salvar " + nome)
		quit(1)
		return
	print("Captura salva: " + nome)
func _trocar(arquivo: String) -> Node:
	paused = false
	if is_instance_valid(current_scene):
		current_scene.queue_free()
	await _aguardar(2)
	var cena = load(arquivo).instantiate()
	root.add_child(cena)
	current_scene = cena
	await _aguardar(6)
	return cena
func _executar() -> void:
	root.size = Vector2i(1152,648)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(destino))
	var preferencias = root.get_node("Preferencias")
	preferencias.entrada_web_confirmada = true
	await _trocar("res://cena_inicio.tscn")
	await _capturar("01-inicio")
	# Executar só uma captura é útil para conferir o renderizador disponível.
	if "--somente-inicio" in OS.get_cmdline_user_args():
		quit()
		return
	await _trocar("res://cena_configuracoes.tscn")
	await _capturar("02-configuracoes")
	var global = root.get_node("ScriptGlobal")
	global.resetar_variaveis()
	var fase = load("res://cena_fase.tscn").instantiate()
	fase.get_node("HUD").apresentar_rivais = false
	current_scene.queue_free()
	await _aguardar(2)
	root.add_child(fase)
	current_scene = fase
	await _aguardar(20)
	# Registrar a fase depois das dicas de comandos, como numa partida avançada.
	for no in fase.get_node("HUD/ParallaxBackground").get_children():
		if no.get_script() == load("res://script_orientacao_fase.gd"):
			no.indice_dica = no.DICAS.size()
			no._atualizar_dica()
	var jogador = global.personagem
	var camera: Camera2D = jogador.get_node("Camera2D")
	for caso in [["03-treino", 750.0], ["04-arbitragem", 2550.0], ["05-neymar", 4350.0], ["06-mbappe", 6150.0], ["07-haaland-navio", 8450.0], ["08-impedimento", 10100.0], ["09-var-01", 11700.0]]:
		if caso[0] == "09-var-01":
			fase.get_node("Impedimento/CharacterBody2D").receber_dano(5)
			await _aguardar(2)
		jogador.global_position = Vector2(caso[1], 547)
		camera.reset_smoothing()
		camera.force_update_scroll()
		await _aguardar(8)
		paused = true
		await _capturar(caso[0])
		paused = false
	var chefe = fase.get_node("Chefao/Chefao")
	chefe._mudar(chefe.Estado.CARGA)
	await _aguardar(35)
	chefe._mudar(chefe.Estado.LASER)
	await _aguardar(3)
	paused = true
	await _capturar("13-laser-do-var")
	paused = false
	fase.get_node("HUD/ParallaxBackground/pausa")._definir_pausa(true)
	await _capturar("10-pausa")
	paused = false
	global.personagem = null
	global.portao = null
	await _trocar("res://cena_game_over.tscn")
	await _capturar("11-fim-de-jogo")
	await _trocar("res://cena_final.tscn")
	await _capturar("12-vitoria")
	current_scene.queue_free()
	await _aguardar(2)
	print("Capturas da entrega concluídas.")
	quit()
