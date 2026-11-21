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
	var inicio = load("res://cena_inicio.tscn").instantiate()
	root.add_child(inicio)
	await _aguardar(5)
	inicio._mostrar_entrada_web()
	await _aguardar(2)
	_exigir(inicio.has_node("EntradaWeb"), "Entrada deve explicar ativação do áudio.")
	inicio.get_node("EntradaWeb").find_child("Entrar", true, false).pressed.emit()
	await _aguardar(2)
	_exigir(not inicio.has_node("EntradaWeb") and root.get_node("Preferencias").entrada_web_confirmada, "Um clique deve liberar menu e registrar entrada na sessão.")
	for tecla in [KEY_C, KEY_A, KEY_D]:
		for i in range(20):
			var evento := InputEventKey.new()
			evento.keycode = tecla
			evento.physical_keycode = tecla
			evento.pressed = true
			evento.echo = true
			Input.parse_input_event(evento)
			await process_frame
		var soltar := InputEventKey.new()
		soltar.keycode = tecla
		soltar.physical_keycode = tecla
		Input.parse_input_event(soltar)
	_exigir(inicio._tempo < 0 and inicio.get_node("AudioStreamPlayer").playing, "Teclas repetidas não devem reiniciar menu ou parar música.")
	inicio.queue_free()
	await process_frame
	var config = load("res://cena_configuracoes.tscn").instantiate()
	root.add_child(config)
	await _aguardar(4)
	for nome in ["Principal", "Musica", "Personagens"]:
		_exigir(not config.get_node("Valor" + nome).get_global_rect().intersects(config.get_node("Volume" + nome).get_global_rect()), "Percentual deve ficar fora do slider: " + nome)
	config.queue_free()
	await process_frame
	var fase = load("res://cena_fase.tscn").instantiate()
	fase.get_node("HUD").apresentar_rivais = false
	root.add_child(fase)
	await _aguardar(12)
	for nome in ["IconeSaude", "IconeBola"]:
		var icone = fase.get_node("HUD/ParallaxBackground/" + nome)
		var imagem: Image = icone.texture.get_image()
		_exigir(not imagem.is_empty() and not imagem.is_invisible(), "Ícone precisa conter pixels visíveis: " + nome)
	var pausa = fase.get_node("HUD/ParallaxBackground/BotaoPausa")
	_exigir(pausa.icon != null and not pausa.icon.get_image().is_invisible(), "Pausa deve usar imagem, sem depender de glifo de fonte.")
	var alerta = fase.get_node("HUD/AlertaVida")
	global.qtd_vidas = 1
	await _aguardar(30)
	_exigir(alerta._borda.visible and alerta._borda.material == null, "Vida crítica deve funcionar sem shader de tela inteira.")
	global.recuperar_vida(6)
	await _aguardar(30)
	_exigir(not alerta._borda.visible and alerta.intensidade == 0, "Cura deve encerrar completamente o efeito crítico.")
	global.personagem = null
	global.portao = null
	fase.queue_free()
	await process_frame
	_exigir(not is_instance_valid(alerta), "Efeito crítico não deve vazar para outras telas.")
	global.resetar_variaveis()
	print("Verificação de estabilidade e interface Web: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
