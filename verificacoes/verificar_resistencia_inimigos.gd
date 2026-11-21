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

func _inimigo(arquivo: String, posicao: Vector2, vida: int = 0) -> Node2D:
	var cena = load(arquivo).instantiate()
	cena.position = posicao
	var corpo = cena.get_node("Chefao" if arquivo.contains("chefao") else "CharacterBody2D")
	corpo.set_process(false)
	corpo.get_node("AnimationPlayer").autoplay = &""
	if corpo.has_node("Timer"):
		corpo.get_node("Timer").autostart = false
	if vida > 0:
		corpo.get_node("Resistencia").vida_maxima = vida
	root.add_child(cena)
	corpo.set_process(false)
	return cena

func _atirar(alvo: Node2D) -> void:
	var bola = load("res://cena_bola.tscn").instantiate()
	bola.position = alvo.global_position - Vector2(50, 3)
	root.add_child(bola)
	await _aguardar(6)

func _executar() -> void:
	var comum = _inimigo("res://cena_inimigo1.tscn", Vector2(600, 300))
	var corpo_comum = comum.get_node("CharacterBody2D")
	var vida_comum = corpo_comum.get_node("Resistencia")
	_exigir(vida_comum.vida_atual == 1, "Inimigo comum deve manter resistência inicial de um acerto.")
	corpo_comum.receber_dano(0)
	_exigir(vida_comum.vida_atual == 1, "Dano zero não deve alterar vida.")
	corpo_comum.receber_dano(1)
	_exigir(vida_comum.vida_atual == 0 and vida_comum.derrotado, "Dano fatal deve marcar derrota uma vez.")
	corpo_comum.receber_dano(1)
	_exigir(vida_comum.vida_atual == 0, "Acertos repetidos após derrota não devem negativar vida.")
	await _aguardar(2)
	_exigir(not is_instance_valid(corpo_comum), "Inimigo comum deve ser removido após um acerto.")
	var som_persistiu: bool = false
	for filho in comum.get_children():
		if filho is AudioStreamPlayer:
			som_persistiu = filho.stream != null
	_exigir(som_persistiu, "Som de dano deve sobreviver à remoção do corpo.")

	var resistente = _inimigo("res://cena_inimigo2.tscn", Vector2(800, 300), 3)
	var corpo = resistente.get_node("CharacterBody2D")
	var vida = corpo.get_node("Resistencia")
	await _atirar(corpo)
	_exigir(is_instance_valid(corpo) and vida.vida_atual == 2, "Bola deve causar um dano sem eliminar alvo resistente.")
	await _aguardar(10)
	_exigir(corpo.get_node("Sprite2D").modulate == Color.WHITE, "Clarão de dano deve restaurar a cor original.")
	var jogador = load("res://cena_jogador.tscn").instantiate()
	root.add_child(jogador)
	var personagem = jogador.get_node("Personagem")
	personagem.set_process(false)
	personagem.get_node("AnimationPlayer").play("carrinho")
	personagem._alvos_carrinho.clear()
	personagem.eliminar_inimigo(corpo)
	personagem.eliminar_inimigo(corpo)
	_exigir(vida.vida_atual == 1, "Mesmo carrinho não deve descontar duas vidas do mesmo inimigo.")
	personagem.get_node("AnimationPlayer").stop()
	await _atirar(corpo)
	_exigir(not is_instance_valid(corpo), "Alvo de três vidas deve exigir três ataques distintos.")

	var portao = load("res://cena_portao.tscn").instantiate()
	root.add_child(portao)
	var chefao_cena = _inimigo("res://cena_chefao.tscn", Vector2(1200, 300))
	var chefao = chefao_cena.get_node("Chefao")
	var vida_chefe = chefao.get_node("Resistencia")
	_exigir(vida_chefe.vida_atual == 6, "Chefão deve começar com seis vidas configuráveis.")
	for i in range(5):
		await _atirar(chefao)
		_exigir(is_instance_valid(chefao) and vida_chefe.vida_atual == 5 - i, "Chefão deve resistir aos primeiros cinco acertos.")
		_exigir(not portao.get_node("AnimationPlayer").is_playing(), "Portão não deve abrir antes da derrota do chefão.")
	await _atirar(chefao)
	_exigir(not portao.get_node("AnimationPlayer").is_playing(), "Portão deve aguardar o colapso visual do chefe.")
	await _aguardar(230)
	_exigir(not is_instance_valid(chefao) and portao.get_node("AnimationPlayer").is_playing(), "Último acerto deve derrotar chefão e abrir portão.")
	root.get_node("ScriptGlobal").personagem = null
	root.get_node("ScriptGlobal").portao = null
	comum.queue_free()
	resistente.queue_free()
	jogador.queue_free()
	portao.queue_free()
	chefao_cena.queue_free()
	await process_frame
	print("Verificação de resistência: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
