extends SceneTree
var falhas: int = 0
func _initialize() -> void:
	call_deferred("_executar")
func _exigir(valor: bool, mensagem: String) -> void:
	if not valor:
		falhas += 1
		push_error(mensagem)
func _aguardar(n: int = 4) -> void:
	for i in range(n):
		await process_frame
func _executar() -> void:
	var global = root.get_node("ScriptGlobal")
	for reinicia in [true, false]:
		global.qtd_vidas = 0
		global.pontuacao = 99
		var tela = load("res://cena_game_over.tscn").instantiate()
		root.add_child(tela)
		current_scene = tela
		await _aguardar()
		_exigir(tela.get_node("Sprite2D").texture.resource_path.ends_with("game-over-v2.png"), "Usar versão de derrota aprovada.")
		_exigir(tela.get_node("ButtonReiniciar").has_focus(), "Focar tentativa ao abrir derrota.")
		_exigir(global.qtd_vidas == 0 and global.pontuacao == 99, "Exibir derrota não deve redefinir valores.")
		for tamanho in [Vector2i(1152,648), Vector2i(640,480), Vector2i(1920,1080)]:
			root.size = tamanho
			await _aguardar(2)
			var viewport: Vector2 = tela.get_viewport_rect().size
			for caminho in ["ButtonReiniciar", "ButtonSair", "TextoDerrota/Titulo", "TextoDerrota/Aviso"]:
				var rect: Rect2 = tela.get_node(caminho).get_global_rect()
				_exigir(rect.position.x >= 0 and rect.position.y >= 0 and rect.end.x <= viewport.x and rect.end.y <= viewport.y, "Controle deve caber na janela: " + caminho)
			var escala: Vector2 = tela.get_node("Sprite2D").scale
			var titulo: Rect2 = tela.get_node("TextoDerrota/Titulo").get_global_rect()
			var mensagem: Rect2 = tela.get_node("TextoDerrota/Mensagem").get_global_rect()
			_exigir(mensagem.position.y - titulo.end.y >= 27 * tela.get_node("TextoDerrota").scale.y, "Separar subtítulo do fim real do título.")
			_exigir(is_equal_approx(escala.x, escala.y), "Fundo deve manter proporções.")
		root.size = Vector2i(1152,648)
		tela.get_node("ButtonReiniciar" if reinicia else "ButtonSair").pressed.emit()
		# Segundo comando na mesma janela de eventos não pode trocar destino.
		if reinicia:
			tela.sair()
		else:
			tela.reiniciar()
		await _aguardar()
		var destino := "res://cena_fase.tscn" if reinicia else "res://cena_inicio.tscn"
		_exigir(current_scene.scene_file_path == destino, "Carregar destino escolhido uma única vez.")
		_exigir(global.qtd_vidas == 10 and global.pontuacao == 0, "Reset deve ocorrer ao escolher destino.")
		global.personagem = null
		global.portao = null
		current_scene.queue_free()
		await _aguardar()
	print("Verificação do game over: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
