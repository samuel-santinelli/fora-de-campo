extends SceneTree
var falhas: int = 0
func _initialize() -> void:
	call_deferred("_executar")
func _exigir(valor: bool, mensagem: String) -> void:
	if not valor:
		falhas += 1
		push_error(mensagem)
func _aguardar(n: int = 3) -> void:
	for i in range(n):
		await process_frame
func _executar() -> void:
	var global = root.get_node("ScriptGlobal")
	global.resetar_variaveis()
	for nome in ["var-carga", "var-laser", "var-impacto", "var-pane", "arrancada", "passo-tanque", "salto-goleiro", "apito-cartao"]:
		var som: AudioStreamWAV = load("res://Sons/Identidade/%s.wav" % nome)
		_exigir(som.get_length() > 0.1 and som.loop_mode == AudioStreamWAV.LOOP_DISABLED, "SFX deve ser válido e não repetir: " + nome)
	var fase = load("res://cena_fase.tscn").instantiate()
	fase.get_node("HUD").apresentar_rivais = false
	root.add_child(fase)
	await _aguardar(30)
	var personagem = global.personagem
	for nome in ["AudioStreamPlayerCarrinho", "AudioStreamPlayerChutandoBola", "AudioStreamPlayerDano", "AudioStreamPlayerPulando"]:
		var audio: AudioStreamPlayer = personagem.get_node(nome)
		_exigir(audio.stream != null and audio.stream.get_length() > 0 and audio.bus == &"Efeitos", "SFX do jogador deve estar no canal Efeitos: " + nome)
	for caminho in ["Inimigo1/CharacterBody2D", "Inimigo2/CharacterBody2D", "Mbappe/CharacterBody2D", "Haaland/CharacterBody2D", "Neymar/CharacterBody2D", "Impedimento/CharacterBody2D", "Chefao/Chefao"]:
		_exigir(fase.get_node(caminho + "/Resistencia").som_dano != null, "Preservar som de dano: " + caminho)
	_exigir(fase.get_node("AudioStreamPlayer").bus == &"Musica", "Música da fase deve manter canal separado.")
	_exigir(fase.get_node("Inimigo1/CharacterBody2D/SomCartao").stream.resource_path.ends_with("apito-cartao.wav"), "Arbitragem deve ter sinal próprio.")
	var mbappe = fase.get_node("Mbappe/CharacterBody2D")
	mbappe.set_process(false)
	mbappe._mudar_estado(mbappe.Estado.ARRANCANDO)
	await _aguardar()
	var ouviu_arrancada: bool = false
	for audio in get_nodes_in_group("sons_identidade"):
		if audio.stream.resource_path.ends_with("arrancada.wav"):
			ouviu_arrancada = audio.bus == &"Efeitos" and audio.playing
	_exigir(ouviu_arrancada, "Arrancada deve disparar um SFX real no canal correto.")
	# Instância isolada para exercer carga/interrupção sem espera do guardião.
	var chefe = load("res://cena_chefao.tscn").instantiate()
	root.add_child(chefe)
	var corpo = chefe.get_node("Chefao")
	corpo.set_process(false)
	corpo._mudar(corpo.Estado.CARGA)
	_exigir(corpo.get_node("SomCarga").playing, "Carga deve iniciar sinal sonoro.")
	corpo._mudar(corpo.Estado.ATORDOADO)
	_exigir(not corpo.get_node("SomCarga").playing, "Interromper ataque deve parar carga.")
	await _aguardar()
	var ouviu_pane: bool = false
	for audio in get_nodes_in_group("sons_identidade"):
		if audio.stream.resource_path.ends_with("var-pane.wav"):
			ouviu_pane = audio.bus == &"Efeitos" and audio.playing
	_exigir(ouviu_pane, "Atordoamento deve disparar pane sonora.")
	global.personagem = null
	global.portao = null
	fase.queue_free()
	chefe.queue_free()
	await process_frame
	print("Verificação do áudio: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
