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
	await _aguardar(30)
	for nome in ["Inimigo1", "Inimigo2", "Neymar", "Mbappe", "Haaland", "Impedimento", "Chefao", "Portao"]:
		fase.get_node(nome).queue_free()
	var jogador = global.personagem
	var camera = jogador.get_node("Camera2D")
	var impacto = jogador.get_node("ImpactoCamera")
	var zoom_base: Vector2 = camera.zoom
	var offset_base: Vector2 = camera.offset
	Input.action_press("chutar")
	await _aguardar(70)
	_exigir(camera.zoom.x > zoom_base.x + 0.02, "Carga deve aproximar levemente a câmera.")
	Input.action_release("chutar")
	var disparou: bool = false
	var tremeu: bool = false
	var fogo_rapido: bool = false
	for i in range(45):
		await process_frame
		if impacto._impacto > 0.18:
			disparou = true
			tremeu = tremeu or absf(camera.offset.y - offset_base.y) > 0.1
		for filho in fase.get_node("Jogador").get_children():
			if filho.has_node("CharacterBody2D/Energia"):
				var bola = filho.get_node("CharacterBody2D")
				fogo_rapido = fogo_rapido or (bola.dano == 2 and bola.velocidade == 720 and bola.get_node("Energia").fogo)
	_exigir(disparou and tremeu, "Superchute real deve disparar impacto de câmera na saída da bola.")
	_exigir(fogo_rapido, "Superchute deve gerar bola de fogo a 720 px/s.")
	await _aguardar(90)
	_exigir(camera.zoom == zoom_base and camera.offset == offset_base and Engine.time_scale == 1.0, "Foco deve retornar sem alterar velocidade da partida.")
	Input.action_press("chutar")
	await _aguardar(2)
	Input.action_release("chutar")
	await _aguardar(28)
	_exigir(impacto._impacto == 0.0, "Chute comum não deve tremer a tela.")
	var alerta = fase.get_node("HUD/AlertaVida")
	global.qtd_vidas = 3
	await _aguardar(25)
	_exigir(alerta.intensidade > 0.4 and alerta.get_node("AvisoVidaCritica").visible, "Vida baixa deve exibir bordas e aviso.")
	global.qtd_vidas = 1
	await _aguardar(20)
	_exigir(alerta.intensidade > 0.9, "Último ponto de vida deve intensificar o alerta.")
	paused = true
	var tempo: float = alerta._tempo
	await _aguardar(8)
	_exigir(alerta._tempo == tempo, "Pausa deve congelar o pulso.")
	paused = false
	global.recuperar_vida(5)
	await _aguardar(30)
	_exigir(alerta.intensidade == 0 and not alerta.get_node("AvisoVidaCritica").visible, "Cura acima do limite crítico deve remover o alerta.")
	# Separar o teste de contato dos projéteis disparados no teste de câmera.
	for filho in fase.get_node("Jogador").get_children():
		if filho != jogador:
			filho.queue_free()
	await process_frame
	jogador.set_process(false)
	jogador.global_position = Vector2(1000, 553)
	var cena_goleiro = load("res://cena_muralha.tscn").instantiate()
	fase.add_child(cena_goleiro)
	var goleiro = cena_goleiro.get_node("CharacterBody2D")
	goleiro.global_position = Vector2(1080, 553)
	goleiro.perseguir()
	var vida: int = global.qtd_vidas
	for i in range(30):
		await process_frame
		if global.qtd_vidas < vida:
			break
	_exigir(global.qtd_vidas == vida - 1, "Perseguição deve causar dano por colisão real.")
	for i in range(15):
		goleiro.global_position = jogador.global_position + Vector2(15, 0)
		await process_frame
	_exigir(global.qtd_vidas == vida - 1, "Contato contínuo deve respeitar intervalo de dano.")
	await _aguardar(60)
	for i in range(8):
		goleiro.global_position = jogador.global_position + Vector2(15, 0)
		await process_frame
	_exigir(global.qtd_vidas < vida - 1, "Novo contato após intervalo deve voltar a causar dano.")
	goleiro.encerrar_perseguicao()
	vida = global.qtd_vidas
	for i in range(65):
		goleiro.global_position = jogador.global_position + Vector2(15, 0)
		await process_frame
	_exigir(global.qtd_vidas == vida, "Goleiro desativado não deve causar dano.")
	jogador._iniciar_derrota()
	await _aguardar(25)
	_exigir(camera.zoom == zoom_base and camera.offset == offset_base and not alerta.get_node("AvisoVidaCritica").visible, "Derrota deve restaurar câmera e ocultar aviso de sobrevivência.")
	global.personagem = null
	global.portao = null
	fase.queue_free()
	await process_frame
	global.resetar_variaveis()
	print("Verificação do feedback e contato do goleiro: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
