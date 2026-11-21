extends SceneTree

var falhas: int = 0

func _initialize() -> void:
	call_deferred("_executar")

func _exigir(condicao: bool, mensagem: String) -> void:
	if not condicao:
		falhas += 1
		push_error(mensagem)

func _aguardar(quantidade: int) -> void:
	for i in range(quantidade):
		await process_frame

func _corpo(posicao: Vector2, tamanho: Vector2, camada: int) -> StaticBody2D:
	var corpo := StaticBody2D.new()
	corpo.position = posicao
	corpo.collision_layer = camada
	corpo.collision_mask = 0
	var colisao := CollisionShape2D.new()
	var forma := RectangleShape2D.new()
	forma.size = tamanho
	colisao.shape = forma
	corpo.add_child(colisao)
	root.add_child(corpo)
	return corpo

func _bolas(pai: Node) -> Array:
	var resultado: Array = []
	for filho in pai.get_children():
		if filho.has_node("CharacterBody2D"):
			resultado.append(filho)
	return resultado

func _executar() -> void:
	var piso = _corpo(Vector2(500, 400), Vector2(2000, 40), 1)
	var cena = load("res://cena_jogador.tscn").instantiate()
	cena.position = Vector2.ZERO
	root.add_child(cena)
	var personagem = cena.get_node("Personagem")
	personagem.position = Vector2(300, 300)
	await _aguardar(30)
	var alvo_direita = _corpo(personagem.global_position + Vector2(220, 40), Vector2(16, 80), 4)
	Input.action_press("chutar")
	await _aguardar(3)
	Input.action_release("chutar")
	_exigir(personagem.get_node("ChuteCristiano").visible and not personagem.get_node("Sprite2D").visible, "Chute deve usar a nova arte, sem sprite antigo sobreposto.")
	_exigir(_bolas(cena).is_empty(), "Preparação não deve disparar a bola.")
	var tempo_antes: float = personagem.get_node("AnimationPlayer").current_animation_position
	paused = true
	await _aguardar(12)
	_exigir(personagem.get_node("AnimationPlayer").current_animation_position == tempo_antes and _bolas(cena).is_empty(), "Pausa deve congelar o chute antes do contato.")
	paused = false
	await _aguardar(14)
	_exigir(_bolas(cena).is_empty(), "Bola não deve sair antes de 340 ms.")
	await _aguardar(9)
	var bolas = _bolas(cena)
	_exigir(bolas.size() == 1, "Contato deve gerar exatamente uma bola.")
	if bolas.size() == 1:
		var bola = bolas[0].get_node("CharacterBody2D")
		_exigir(bola.direcao == 1 and bola.get_node("RayCast2D").target_position.x > 0, "Bola e detecção devem seguir para a direita.")
		_exigir(bola.velocidade == 350 and bola.get_node("Sprite2D").rotation != 0.0 and bola.has_node("Energia"), "Projétil deve manter velocidade e ganhar rotação e efeito.")
		var posicao_antes: Vector2 = bola.global_position
		var efeito_antes: float = bola.get_node("Energia")._tempo
		paused = true
		await _aguardar(8)
		_exigir(bola.global_position == posicao_antes and bola.get_node("Energia")._tempo == efeito_antes, "Pausa deve congelar bola e energia.")
		paused = false
	personagem.spawnar_bolar()
	_exigir(_bolas(cena).size() == 1, "Chamadas duplicadas no mesmo chute não devem criar mais bolas.")
	await _aguardar(30)
	_exigir(not is_instance_valid(alvo_direita) and _bolas(cena).is_empty(), "Acerto deve eliminar o inimigo e a bola como antes.")
	var encontrou_impacto: bool = false
	for filho in cena.get_children():
		if filho.get_script() == load("res://script_energia_bola.gd"):
			encontrou_impacto = encontrou_impacto or filho.impacto
	_exigir(encontrou_impacto, "Acerto deve criar efeito de impacto independente da bola.")

	Input.action_press("ir_para_esquerda")
	await _aguardar(2)
	Input.action_release("ir_para_esquerda")
	var alvo_esquerda = _corpo(personagem.global_position + Vector2(-220, 40), Vector2(16, 80), 4)
	Input.action_press("chutar")
	await _aguardar(3)
	Input.action_release("chutar")
	Input.action_press("ir_para_direita")
	await _aguardar(2)
	Input.action_release("ir_para_direita")
	await _aguardar(22)
	bolas = _bolas(cena)
	_exigir(bolas.size() == 1 and personagem.get_node("ChuteCristiano").scale.x < 0, "Chute deve manter a direção capturada no início.")
	if bolas.size() == 1:
		var bola = bolas[0].get_node("CharacterBody2D")
		_exigir(bola.direcao == -1 and bola.get_node("RayCast2D").target_position.x < 0 and bola.get_node("Energia").direcao == -1, "Bola, RayCast e rastro devem acompanhar a esquerda.")
	await _aguardar(30)
	_exigir(not is_instance_valid(alvo_esquerda), "Disparo à esquerda deve acertar inimigo.")

	Input.action_press("chutar")
	await _aguardar(3)
	Input.action_release("chutar")
	personagem.receber_dano()
	await _aguardar(35)
	_exigir(_bolas(cena).is_empty() and not personagem.get_node("ChuteCristiano").visible, "Dano antes do contato deve cancelar chute sem disparo atrasado.")
	Input.action_press("chutar")
	await _aguardar(3)
	Input.action_release("chutar")
	Input.action_press("pular")
	await _aguardar(3)
	Input.action_release("pular")
	await _aguardar(45)
	_exigir(_bolas(cena).is_empty(), "Pulo antes do contato deve cancelar o disparo.")

	var portao = load("res://cena_portao.tscn").instantiate()
	portao.position = Vector2(1400, 100)
	root.add_child(portao)
	var chefao = _corpo(Vector2(1040, 103), Vector2(16, 80), 4)
	chefao.name = "Chefao"
	var bola_chefe = load("res://cena_bola.tscn").instantiate()
	bola_chefe.position = Vector2(1000, 100)
	root.add_child(bola_chefe)
	await _aguardar(12)
	_exigir(not is_instance_valid(chefao), "Bola deve preservar eliminação do chefão.")
	# Este alvo estático exercita o fallback legado, sem Resistencia/animação.
	_exigir(portao.get_node("AnimationPlayer").is_playing(), "Derrota do chefão deve preservar abertura do portão.")
	var perdida = load("res://cena_bola.tscn").instantiate()
	perdida.position = Vector2(700, 100)
	perdida.get_node("CharacterBody2D")._tempo_vida = 5.99
	root.add_child(perdida)
	await _aguardar(3)
	_exigir(not is_instance_valid(perdida), "Bolas perdidas devem ser removidas após seis segundos.")
	_exigir(personagem.get_node("CollisionShape2D").shape.size == Vector2(43, 118.5), "Colisão física do jogador deve permanecer intacta.")
	root.get_node("ScriptGlobal").personagem = null
	root.get_node("ScriptGlobal").portao = null
	for filho in personagem.get_children():
		if filho is AudioStreamPlayer:
			filho.stop()
			filho.stream = null
	if is_instance_valid(alvo_direita):
		alvo_direita.queue_free()
	if is_instance_valid(alvo_esquerda):
		alvo_esquerda.queue_free()
	if is_instance_valid(chefao):
		chefao.queue_free()
	cena.queue_free()
	piso.queue_free()
	portao.queue_free()
	await process_frame
	print("Verificação do chute: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
