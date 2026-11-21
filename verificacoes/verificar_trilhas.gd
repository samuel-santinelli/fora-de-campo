extends SceneTree
var falhas: int = 0
func _initialize() -> void:
	call_deferred("_executar")
func _exigir(valor: bool, mensagem: String) -> void:
	if not valor:
		falhas += 1
		push_error(mensagem)
func _executar() -> void:
	var global = root.get_node("ScriptGlobal")
	var mapas = {"inicio": "inicio", "fase": "fase", "configuracoes": "configuracoes", "game_over": "game-over", "final": "vitoria"}
	for cena in mapas:
		global.resetar_variaveis()
		var no = load("res://cena_%s.tscn" % cena).instantiate()
		root.add_child(no)
		for i in range(4):
			await process_frame
		var encontrou: bool = false
		for audio in no.find_children("*", "AudioStreamPlayer", true, false):
			if audio.stream != null and audio.stream.resource_path == "res://Sons/Trilhas/musica-%s.wav" % mapas[cena]:
				encontrou = true
				_exigir(audio.bus == &"Musica" and audio.playing, "Trilha deve tocar no canal Musica: " + cena)
				var som: AudioStreamWAV = audio.stream
				_exigir(som.loop_mode == AudioStreamWAV.LOOP_FORWARD and som.get_length() > 25 and som.stereo, "Trilha deve ser estéreo, completa e em loop: " + cena)
		_exigir(encontrou, "Cena deve usar a nova composição: " + cena)
		global.personagem = null
		global.portao = null
		no.queue_free()
		await process_frame
	global.resetar_variaveis()
	print("Verificação das cinco trilhas: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
