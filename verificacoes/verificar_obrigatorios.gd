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
	var fase := Node2D.new()
	fase.name = "Fase"
	root.add_child(fase)
	var piso := StaticBody2D.new()
	piso.position = Vector2(1000, 400)
	var forma := RectangleShape2D.new()
	forma.size = Vector2(4000, 40)
	var colisao := CollisionShape2D.new()
	colisao.shape = forma
	piso.add_child(colisao)
	fase.add_child(piso)
	var jogador = load("res://cena_jogador.tscn").instantiate()
	jogador.position = Vector2.ZERO
	fase.add_child(jogador)
	var personagem = jogador.get_node("Personagem")
	personagem.set_process(false)
	personagem.position = Vector2(640, 323)
	var cena = load("res://cena_muralha.tscn").instantiate()
	cena.position = Vector2(500, 319)
	fase.add_child(cena)
	var goleiro = cena.get_node("CharacterBody2D")
	await _aguardar(20)
	_exigir(goleiro.is_on_floor() and goleiro.forcao_pulo == 250 and goleiro.velocidade == 0, "Goleiro deve preservar força de salto e aguardar ativação.")
	goleiro.perseguir()
	var saltou: bool = false
	for i in range(12):
		await process_frame
		if goleiro.velocity.y < 0:
			saltou = true
			break
	_exigir(saltou and goleiro.get_node("Sprite2D").texture == goleiro.SALTO, "Goleiro deve saltar de verdade ao perseguir, usando nova folha.")
	var posicao: Vector2 = goleiro.position
	var quadro: Rect2 = goleiro.get_node("Sprite2D").region_rect
	paused = true
	await _aguardar(10)
	_exigir(goleiro.position == posicao and goleiro.get_node("Sprite2D").region_rect == quadro, "Pausa deve congelar goleiro e visual.")
	paused = false
	goleiro.encerrar_perseguicao()
	await _aguardar(3)
	_exigir(is_zero_approx(goleiro.velocity.x), "Goleiro deve parar fora da tela.")
	cena.queue_free()
	await _aguardar(2)
	personagem.position = Vector2(900, 323)
	var cena_arbitro = load("res://cena_sentenca.tscn").instantiate()
	cena_arbitro.position = Vector2(600, 319)
	fase.add_child(cena_arbitro)
	var arbitro = cena_arbitro.get_node("CharacterBody2D")
	var observados: Dictionary = {}
	var cores: Array = []
	var vidas: int = global.qtd_vidas
	for i in range(180):
		await process_frame
		for cartao in get_nodes_in_group("cartoes_sentenca"):
			if not observados.has(cartao.get_instance_id()):
				observados[cartao.get_instance_id()] = true
				cores.append(cartao.get_node("CharacterBody2D").vermelho)
	_exigir(cores.size() >= 2 and cores[0] == false and cores[1] == true, "Arbitragem deve lançar cartões amarelo e vermelho alternados.")
	_exigir(global.qtd_vidas <= vidas - 2, "Ambas as cores devem atingir jogador pelo projétil existente.")
	_exigir(arbitro.get_node("Sprite2D").texture == arbitro.FOLHA, "Arbitragem deve usar novo visual.")
	var tempo: float = arbitro._tempo
	paused = true
	await _aguardar(10)
	_exigir(arbitro._tempo == tempo, "Pausa deve congelar lançamento.")
	paused = false
	global.personagem = null
	await _aguardar(3)
	_exigir(arbitro._tempo == 0, "Jogador ausente deve cancelar lançamento.")
	fase.queue_free()
	await _aguardar(2)
	global.resetar_variaveis()
	var real = load("res://cena_fase.tscn").instantiate()
	real.get_node("HUD").apresentar_rivais = false
	root.add_child(real)
	await _aguardar(25)
	_exigir(real.get_node("Inimigo1/CharacterBody2D").get_script().resource_path == "res://script_sentenca.gd", "Fase deve usar Sentença no lugar da arte antiga.")
	_exigir(real.get_node("Inimigo2/CharacterBody2D").get_script().resource_path == "res://script_muralha.gd", "Fase deve usar Muralha no lugar da arte antiga.")
	_exigir(real.get_node("Inimigo1/CharacterBody2D").is_on_floor() and real.get_node("Inimigo2/CharacterBody2D").is_on_floor(), "Novos visuais devem preservar apoio no terreno.")
	global.personagem = null
	global.portao = null
	real.queue_free()
	await process_frame
	print("Verificação dos obrigatórios: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
