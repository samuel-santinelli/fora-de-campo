extends SceneTree

var falhas: int = 0
var BASE = null

func _initialize() -> void:
	call_deferred("_executar")

func _exigir(condicao: bool, mensagem: String) -> void:
	if not condicao:
		falhas += 1
		push_error(mensagem)

func _aguardar(quantidade: int) -> void:
	for i in range(quantidade):
		await process_frame

func _esperar_estado(inimigo: Node, estado: int, limite: int = 180) -> bool:
	for i in range(limite):
		if inimigo._estado == estado:
			return true
		await process_frame
	return false

func _piso(pai: Node, posicao: Vector2, tamanho: Vector2) -> void:
	var corpo := StaticBody2D.new()
	corpo.position = posicao
	var forma := RectangleShape2D.new()
	forma.size = tamanho
	var colisao := CollisionShape2D.new()
	colisao.shape = forma
	corpo.add_child(colisao)
	pai.add_child(corpo)

func _executar() -> void:
	BASE = load("res://script_mbappe.gd")
	var global = root.get_node("ScriptGlobal")
	global.resetar_variaveis()
	var fase := Node2D.new()
	fase.name = "Fase"
	root.add_child(fase)
	_piso(fase, Vector2(1000, 400), Vector2(4000, 40))
	var jogador = load("res://cena_jogador.tscn").instantiate()
	jogador.position = Vector2.ZERO
	fase.add_child(jogador)
	var personagem = jogador.get_node("Personagem")
	personagem.set_process(false)
	personagem.position = Vector2(900, 323)
	var cena = load("res://cena_impedimento.tscn").instantiate()
	cena.position = Vector2(500, 319)
	fase.add_child(cena)
	var inimigo = cena.get_node("CharacterBody2D")
	await _aguardar(20)
	_exigir(inimigo.is_on_floor() and is_zero_approx(inimigo.velocity.x), "Guardião deve aguardar ativação no chão.")
	_exigir(inimigo.get_script().get_base_script().resource_path == "res://script_mbappe.gd", "Reutilizar ciclo do Mbappé.")
	_exigir(inimigo.get_node("Resistencia").vida_atual == 5, "Guardião deve ter cinco vidas.")
	inimigo.perseguir()
	await _aguardar(3)
	_exigir(inimigo.velocity.x == 170.0 and inimigo.get_node("Sprite2D").scale.x == -0.5, "Aproximação deve apontar para jogador com escala correta.")
	_exigir(await _esperar_estado(inimigo, BASE.Estado.AVISANDO), "Deve avisar antes de investir.")
	await _aguardar(2)
	var vidas: int = global.qtd_vidas
	inimigo.causar_dano_personagem(personagem)
	await _aguardar(2)
	_exigir(global.qtd_vidas == vidas and not inimigo.get_node("Area2D").monitoring, "Aviso não deve causar contato.")
	var direcao: int = inimigo._direcao_arrancada
	personagem.position.x = inimigo.global_position.x - 250
	var posicao: Vector2 = inimigo.position
	var tempo: float = inimigo._tempo_estado
	paused = true
	await _aguardar(20)
	_exigir(inimigo.position == posicao and inimigo._tempo_estado == tempo, "Pausa deve congelar aviso e posição.")
	paused = false
	_exigir(await _esperar_estado(inimigo, BASE.Estado.ARRANCANDO), "Primeiro ciclo deve investir.")
	_exigir(absf(inimigo.velocity.x) == 560.0 and inimigo.direcao_inimigo2 == direcao, "Investida deve manter direção capturada.")
	_exigir(get_nodes_in_group("sinalizadores_impedimento").is_empty(), "Investida não deve disparar sinalizador junto.")
	_exigir(await _esperar_estado(inimigo, BASE.Estado.RECUPERANDO), "Investida deve terminar em recuperação.")
	await _aguardar(2)
	_exigir(is_zero_approx(inimigo.velocity.x) and not inimigo.get_node("Area2D").monitoring, "Recuperação deve ficar parada e segura.")
	personagem.position.x = inimigo.global_position.x - 350
	_exigir(await _esperar_estado(inimigo, BASE.Estado.AVISANDO), "Segundo ciclo deve avisar sinalizador.")
	_exigir(inimigo._ataque_sinalizador, "Alternar ataques previsivelmente.")
	for i in range(65):
		if not get_nodes_in_group("sinalizadores_impedimento").is_empty():
			break
		await process_frame
	var sinais = get_nodes_in_group("sinalizadores_impedimento")
	_exigir(sinais.size() == 1 and inimigo._estado == BASE.Estado.RECUPERANDO, "Sinalizador deve disparar uma vez e abrir recuperação sem investida.")
	if sinais.size() == 1:
		var sinal = sinais[0].get_node("CharacterBody2D")
		_exigir(sinal.velocidade == 420 and not sinal.get_node("Sprite2D").visible, "Sinalizador deve ter velocidade própria e visual amarelo em vez de bola.")
		var pos_sinal: Vector2 = sinal.position
		paused = true
		await _aguardar(10)
		_exigir(sinal.position == pos_sinal, "Pausa deve congelar sinalizador.")
		paused = false
		await _aguardar(55)
		_exigir(not is_instance_valid(sinal) and global.qtd_vidas == vidas - 1, "Sinalizador deve atingir jogador uma única vez e sumir.")
	# Voltar a avisar e cancelar o ataque com dano.
	personagem.position.x = inimigo.global_position.x - 300
	_exigir(await _esperar_estado(inimigo, BASE.Estado.AVISANDO), "Deve retomar aviso.")
	inimigo.receber_dano(1)
	_exigir(inimigo.get_node("Resistencia").vida_atual == 4 and inimigo._estado == BASE.Estado.RECUPERANDO, "Dano deve interromper ataque e tirar só uma vida.")
	inimigo.encerrar_perseguicao()
	await _aguardar(4)
	_exigir(is_zero_approx(inimigo.velocity.x), "Sair da tela deve interromper perseguição.")
	inimigo.perseguir()
	personagem.position.x = 2500
	await _aguardar(3)
	_exigir(is_zero_approx(inimigo.velocity.x) and not inimigo.get_node("Area2D").monitoring, "Fora do alcance não deve atacar.")
	global.qtd_vidas = 0
	await _aguardar(3)
	_exigir(is_zero_approx(inimigo.velocity.x), "Jogador derrotado deve interromper guardião.")
	global.resetar_variaveis()
	global.personagem = null
	await _aguardar(3)
	_exigir(is_zero_approx(inimigo.velocity.x), "Jogador ausente deve ser tratado sem erro.")
	global.personagem = personagem
	inimigo.encerrar_perseguicao()
	inimigo.set_process(false)
	personagem.get_node("AnimationPlayer").play("carrinho")
	personagem._alvos_carrinho.clear()
	personagem.eliminar_inimigo(inimigo)
	personagem.eliminar_inimigo(inimigo)
	_exigir(inimigo.get_node("Resistencia").vida_atual == 3, "Mesmo carrinho não deve descontar vida duas vezes.")
	personagem.get_node("AnimationPlayer").stop()
	for i in range(3):
		var bola = load("res://cena_bola.tscn").instantiate()
		bola.position = inimigo.global_position - Vector2(70, 3)
		fase.add_child(bola)
		await _aguardar(20)
	_exigir(not is_instance_valid(inimigo), "Cinco ataques distintos devem derrotar guardião.")
	# Reusar colisão e expiração do sinalizador em parede.
	_piso(fase, Vector2(1500, 300), Vector2(20, 180))
	var contra_parede = load("res://cena_sinalizador_impedimento.tscn").instantiate()
	fase.add_child(contra_parede)
	contra_parede.global_position = Vector2(1430, 340)
	await _aguardar(20)
	_exigir(not is_instance_valid(contra_parede), "Sinalizador deve desaparecer em parede.")
	fase.queue_free()
	await _aguardar(2)
	global.resetar_variaveis()
	var fase_real = load("res://cena_fase.tscn").instantiate()
	fase_real.get_node("HUD").apresentar_rivais = false
	root.add_child(fase_real)
	await _aguardar(30)
	var guardiao = fase_real.get_node("Impedimento/CharacterBody2D")
	var chefe = fase_real.get_node("Chefao/Chefao")
	var portao = fase_real.get_node("Portao/AnimationPlayer")
	_exigir(guardiao.is_on_floor(), "Guardião deve começar apoiado no terreno real.")
	_exigir(fase_real.get_node("Chefao").process_mode == Node.PROCESS_MODE_DISABLED and chefe.collision_layer == 0, "Chefe deve aguardar sem ataques nem receber tiros durante guardião.")
	for caminho in ["Neymar/CharacterBody2D", "Mbappe/CharacterBody2D", "Haaland/CharacterBody2D", "Inimigo1/CharacterBody2D", "Inimigo2/CharacterBody2D"]:
		_exigir(fase_real.has_node(caminho), "Preservar inimigos anteriores: " + caminho)
	for i in range(4):
		guardiao.receber_dano(1)
	_exigir(fase_real.get_node("Chefao").process_mode == Node.PROCESS_MODE_DISABLED and not portao.is_playing(), "Quatro acertos não devem liberar chefe nem portão.")
	guardiao.receber_dano(1)
	await _aguardar(2)
	_exigir(not is_instance_valid(guardiao) and fase_real.get_node("Chefao").process_mode != Node.PROCESS_MODE_DISABLED and chefe.collision_layer == 4, "Derrota do guardião deve restaurar chefe.")
	_exigir(chefe.get_node("Resistencia").vida_atual == 6 and not portao.is_playing(), "Guardião derrotado não deve abrir portão nem tirar vidas do chefe.")
	chefe.receber_dano(6)
	await _aguardar(230)
	_exigir(portao.is_playing(), "Portão deve abrir apenas após derrotar chefe.")
	global.personagem = null
	global.portao = null
	fase_real.queue_free()
	await process_frame
	print("Verificação do Impedimento: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
