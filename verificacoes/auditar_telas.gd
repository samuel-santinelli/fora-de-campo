extends SceneTree

var falhas: int = 0
func _initialize() -> void:
	call_deferred("_executar")

func _exigir(condicao: bool, mensagem: String) -> void:
	if not condicao:
		falhas += 1
		push_error(mensagem)

func _executar() -> void:
	var musicas: Array[String] = []
	var telas := {
		"inicio": {"ButtonIniciar": "iniciar_jogo", "Buttonconfig": "ir_para_configuracoes", "ButtonSair": "sair"},
		"game_over": {"ButtonReiniciar": "reiniciar", "ButtonSair": "sair"},
		"final": {"Button": "ir_para_inicio"},
		"configuracoes": {"ButtonVoltar": "voltar", "CheckButton": "_silenciar"},
	}
	for nome in telas:
		var cena = load("res://cena_%s.tscn" % nome).instantiate()
		root.add_child(cena)
		for botao in telas[nome]:
			var controle: BaseButton = cena.get_node(("Menu/" if nome == "inicio" else "") + botao)
			_exigir(controle.pressed.is_connected(Callable(cena, telas[nome][botao])), "Conexão ausente: %s/%s" % [nome, botao])
			print("Tela %s / %s: texto=%s" % [nome, botao, controle.text])
		var audio: AudioStreamPlayer = cena.get_node("AudioStreamPlayer")
		_exigir(audio.stream != null and audio.autoplay, "Tela deve manter áudio configurado: " + nome)
		if nome in ["inicio", "game_over"]:
			musicas.append(audio.stream.resource_path)
		cena.queue_free()
		await process_frame
	var fase = load("res://cena_fase.tscn").instantiate()
	root.add_child(fase)
	await process_frame
	for filho in fase.get_children():
		if filho is AudioStreamPlayer:
			musicas.append(filho.stream.resource_path)
	_exigir(musicas.size() == 3 and musicas[0] != musicas[1] and musicas[0] != musicas[2] and musicas[1] != musicas[2], "Início, game over e fase devem ter músicas distintas.")
	var pausa = fase.get_node("HUD/ParallaxBackground/pausa")
	_exigir(pausa.process_mode == Node.PROCESS_MODE_ALWAYS and not pausa.visible and not paused, "Pausa deve iniciar oculta e poder processar durante congelamento.")
	pausa.set_process(false)
	Input.action_press("pausa")
	pausa._process(0)
	_exigir(paused and pausa.visible, "Ação de pausa deve congelar e exibir painel.")
	Input.action_release("pausa")
	await process_frame
	Input.action_press("pausa")
	pausa._process(0)
	_exigir(not paused and not pausa.visible, "Segunda ação deve retomar partida.")
	Input.action_release("pausa")
	root.get_node("ScriptGlobal").personagem = null
	root.get_node("ScriptGlobal").portao = null
	fase.queue_free()
	await process_frame
	print("Auditoria funcional das telas: %d falhas. Pendências visuais são registradas no diagnóstico." % falhas)
	quit(0 if falhas == 0 else 1)
