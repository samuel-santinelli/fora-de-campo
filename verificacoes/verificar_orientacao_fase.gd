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
	var jogador = global.personagem
	var ui = fase.get_node("HUD/ParallaxBackground/OrientacaoFase")
	_exigir(ui.indice_dica == 0 and ui.get_node("DicaComando").visible, "Mostrar comando de movimento no início.")
	_exigir(ui.apresentados.is_empty(), "Não apresentar rivais distantes no início.")
	Input.action_press("ir_para_direita")
	await _aguardar(50)
	Input.action_release("ir_para_direita")
	_exigir(ui.concluidas.has(&"mover") and ui.indice_dica == 1, "Movimento real deve concluir dica e avançar para pulo.")
	Input.action_press("pular")
	await _aguardar(1)
	Input.action_release("pular")
	await _aguardar(65)
	_exigir(ui.concluidas.has(&"pular") and ui.indice_dica == 2, "Salto real deve concluir dica.")
	Input.action_press("carrinho")
	await _aguardar(1)
	Input.action_release("carrinho")
	await _aguardar(45)
	_exigir(ui.concluidas.has(&"carrinho"), "Carrinho real deve concluir dica.")
	jogador.direcao = -1
	var estoque: int = global.qtd_bolas
	Input.action_press("chutar")
	await _aguardar(2)
	Input.action_release("chutar")
	await _aguardar(45)
	_exigir(ui.concluidas.has(&"chutar"), "Chute consumido deve concluir dica.")
	Input.action_press("chutar")
	await _aguardar(70)
	Input.action_release("chutar")
	await _aguardar(65)
	_exigir(ui.concluidas.has(&"superchute") and not ui._dica.visible, "Superchute real deve encerrar tutorial.")
	_exigir(not paused and global.qtd_bolas == estoque - 2, "Dicas não devem pausar ou conceder munição.")
	var antes: int = ui.apresentados.size()
	jogador.global_position = fase.to_global(Vector2(490, 547))
	await _aguardar(190)
	# Sinais leem estados existentes, sem executar a IA durante a asserção.
	var mbappe = fase.get_node("Mbappe/CharacterBody2D")
	mbappe.set_process(false)
	mbappe._direcao_arrancada = -1
	mbappe._mudar_estado(mbappe.Estado.AVISANDO)
	await _aguardar(1)
	_exigir(mbappe.get_node("SinalAtaque").aviso == "ARRANCADA!" and mbappe.tempo_aviso == 0.24, "Sinal de arrancada deve manter o tempo original.")
	mbappe._mudar_estado(mbappe.Estado.RECUPERANDO)
	await _aguardar(1)
	_exigir(not mbappe.get_node("SinalAtaque").visible, "Aviso deve sumir na recuperação.")
	var chefe = fase.get_node("Chefao/Chefao")
	chefe.set_process(false)
	chefe.get_parent().process_mode = Node.PROCESS_MODE_INHERIT
	chefe._mudar(chefe.Estado.CARGA)
	await _aguardar(2)
	_exigir(chefe.get_node("SinalAtaque").aviso.contains("LASER") and chefe.tempo_carga == 1.1, "Mostrar contrajogo do laser sem alterar carga.")
	chefe._mudar(chefe.Estado.GOLPE)
	await _aguardar(1)
	_exigir(chefe.get_node("SinalAtaque").aviso.contains("ONDA"), "Golpe deve sinalizar onda antes do impacto.")
	chefe._mudar(chefe.Estado.ATORDOADO)
	await _aguardar(1)
	_exigir(not chefe.get_node("SinalAtaque").visible, "Interrupção deve remover sinal de perigo.")
	var goleiro = fase.get_node("Inimigo2/CharacterBody2D")
	goleiro.set_process(false)
	goleiro.velocidade = 300
	jogador.global_position = goleiro.global_position + Vector2(-140, 0)
	await _aguardar(1)
	_exigir(goleiro.get_node("SinalAtaque").aviso.contains("SALTO"), "Goleiro próximo deve sinalizar salto.")
	global.personagem = null
	global.portao = null
	fase.queue_free()
	await process_frame
	global.resetar_variaveis()
	var outra = load("res://cena_fase.tscn").instantiate()
	root.add_child(outra)
	await _aguardar(12)
	var guia = outra.get_node("HUD/ParallaxBackground/OrientacaoFase")
	var novo_jogador = global.personagem
	for rival in guia.RIVAIS:
		outra.get_node(rival[0]).set_process(false)
	novo_jogador.set_process(false)
	for rival in guia.RIVAIS:
		var corpo = outra.get_node(rival[0])
		novo_jogador.global_position = corpo.global_position + Vector2(-300, 0)
		novo_jogador.get_node("Camera2D").force_update_scroll()
		guia._intervalo_apresentacao = 0
		await _aguardar(2)
		if rival[0] == "Chefao/Chefao":
			_exigir(not is_instance_valid(guia._modal), "VAR deve aguardar a liberacao do guardiao.")
			corpo.get_parent().process_mode = Node.PROCESS_MODE_INHERIT
			await _aguardar(2)
		_exigir(guia.apresentados.has(rival[0]) and is_instance_valid(guia._modal) and paused, "Retrato deve congelar a fase: " + rival[0])
		var card = guia._modal
		_exigir(card._retrato.texture != null and not card.dados.defesa.is_empty(), "Todos os rivais devem ter imagem e defesa.")
		var ponto: Vector2 = novo_jogador.global_position
		var tempo_chefe: float = outra.get_node("Chefao/Chefao")._tempo
		novo_jogador.set_process(true)
		Input.action_press("ir_para_direita")
		await _aguardar(34)
		_exigir(novo_jogador.global_position == ponto and outra.get_node("Chefao/Chefao")._tempo == tempo_chefe, "Mundo deve permanecer congelado durante o retrato.")
		Input.action_release("ir_para_direita")
		novo_jogador.set_process(false)
		outra.get_node("HUD/ParallaxBackground/pausa")._definir_pausa(true)
		_exigir(not outra.get_node("HUD/ParallaxBackground/pausa").visible, "Menu de pausa nao deve abrir sobre a apresentacao.")
		card.concluir()
		await _aguardar(1)
		_exigir(not paused and not is_instance_valid(guia._modal), "Continuar deve devolver o controle.")
		guia._intervalo_apresentacao = 0
		await _aguardar(1)
		_exigir(not is_instance_valid(guia._modal), "Nao repetir retrato ja apresentado.")
	guia._abrir_rival("Haaland/CharacterBody2D", "HAALAND", 5)
	await _aguardar(260)
	_exigir(not paused and not is_instance_valid(guia._modal), "Apresentacao deve terminar automaticamente.")
	guia._abrir_rival("Haaland/CharacterBody2D", "HAALAND", 5)
	outra.queue_free()
	await process_frame
	_exigir(not paused, "Remover a fase nao deve deixar pausa presa.")
	global.personagem = null
	global.portao = null
	global.resetar_variaveis()
	print("Verificação das dicas, apresentações e sinais: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
