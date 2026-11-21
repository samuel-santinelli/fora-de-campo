extends SceneTree
var falhas: int = 0
func _initialize() -> void:
	call_deferred("_executar")
func _exigir(valor: bool, mensagem: String) -> void:
	if not valor:
		falhas += 1
		push_error(mensagem)
func _aguardar() -> void:
	for i in range(4):
		await process_frame
func _limpar() -> void:
	root.get_node("ScriptGlobal").personagem = null
	root.get_node("ScriptGlobal").portao = null
	if is_instance_valid(current_scene):
		current_scene.queue_free()
	await _aguardar()
func _menu() -> Node:
	var menu = load("res://cena_inicio.tscn").instantiate()
	root.add_child(menu)
	current_scene = menu
	menu.set_process(false)
	return menu
func _executar() -> void:
	var global = root.get_node("ScriptGlobal")
	for modo in ["normal", "botao", "esc"]:
		var menu = _menu()
		global.qtd_vidas = 3
		global.pontuacao = 99
		var iniciar: Button = menu.get_node("Menu/ButtonIniciar")
		_exigir(not iniciar.text.is_empty() and iniciar.pressed.is_connected(Callable(menu, "iniciar_jogo")), "Preservar botão real e callback.")
		_exigir(not menu.get_node("Sprite2D").visible and menu._quadros.size() == 6, "Usar capa nova e seis poses.")
		var metadados = JSON.parse_string(FileAccess.get_file_as_string("res://arte/telas/cristiano-abertura-v1.json"))
		for i in range(6):
			for chave in ["x", "y", "w", "h", "anchor"]:
				_exigir(int(menu._quadros[i][chave]) == int(metadados.frames[i][chave]), "Recortes exportáveis devem corresponder à prévia aprovada.")
		for tamanho in [Vector2i(1152,648), Vector2i(640,480), Vector2i(1920,1080)]:
			root.size = tamanho
			await process_frame
			menu._organizar()
			# canvas_items usa unidades lógicas, diferentes dos pixels da janela.
			var viewport: Vector2 = menu.get_viewport_rect().size
			for nome in ["ButtonIniciar", "Buttonconfig", "ButtonSair", "Titulo", "Controles"]:
				var rect: Rect2 = menu.get_node("Menu/" + nome).get_global_rect()
				_exigir(rect.position.x >= 0 and rect.end.x <= viewport.x and rect.end.y <= viewport.y, "Controle deve permanecer no viewport: " + nome)
		root.size = Vector2i(1152,648)
		menu.iniciar_jogo()
		menu._process(0.2)
		menu.iniciar_jogo()
		_exigir(is_equal_approx(menu._tempo, 0.2) and iniciar.disabled, "Clique repetido não deve reiniciar abertura.")
		_exigir(global.qtd_vidas == 3 and global.pontuacao == 99, "Reset deve ocorrer apenas ao entrar na partida.")
		if modo == "normal":
			menu._process(menu.DURACAO)
		elif modo == "botao":
			menu.get_node("PularAbertura").pressed.emit()
		else:
			var evento := InputEventAction.new()
			evento.action = "ui_cancel"
			evento.pressed = true
			menu._unhandled_input(evento)
		menu._concluir_abertura()
		await _aguardar()
		_exigir(is_instance_valid(current_scene) and current_scene.scene_file_path == "res://cena_fase.tscn", "Conclusão deve carregar fase: " + modo)
		_exigir(global.qtd_vidas == 10 and global.pontuacao == 0, "Nova partida deve redefinir vidas e pontos.")
		await _limpar()
	var menu = _menu()
	global.qtd_vidas = 4
	menu.get_node("Menu/Buttonconfig").pressed.emit()
	await _aguardar()
	_exigir(current_scene.scene_file_path == "res://cena_configuracoes.tscn" and global.qtd_vidas == 4, "Configurações devem preservar valores.")
	current_scene.get_node("ButtonVoltar").pressed.emit()
	await _aguardar()
	_exigir(current_scene.scene_file_path == "res://cena_inicio.tscn" and current_scene._tempo < 0, "Voltar deve restaurar menu utilizável.")
	await _limpar()
	global.resetar_variaveis()
	print("Verificação do menu inicial: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
