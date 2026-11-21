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

func _piso(pai: Node, posicao: Vector2, tamanho: Vector2) -> void:
	var corpo := StaticBody2D.new()
	corpo.position = posicao
	var forma := RectangleShape2D.new()
	forma.size = tamanho
	var colisao := CollisionShape2D.new()
	colisao.shape = forma
	corpo.add_child(colisao)
	pai.add_child(corpo)

func _altura_visivel(textura: Texture2D) -> int:
	var imagem := textura.get_image()
	var topo: int = imagem.get_height()
	var fundo: int = -1
	for y in range(imagem.get_height()):
		for x in range(imagem.get_width()):
			if imagem.get_pixel(x, y).a >= 0.5:
				topo = mini(topo, y)
				fundo = maxi(fundo, y)
	return fundo - topo + 1

func _bola(alvo: Node2D, pai: Node) -> void:
	var bola = load("res://cena_bola.tscn").instantiate()
	bola.position = alvo.global_position - Vector2(70, 3)
	pai.add_child(bola)
	await _aguardar(20)

func _executar() -> void:
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
	var cena = load("res://cena_haaland.tscn").instantiate()
	cena.position = Vector2(500, 319)
	fase.add_child(cena)
	var inimigo = cena.get_node("CharacterBody2D")
	await _aguardar(20)
	_exigir(inimigo.get_script().get_base_script().resource_path == "res://script_inimigo2.gd", "Haaland deve reutilizar a base existente.")
	_exigir(inimigo.is_on_floor() and is_zero_approx(inimigo.velocity.x), "Deve aguardar ativação no chão.")
	_exigir(inimigo.get_node("Resistencia").vida_atual == 4, "Tanque deve começar com quatro vidas.")
	var altura: int = _altura_visivel(inimigo.get_node("Sprite2D").texture)
	var altura_mbappe: int = _altura_visivel(load("res://arte/animacoes/mbappe/parado-v1.png"))
	_exigir(absf(float(altura) / altura_mbappe - 1.20) < 0.01, "Referência deve ficar 20% mais alta sem aplicar aumento duas vezes.")
	_exigir(inimigo.scale == Vector2.ONE and inimigo.get_node("CollisionShape2D").shape.size == Vector2(52, 130), "Ajustar corpo sem escalar raiz nem incluir capa.")
	inimigo.get_node("VisibleOnScreenNotifier2D").emit_signal("screen_entered")
	await _aguardar(3)
	_exigir(inimigo.velocity.x == 180.0 and inimigo.get_node("Sprite2D").scale.x == -0.5, "Avanço deve perseguir para a direita, lento e espelhado.")
	await _aguardar(12)
	_exigir(inimigo._quadro > 0 and inimigo.get_node("Sprite2D").region_rect.size == Vector2(320, 320), "Avanço deve animar a folha aprovada.")
	personagem.position.x = 200
	await _aguardar(3)
	_exigir(inimigo.velocity.x == -180.0 and inimigo.get_node("Sprite2D").scale.x == 0.5, "Deve virar para o jogador à esquerda.")
	var posicao: Vector2 = inimigo.position
	var quadro: int = inimigo._quadro
	paused = true
	await _aguardar(20)
	_exigir(inimigo.position == posicao and inimigo._quadro == quadro, "Pausa deve congelar movimento e animação.")
	paused = false
	var vidas: int = global.qtd_vidas
	inimigo.causar_dano_personagem(personagem)
	_exigir(global.qtd_vidas == vidas - 1, "Contato deve usar dano existente de um ponto.")
	inimigo.receber_dano(0)
	_exigir(inimigo._reacao_restante == 0.0, "Dano zero não deve interromper avanço.")
	inimigo.receber_dano(1)
	await _aguardar(2)
	vidas = global.qtd_vidas
	inimigo.causar_dano_personagem(personagem)
	_exigir(inimigo.get_node("Resistencia").vida_atual == 3 and is_zero_approx(inimigo.velocity.x) and global.qtd_vidas == vidas and not inimigo.get_node("Area2D").monitoring, "Acerto deve abrir breve reação sem contato.")
	await _aguardar(18)
	_exigir(inimigo.velocity.x == -180.0, "Deve retomar avanço depois da reação.")
	personagem.position.x = 2000
	await _aguardar(3)
	_exigir(is_zero_approx(inimigo.velocity.x) and not inimigo.get_node("Area2D").monitoring, "Fora do alcance deve parar e desligar contato.")
	personagem.position.x = inimigo.global_position.x + 300
	inimigo.encerrar_perseguicao()
	await _aguardar(3)
	_exigir(is_zero_approx(inimigo.velocity.x), "Sair da tela deve interromper avanço.")
	inimigo.perseguir()
	global.qtd_vidas = 0
	await _aguardar(3)
	_exigir(is_zero_approx(inimigo.velocity.x) and not inimigo.get_node("Area2D").monitoring, "Jogador derrotado deve interromper perseguição e contato.")
	global.resetar_variaveis()
	global.personagem = null
	await _aguardar(3)
	_exigir(is_zero_approx(inimigo.velocity.x), "Jogador ausente não deve causar erro nem perseguição.")
	global.personagem = personagem
	inimigo.encerrar_perseguicao()
	inimigo.set_process(false)
	await _bola(inimigo, fase)
	_exigir(is_instance_valid(inimigo) and inimigo.get_node("Resistencia").vida_atual == 2, "Bola deve tirar uma vida do Tanque.")
	personagem.get_node("AnimationPlayer").play("carrinho")
	personagem._alvos_carrinho.clear()
	personagem.eliminar_inimigo(inimigo)
	personagem.eliminar_inimigo(inimigo)
	_exigir(inimigo.get_node("Resistencia").vida_atual == 1, "Um carrinho deve acertar o Tanque apenas uma vez.")
	personagem.get_node("AnimationPlayer").stop()
	await _bola(inimigo, fase)
	_exigir(not is_instance_valid(inimigo), "Quarto ataque distinto deve derrotar Haaland.")

	personagem.position.x = 1700
	_piso(fase, Vector2(1565, 300), Vector2(20, 180))
	var cena_parede = load("res://cena_haaland.tscn").instantiate()
	cena_parede.position = Vector2(1500, 319)
	fase.add_child(cena_parede)
	var junto_parede = cena_parede.get_node("CharacterBody2D")
	await _aguardar(20)
	junto_parede.perseguir()
	await _aguardar(40)
	_exigir(junto_parede.global_position.x <= 1529.1 and junto_parede.is_on_wall(), "Tanque não deve atravessar paredes.")
	fase.queue_free()
	await _aguardar(2)
	global.resetar_variaveis()
	var fase_real = load("res://cena_fase.tscn").instantiate()
	fase_real.get_node("HUD").apresentar_rivais = false
	root.add_child(fase_real)
	await _aguardar(30)
	var tanque = fase_real.get_node("Haaland/CharacterBody2D")
	_exigir(tanque.is_on_floor() and tanque.global_position.y < 450, "Haaland deve começar apoiado sobre plataforma elevada real.")
	for caminho in ["Mbappe/CharacterBody2D", "Inimigo1/CharacterBody2D", "Inimigo2/CharacterBody2D", "Chefao/Chefao"]:
		_exigir(fase_real.has_node(caminho), "Preservar rival e inimigos obrigatórios: " + caminho)
	_exigir(fase_real.get_node("Inimigo2/CharacterBody2D").forcao_pulo == 250, "Goleiro deve preservar salto.")
	global.personagem = null
	global.portao = null
	fase_real.queue_free()
	await process_frame
	print("Verificação do Haaland: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
