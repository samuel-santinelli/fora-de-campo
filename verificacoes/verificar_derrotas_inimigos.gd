extends SceneTree
var falhas: int = 0
func _initialize() -> void:
	call_deferred("_executar")
func _exigir(ok: bool, mensagem: String) -> void:
	if not ok:
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
	await _aguardar(2)
	var casos = [
		["Inimigo2/CharacterBody2D", "muralha"], ["Inimigo1/CharacterBody2D", "sentenca"],
		["Neymar/CharacterBody2D", "neymar"], ["Mbappe/CharacterBody2D", "mbappe"],
		["Haaland/CharacterBody2D", "haaland"], ["Impedimento/CharacterBody2D", "impedimento"],
		["Chefao/Chefao", "var-01"]]
	for caso in casos:
		fase.get_node(caso[0]).set_process(false)
	for caso in casos:
		var corpo = fase.get_node(caso[0])
		corpo.set_process(false)
		corpo.receber_dano(99)
		var efeitos = get_nodes_in_group("derrotas_inimigos")
		var efeito = efeitos.back()
		_exigir(efeito.identidade == caso[1], "Cada rival precisa de sua própria derrota: " + caso[1])
		var textura: Texture2D = efeito.FOLHAS[caso[1]]
		_exigir(textura.get_size() == Vector2(1536,1024), "Folha deve ter seis células de 512: " + caso[1])
		var imagem: Image = textura.get_image()
		_exigir(imagem.get_pixel(0,0).a < 0.03, "Fundo deve ser transparente: " + caso[1])
		_exigir(efeito.get_children().filter(func(n): return n is CollisionObject2D).is_empty(), "Derrota não deve causar colisão/dano.")
		await _aguardar(2)
		_exigir(not is_instance_valid(corpo), "Corpo de combate deve sair após golpe fatal.")
		await _aguardar(34 if caso[1] == "var-01" else 16)
		_exigir(efeito.quadro > 0, "A derrota precisa avançar de pose.")
		var antes: float = efeito.tempo
		paused = true
		await _aguardar(12)
		_exigir(is_equal_approx(efeito.tempo, antes), "Pausa deve congelar a derrota.")
		paused = false
		if caso[1] == "var-01":
			_exigir(efeito.duracao >= 3.5, "Chefe deve ter colapso mais longo.")
			_exigir(fase.get_node("Portao/Area2D/CollisionShape2D").disabled, "Portão deve esperar a sequência final.")
		await _aguardar(260 if caso[1] == "var-01" else 120)
		_exigir(not is_instance_valid(efeito), "Derrota deve terminar e liberar recursos.")
	_exigir(not fase.get_node("Portao/Area2D/CollisionShape2D").disabled, "Colapso concluído deve liberar chegada ao estádio.")
	for nome in ["AudioStreamPlayerCarrinho", "AudioStreamPlayerChutandoBola", "AudioStreamPlayerDano", "AudioStreamPlayerPulando"]:
		var audio = global.personagem.get_node(nome)
		_exigir(audio.stream.resource_path.begins_with("res://Sons/Identidade/"), "Jogador deve usar efeitos próprios: " + nome)
	global.personagem = null
	global.portao = null
	fase.queue_free()
	await _aguardar(2)
	_exigir(get_nodes_in_group("derrotas_inimigos").is_empty(), "Troca de cena deve limpar derrotas.")
	# Cancelar uma sequência em andamento não pode liberar outro portão depois.
	var portao = load("res://cena_portao.tscn").instantiate()
	root.add_child(portao)
	var chefe = load("res://cena_chefao.tscn").instantiate()
	root.add_child(chefe)
	chefe.get_node("Chefao").set_process(false)
	chefe.get_node("Chefao").receber_dano(99)
	await _aguardar(2)
	chefe.queue_free()
	await _aguardar(250)
	_exigir(not portao.get_node("AnimationPlayer").is_playing() and portao.get_node("Area2D/CollisionShape2D").disabled, "Cancelamento não deve abrir portão por callback atrasado.")
	portao.queue_free()
	global.portao = null
	await _aguardar(2)
	print("Verificação de derrotas: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
