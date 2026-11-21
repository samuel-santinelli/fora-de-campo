extends SceneTree

var falhas: int = 0
var NEYMAR = null

func _initialize() -> void:
	call_deferred("_executar")

func _exigir(condicao: bool, mensagem: String) -> void:
	if not condicao:
		falhas += 1
		push_error(mensagem)

func _aguardar(quantidade: int) -> void:
	for i in range(quantidade):
		await process_frame

func _esperar_estado(inimigo: Node, estado: int, limite: int = 100) -> bool:
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

func _limpar_bolas() -> void:
	for bola in get_nodes_in_group("bolas_neymar"):
		bola.queue_free()
	await _aguardar(2)

func _nova_bola(pai: Node, posicao: Vector2, direcao: int = 1) -> Node2D:
	var bola = load("res://cena_bola_neymar.tscn").instantiate()
	bola.get_node("CharacterBody2D").direcao = direcao
	pai.add_child(bola)
	bola.global_position = posicao
	return bola

func _executar() -> void:
	NEYMAR = load("res://script_neymar.gd")
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
	personagem.position = Vector2(950, 323)
	var cena = load("res://cena_neymar.tscn").instantiate()
	cena.position = Vector2(500, 319)
	fase.add_child(cena)
	var inimigo = cena.get_node("CharacterBody2D")
	await _aguardar(20)
	_exigir(inimigo.is_on_floor() and is_zero_approx(inimigo.velocity.x), "Neymar deve aguardar ativação no chão.")
	_exigir(inimigo.get_script().get_base_script().resource_path == "res://script_inimigo2.gd", "Reutilizar base do perseguidor.")
	_exigir(inimigo.get_node("Resistencia").vida_atual == 3, "Neymar deve ter três vidas.")
	inimigo.get_node("VisibleOnScreenNotifier2D").emit_signal("screen_entered")
	await _aguardar(3)
	_exigir(inimigo.velocity.x == 260.0 and inimigo.get_node("Sprite2D").scale.x == -0.5, "Aproximação deve apontar ao jogador e espelhar arte.")
	var vidas_contato: int = global.qtd_vidas
	personagem.global_position = inimigo.global_position + Vector2(43, 4)
	await _aguardar(3)
	_exigir(global.qtd_vidas == vidas_contato - 1, "Contato físico real deve aplicar um dano sem alterar colisões durante queries.")
	personagem.position = Vector2(950, 323)
	_exigir(await _esperar_estado(inimigo, NEYMAR.Estado.FINTANDO), "Aproximação deve entrar na finta.")
	await _aguardar(2)
	var vidas: int = global.qtd_vidas
	inimigo.causar_dano_personagem(personagem)
	_exigir(global.qtd_vidas == vidas and not inimigo.get_node("Area2D").monitoring, "Finta deve desativar dano de contato.")
	var direcao: int = inimigo._direcao_finta
	personagem.position.x = inimigo.global_position.x - 300
	await _aguardar(29)
	_exigir(inimigo._estado == NEYMAR.Estado.FINTANDO and inimigo.velocity.x * direcao < 0, "Finta deve recuar sem virar automaticamente para novo lado.")
	_exigir(inimigo.get_node("Sprite2D").texture == NEYMAR.FINTA and not inimigo._disparou and get_nodes_in_group("bolas_neymar").is_empty(), "Finta deve ter poses próprias e aviso antes da bola.")
	var posicao: Vector2 = inimigo.position
	var tempo: float = inimigo._tempo_estado
	var quadro: int = inimigo._quadro
	paused = true
	await _aguardar(20)
	_exigir(inimigo.position == posicao and inimigo._tempo_estado == tempo and inimigo._quadro == quadro, "Pausa deve congelar ciclo e animação.")
	paused = false
	for i in range(25):
		if not get_nodes_in_group("bolas_neymar").is_empty():
			break
		await process_frame
	var bolas = get_nodes_in_group("bolas_neymar")
	_exigir(bolas.size() == 1, "Um ciclo deve disparar exatamente uma bola.")
	if bolas.size() == 1:
		var corpo_bola = bolas[0].get_node("CharacterBody2D")
		_exigir(corpo_bola.direcao == direcao and corpo_bola.get_script().get_base_script().resource_path == "res://script_cartao.gd", "Chute deve manter direção avisada e base do cartão.")
		var bola_posicao: Vector2 = corpo_bola.position
		paused = true
		await _aguardar(12)
		_exigir(corpo_bola.position == bola_posicao and corpo_bola._tempo_vida == 0.0, "Pausa deve congelar bola recém-criada e duração.")
		paused = false
	_exigir(await _esperar_estado(inimigo, NEYMAR.Estado.RECUPERANDO, 30), "Chute deve terminar em recuperação.")
	await _aguardar(2)
	vidas = global.qtd_vidas
	inimigo.causar_dano_personagem(personagem)
	_exigir(is_zero_approx(inimigo.velocity.x) and global.qtd_vidas == vidas, "Recuperação deve parar sem dano de contato.")
	await _limpar_bolas()
	_exigir(await _esperar_estado(inimigo, NEYMAR.Estado.FINTANDO, 150), "Deve voltar a fintar após recuperação.")
	inimigo.receber_dano(0)
	_exigir(inimigo._estado == NEYMAR.Estado.FINTANDO, "Dano zero não deve cancelar finta.")
	inimigo.receber_dano(1)
	_exigir(inimigo._estado == NEYMAR.Estado.RECUPERANDO and inimigo.get_node("Resistencia").vida_atual == 2, "Acerto deve interromper o chute ainda não disparado.")
	await _aguardar(30)
	_exigir(get_nodes_in_group("bolas_neymar").is_empty(), "Chute cancelado não deve gerar bola atrasada.")
	personagem.position.x = 2500
	await _aguardar(3)
	_exigir(is_zero_approx(inimigo.velocity.x) and not inimigo.get_node("Area2D").monitoring, "Fora do alcance deve interromper ataque e contato.")
	personagem.position.x = inimigo.global_position.x + 300
	inimigo.encerrar_perseguicao()
	await _aguardar(3)
	_exigir(is_zero_approx(inimigo.velocity.x), "Sair da tela deve parar Neymar.")
	inimigo.perseguir()
	global.qtd_vidas = 0
	await _aguardar(3)
	_exigir(is_zero_approx(inimigo.velocity.x) and not inimigo.get_node("Area2D").monitoring, "Jogador derrotado deve interromper Neymar.")
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
	_exigir(inimigo.get_node("Resistencia").vida_atual == 1, "Carrinho deve aplicar um único dano por ataque.")
	personagem.get_node("AnimationPlayer").stop()
	var bola_player = load("res://cena_bola.tscn").instantiate()
	bola_player.position = inimigo.global_position - Vector2(70, 3)
	fase.add_child(bola_player)
	await _aguardar(20)
	_exigir(not is_instance_valid(inimigo), "Terceiro ataque distinto deve derrotar Neymar.")

	# Projétil real deve atingir o jogador em ambos os sentidos e uma só vez.
	personagem.position = Vector2(1100, 323)
	for sentido in [1, -1]:
		vidas = global.qtd_vidas
		var bola = _nova_bola(fase, personagem.global_position + Vector2(-100 * sentido, 20), sentido)
		await _aguardar(30)
		_exigir(global.qtd_vidas == vidas - 1 and not is_instance_valid(bola), "Bola inimiga deve causar um dano e sumir em ambos os sentidos.")
	_piso(fase, Vector2(1500, 300), Vector2(20, 180))
	var contra_parede = _nova_bola(fase, Vector2(1430, 340))
	await _aguardar(20)
	_exigir(not is_instance_valid(contra_parede), "Bola deve sumir ao encontrar parede.")
	var cena_parede = load("res://cena_neymar.tscn").instantiate()
	cena_parede.position = Vector2(1400, 319)
	fase.add_child(cena_parede)
	personagem.position = Vector2(1800, 323)
	var junto_parede = cena_parede.get_node("CharacterBody2D")
	await _aguardar(20)
	junto_parede.perseguir()
	var maior_x: float = junto_parede.global_position.x
	for i in range(100):
		maior_x = maxf(maior_x, junto_parede.global_position.x)
		await process_frame
	_exigir(maior_x <= 1469.1, "Corrida e finta não devem atravessar paredes.")
	cena_parede.queue_free()
	await _limpar_bolas()
	var expirada = _nova_bola(fase, Vector2(-500, 200), -1)
	await _aguardar(185)
	_exigir(not is_instance_valid(expirada), "Bola deve expirar em três segundos sem alvo.")
	var apos_derrota = _nova_bola(fase, Vector2(1000, 340))
	global.qtd_vidas = 0
	await _aguardar(3)
	_exigir(not is_instance_valid(apos_derrota), "Bolas pendentes devem sumir após derrota do jogador.")
	fase.queue_free()
	await _aguardar(2)
	global.resetar_variaveis()
	var fase_real = load("res://cena_fase.tscn").instantiate()
	fase_real.get_node("HUD").apresentar_rivais = false
	root.add_child(fase_real)
	await _aguardar(30)
	_exigir(fase_real.get_node("Neymar/CharacterBody2D").is_on_floor(), "Neymar deve começar apoiado no terreno real.")
	for caminho in ["Mbappe/CharacterBody2D", "Haaland/CharacterBody2D", "Inimigo1/CharacterBody2D", "Inimigo2/CharacterBody2D", "Chefao/Chefao"]:
		_exigir(fase_real.has_node(caminho), "Preservar inimigos e rivais: " + caminho)
	_exigir(fase_real.get_node("Inimigo2/CharacterBody2D").forcao_pulo == 250, "Preservar salto do goleiro.")
	global.personagem = null
	global.portao = null
	fase_real.queue_free()
	await process_frame
	print("Verificação do Neymar: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
