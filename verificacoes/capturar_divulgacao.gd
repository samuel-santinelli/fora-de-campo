extends SceneTree
## Capturas das cenas reais em execução. Não modifica o jogo ou seus recursos.
var destino: String = ""
var _fase: Node
var _jogador: CharacterBody2D
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
	var argumentos := OS.get_cmdline_user_args()
	for i in range(argumentos.size() - 1):
		if argumentos[i] == "--destino":
			destino = argumentos[i + 1]
	if destino.is_empty() or not destino.is_absolute_path():
		push_error("Informe --destino com uma pasta absoluta para as capturas.")
		quit(1)
		return
	root.content_scale_size = Vector2i(1152,648)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	root.borderless = true
	root.size = Vector2i(1920,1080)
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
	_fase = fase
	await _aguardar(20)
	# Registrar a fase depois das dicas de comandos, como numa partida avançada.
	for no in fase.get_node("HUD/ParallaxBackground").get_children():
		if no.get_script() == load("res://script_orientacao_fase.gd"):
			no.indice_dica = no.DICAS.size()
			no._atualizar_dica()
	var jogador = global.personagem
	_jogador = jogador
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
	fase.get_node("HUD/ParallaxBackground/pausa")._definir_pausa(false)
	await _momentos_de_combate()
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

func _preparar_combate(x: float, y: float = 547.0) -> void:
	paused = false
	for acao in [&"ir_para_direita", &"ir_para_esquerda", &"pular", &"chutar", &"carrinho"]:
		Input.action_release(acao)
	var global = root.get_node("ScriptGlobal")
	global.qtd_vidas = 10
	global.qtd_bolas = 10
	for caminho in ["Inimigo2/CharacterBody2D", "Inimigo1/CharacterBody2D", "Neymar/CharacterBody2D", "Mbappe/CharacterBody2D", "Haaland/CharacterBody2D", "Chefao/Chefao"]:
		var corpo = _fase.get_node_or_null(caminho)
		if corpo != null:
			corpo.set_process(false)
	_jogador._cancelar_chute()
	_jogador._cancelar_carrinho()
	_jogador.animando = false
	_jogador.global_position = Vector2(x, y)
	_jogador.velocity = Vector2.ZERO
	_jogador.direcao = 1
	_jogador.get_node("Camera2D").reset_smoothing()
	_jogador.get_node("Camera2D").force_update_scroll()
	await _aguardar(40)

func _registrar_momento(nome: String) -> void:
	paused = true
	await _capturar(nome)
	paused = false

func _momentos_de_combate() -> void:
	await _preparar_combate(4280)
	Input.action_press("chutar")
	await _aguardar(65)
	Input.action_release("chutar")
	await _aguardar(28)
	if root.get_node("ScriptGlobal").qtd_bolas != 9:
		push_error("Superchute não foi executado; captura de divulgação interrompida.")
		quit(1)
		return
	await _registrar_momento("14-superchute-em-chamas")
	await _preparar_combate(850)
	Input.action_press("carrinho")
	await _aguardar(2)
	Input.action_release("carrinho")
	await _aguardar(11)
	await _registrar_momento("15-carrinho-relampago")
	await _preparar_combate(6150)
	var mbappe = _fase.get_node("Mbappe/CharacterBody2D")
	mbappe._ativo = true
	mbappe._direcao_arrancada = -1
	mbappe._mudar_estado(mbappe.Estado.ARRANCANDO)
	mbappe.set_process(true)
	Input.action_press("pular")
	await _aguardar(2)
	Input.action_release("pular")
	await _aguardar(10)
	await _registrar_momento("16-arrancada-do-mbappe")
	await _preparar_combate(2550)
	var sentenca = _fase.get_node("Inimigo1/CharacterBody2D")
	sentenca.direcao_inimigo = -1
	sentenca._vermelho = true
	sentenca.atirar_cartao()
	Input.action_press("pular")
	await _aguardar(2)
	Input.action_release("pular")
	await _aguardar(12)
	await _registrar_momento("17-cartao-vermelho")
	await _preparar_combate(11670)
	var chefe = _fase.get_node("Chefao/Chefao")
	chefe._direcao_ataque = -1
	chefe._mudar(chefe.Estado.CARGA)
	Input.action_press("pular")
	await _aguardar(2)
	Input.action_release("pular")
	await _aguardar(11)
	chefe._mudar(chefe.Estado.LASER)
	chefe.queue_redraw()
	await _registrar_momento("18-desvio-do-laser")
	await _preparar_combate(11670)
	chefe.receber_dano(6)
	await _aguardar(130)
	await _registrar_momento("19-colapso-do-var")
