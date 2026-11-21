extends SceneTree

var falhas: int = 0

func _initialize() -> void:
	call_deferred("_executar")

func _exigir(condicao: bool, mensagem: String) -> void:
	if not condicao:
		falhas += 1
		push_error(mensagem)

func _aguardar_quadros(quantidade: int) -> void:
	for i in range(quantidade):
		await process_frame

func _executar() -> void:
	var visual = load("res://script_corrida_cristiano.gd").new()
	root.add_child(visual)
	_exigir(not visual.visible, "Corrida deve iniciar oculta.")
	visual.atualizar(0.08, 1, true)
	_exigir(visual.visible and visual._quadro == 1, "Deve reproduzir o ciclo aprovado.")
	visual.atualizar(0.45, -1, true)
	_exigir(visual._quadro == 0 and visual.scale.x < 0.0, "Deve completar o ciclo e acompanhar a direção.")
	_exigir(not visual.atualizar(0.01, 1, false), "Deve ocultar a corrida quando interrompida.")
	visual.interromper(0.5)
	_exigir(not visual.atualizar(0.1, 1, true), "Dano deve bloquear corrida visual por meio segundo.")
	_exigir(visual.atualizar(0.41, 1, true), "Corrida deve retomar após bloqueio.")
	visual.free()

	# Cena isolada com o jogador real e um piso; sem inimigos interferindo.
	var piso := StaticBody2D.new()
	var colisao := CollisionShape2D.new()
	var forma := RectangleShape2D.new()
	forma.size = Vector2(2000, 40)
	colisao.shape = forma
	piso.position = Vector2(500, 400)
	piso.add_child(colisao)
	root.add_child(piso)
	var cena = load("res://cena_jogador.tscn").instantiate()
	cena.position = Vector2.ZERO
	root.add_child(cena)
	var personagem = cena.get_node("Personagem")
	personagem.position = Vector2(300, 300)
	await _aguardar_quadros(30)
	_exigir(personagem.is_on_floor(), "Jogador deve repousar no piso de teste.")
	_exigir(personagem.get_node("EsperaCristiano").visible, "Parado deve usar a espera aprovada.")
	Input.action_press("ir_para_direita")
	await _aguardar_quadros(4)
	_exigir(personagem.get_node("CorridaCristiano").visible, "Andar deve mostrar a nova corrida.")
	_exigir(not personagem.get_node("Sprite2D").visible and not personagem.get_node("EsperaCristiano").visible, "Corrida não deve sobrepor outros visuais.")
	var quadro_antes_pausa: int = personagem.get_node("CorridaCristiano")._quadro
	paused = true
	await _aguardar_quadros(12)
	_exigir(personagem.get_node("CorridaCristiano")._quadro == quadro_antes_pausa, "Pausa deve congelar o ciclo de corrida.")
	paused = false
	Input.action_release("ir_para_direita")
	Input.action_press("ir_para_esquerda")
	await _aguardar_quadros(4)
	_exigir(personagem.get_node("CorridaCristiano").scale.x < 0.0, "Esquerda deve inverter a corrida.")
	Input.action_release("ir_para_esquerda")
	await _aguardar_quadros(3)
	_exigir(personagem.get_node("EsperaCristiano").visible and not personagem.get_node("CorridaCristiano").visible, "Soltar direção deve retornar à espera.")
	Input.action_press("pular")
	await _aguardar_quadros(4)
	_exigir(not personagem.get_node("CorridaCristiano").visible and personagem.get_node("SaltoCristiano").visible and not personagem.get_node("Sprite2D").visible, "Pulo deve usar o salto aprovado sem corrida sobreposta.")
	Input.action_release("pular")
	await _aguardar_quadros(90)
	Input.action_press("chutar")
	await _aguardar_quadros(3)
	_exigir(not personagem.get_node("CorridaCristiano").visible and personagem.get_node("ChuteCristiano").visible and not personagem.get_node("Sprite2D").visible, "Chute deve usar a arte aprovada sem corrida sobreposta.")
	Input.action_release("chutar")
	await _aguardar_quadros(50)
	Input.action_press("carrinho")
	await _aguardar_quadros(3)
	_exigir(not personagem.get_node("CorridaCristiano").visible and personagem.get_node("CarrinhoCristiano").visible and not personagem.get_node("Sprite2D").visible, "Carrinho deve usar o visual aprovado sem corrida sobreposta.")
	Input.action_release("carrinho")
	await _aguardar_quadros(40)
	Input.action_press("ir_para_direita")
	await _aguardar_quadros(4)
	personagem.receber_dano()
	_exigir(not personagem.get_node("CorridaCristiano").visible, "Dano deve interromper corrida visual.")
	Input.action_release("ir_para_direita")
	_exigir(personagem.get_node("CollisionShape2D").shape.size == Vector2(43, 118.5), "Colisão original deve ser preservada.")
	root.get_node("ScriptGlobal").personagem = null
	for filho in personagem.get_children():
		if filho is AudioStreamPlayer:
			filho.stop()
			filho.stream = null
	await create_timer(0.1).timeout
	cena.queue_free()
	piso.queue_free()
	await process_frame
	print("Verificação da corrida: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
