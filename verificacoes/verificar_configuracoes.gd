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
	var bus: int = AudioServer.get_bus_index("Master")
	var original: bool = AudioServer.is_bus_mute(bus)
	AudioServer.set_bus_mute(bus, false)
	var global = root.get_node("ScriptGlobal")
	global.qtd_vidas = 4
	global.pontuacao = 33
	var tela = load("res://cena_configuracoes.tscn").instantiate()
	root.add_child(tela)
	current_scene = tela
	await _aguardar()
	_exigir(tela.get_node("CheckButton").has_focus() and not tela.get_node("CheckButton").button_pressed, "Foco e estado inicial devem refletir áudio.")
	_exigir(tela.FUNDO.resource_path.ends_with("configuracoes-vestiario-v1.png"), "Usar arte do vestiário.")
	_exigir(tela.get_node("CheckButton").tooltip_text.is_empty() and tela.get_node("Label2").mouse_filter == Control.MOUSE_FILTER_IGNORE, "Ajuda fixa não deve interceptar controle ou abrir popup.")
	_exigir(tela.get_node("CheckButton").get_theme_icon("checked").get_size() == Vector2(52, 28), "Interruptor deve usar ícone próprio.")
	for tamanho in [Vector2i(1152,648), Vector2i(640,480), Vector2i(1920,1080)]:
		root.size = tamanho
		await _aguardar(2)
		var viewport: Vector2 = tela.get_viewport_rect().size
		var painel := Rect2(tela._origem, Vector2(440, 450) * tela._escala)
		for nome in ["Label", "Label2", "CheckButton", "ButtonVoltar", "Marca", "StatusAudio", "VolumePrincipal", "VolumeMusica", "VolumePersonagens"]:
			var rect: Rect2 = tela.get_node(nome).get_global_rect()
			_exigir(rect.position.x >= 0 and rect.position.y >= 0 and rect.end.x <= viewport.x and rect.end.y <= viewport.y, "Controle deve caber: " + nome)
			_exigir(painel.encloses(rect), "Controle deve ficar dentro do painel compacto: " + nome)
		var interruptor: Rect2 = tela.get_node("CheckButton").get_global_rect()
		var ajuda: Rect2 = tela.get_node("Label2").get_global_rect()
		_exigir(ajuda.position.y > interruptor.end.y, "Ajuda não deve sobrepor interruptor.")
	tela.get_node("VolumePrincipal").value = 70
	tela.get_node("VolumeMusica").value = 25
	tela.get_node("VolumePersonagens").value = 40
	_exigir(is_equal_approx(AudioServer.get_bus_volume_linear(bus), 0.7), "Volume principal deve atuar no Master.")
	_exigir(is_equal_approx(AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Musica")), 0.25), "Slider música deve atuar no canal próprio.")
	_exigir(is_equal_approx(AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Efeitos")), 0.4), "Personagens deve atuar nos efeitos.")
	_exigir(tela.get_node("AudioStreamPlayer").bus == &"Musica", "Música da tela deve ser roteada.")
	tela.get_node("VolumeMusica").value = 0
	_exigir(is_zero_approx(AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Musica"))), "Volume zero deve realmente silenciar canal.")
	tela.get_node("VolumeMusica").value = 25
	var efeito := AudioStreamPlayer.new()
	efeito.stream = load("res://Sons/Carrinho.mp3")
	tela.add_child(efeito)
	_exigir(efeito.bus == &"Efeitos", "Efeito criado em execução deve usar canal próprio.")
	_exigir(not tela.has_node("Resolucao") and not tela.has_node("Abas"), "Configura??es devem conter apenas ?udio.")
	tela.get_node("CheckButton").button_pressed = true
	tela.get_node("CheckButton").pressed.emit()
	_exigir(AudioServer.is_bus_mute(bus) and tela.get_node("StatusAudio").text == "Áudio silenciado", "Opção deve silenciar Master e informar estado.")
	tela.get_node("ButtonVoltar").pressed.emit()
	tela.voltar()
	await _aguardar()
	_exigir(current_scene.scene_file_path == "res://cena_inicio.tscn" and AudioServer.is_bus_mute(bus), "Retorno deve preservar áudio silenciado.")
	current_scene.get_node("Menu/Buttonconfig").pressed.emit()
	await _aguardar()
	_exigir(current_scene.get_node("CheckButton").button_pressed, "Reabrir deve refletir preferência atual.")
	_exigir(current_scene.get_node("VolumeMusica").value == 25 and current_scene.get_node("VolumePersonagens").value == 40, "Volumes devem permanecer ao reabrir.")
	current_scene.get_node("CheckButton").button_pressed = false
	current_scene.get_node("CheckButton").pressed.emit()
	_exigir(not AudioServer.is_bus_mute(bus), "Desmarcar deve reativar áudio.")
	_exigir(global.qtd_vidas == 4 and global.pontuacao == 33, "Configurações não devem alterar partida.")
	current_scene.queue_free()
	await _aguardar()
	AudioServer.set_bus_mute(bus, original)
	for canal in ["Master", "Musica", "Efeitos"]:
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(canal), 1.0)
	root.size = Vector2i(1152,648)
	global.resetar_variaveis()
	print("Verificação das configurações: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
