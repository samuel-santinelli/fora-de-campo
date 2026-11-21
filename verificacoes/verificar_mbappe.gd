extends SceneTree

var MBAPPE = null
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

func _esperar_estado(inimigo: Node, estado: int, limite: int = 160) -> bool:
	for i in range(limite):
		if inimigo._estado == estado:
			return true
		await process_frame
	return false

func _piso(pai: Node, posicao: Vector2, tamanho: Vector2) -> StaticBody2D:
	var corpo := StaticBody2D.new()
	corpo.position = posicao
	var forma := RectangleShape2D.new()
	forma.size = tamanho
	var colisao := CollisionShape2D.new()
	colisao.shape = forma
	corpo.add_child(colisao)
	pai.add_child(corpo)
	return corpo

func _executar() -> void:
	# Carregar depois dos autoloads, como as outras verificações do projeto.
	MBAPPE = load("res://script_mbappe.gd")
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
	var cena = load("res://cena_mbappe.tscn").instantiate()
	cena.position = Vector2(500, 319)
	fase.add_child(cena)
	var inimigo = cena.get_node("CharacterBody2D")
	await _aguardar(20)
	_exigir(inimigo.is_on_floor() and is_zero_approx(inimigo.velocity.x), "Mbappé deve aguardar ativação no chão.")
	_exigir(inimigo.get_script().get_base_script().resource_path == "res://script_inimigo2.gd", "Mbappé deve reutilizar a base do perseguidor.")
	_exigir(inimigo.get_node("Resistencia").vida_atual == 2, "Mbappé deve começar com dois pontos de vida.")
	inimigo.get_node("VisibleOnScreenNotifier2D").emit_signal("screen_entered")
	await _aguardar(3)
	_exigir(inimigo.velocity.x > 0 and inimigo.get_node("Sprite2D").scale.x < 0, "Perseguição deve apontar para o jogador e espelhar a arte corretamente.")
	_exigir(await _esperar_estado(inimigo, MBAPPE.Estado.AVISANDO), "Perseguição deve chegar ao aviso.")
	await _aguardar(2)
	_exigir(is_zero_approx(inimigo.velocity.x) and not inimigo.get_node("Area2D").monitoring, "Aviso deve parar o inimigo e desativar dano de contato.")
	var vidas_antes: int = global.qtd_vidas
	inimigo.causar_dano_personagem(personagem)
	_exigir(global.qtd_vidas == vidas_antes, "Aviso não deve causar dano.")
	var direcao_travada: int = inimigo._direcao_arrancada
	personagem.position.x = inimigo.global_position.x - 200.0
	_exigir(await _esperar_estado(inimigo, MBAPPE.Estado.ARRANCANDO, 30), "Aviso deve anteceder arrancada.")
	_exigir(inimigo.direcao_inimigo2 == direcao_travada and absf(inimigo.velocity.x) == 720.0, "Arrancada deve manter direção capturada mesmo se o jogador mudar de lado.")
	_exigir(inimigo.get_node("EfeitoArrancada").visible, "Arrancada deve mostrar rastro azul.")
	var antes_posicao: Vector2 = inimigo.position
	var antes_tempo: float = inimigo._tempo_estado
	var antes_quadro: int = inimigo._quadro
	paused = true
	await _aguardar(20)
	_exigir(inimigo.position == antes_posicao and inimigo._tempo_estado == antes_tempo and inimigo._quadro == antes_quadro, "Pausa deve congelar movimento, ciclo e animação.")
	paused = false
	_exigir(await _esperar_estado(inimigo, MBAPPE.Estado.RECUPERANDO, 35), "Arrancada deve terminar em recuperação.")
	await _aguardar(2)
	_exigir(absf(inimigo.velocity.x) <= 90 and not inimigo.get_node("Area2D").monitoring and not inimigo.get_node("EfeitoArrancada").visible, "Recuperação deve reduzir movimento e desligar dano/rastro.")
	vidas_antes = global.qtd_vidas
	inimigo.causar_dano_personagem(personagem)
	_exigir(global.qtd_vidas == vidas_antes, "Recuperação deve ser uma oportunidade segura de contra-ataque.")
	_exigir(await _esperar_estado(inimigo, MBAPPE.Estado.PERSEGUINDO, 65), "Após recuperação deve voltar à perseguição.")
	inimigo.encerrar_perseguicao()
	antes_posicao = inimigo.position
	await _aguardar(4)
	_exigir(is_zero_approx(inimigo.velocity.x) and inimigo.position.x == antes_posicao.x, "Sair da tela deve interromper a perseguição.")
	inimigo.perseguir()
	_exigir(await _esperar_estado(inimigo, MBAPPE.Estado.AVISANDO), "Deve retomar o ciclo ao reativar.")
	_exigir(await _esperar_estado(inimigo, MBAPPE.Estado.ARRANCANDO, 30), "Segundo ciclo deve permitir nova arrancada.")
	inimigo.receber_dano(1)
	_exigir(inimigo.get_node("Resistencia").vida_atual == 1 and inimigo._estado == MBAPPE.Estado.RECUPERANDO, "Acerto não fatal deve interromper a arrancada.")
	var bola = load("res://cena_bola.tscn").instantiate()
	bola.position = inimigo.global_position - Vector2(70, 3)
	fase.add_child(bola)
	await _aguardar(20)
	_exigir(not is_instance_valid(inimigo), "Segundo acerto deve derrotar Mbappé pelo combate existente.")

	personagem.position = Vector2(1700, 323)
	var parede = _piso(fase, Vector2(1565, 300), Vector2(20, 180))
	var cena_parede = load("res://cena_mbappe.tscn").instantiate()
	cena_parede.position = Vector2(1500, 319)
	fase.add_child(cena_parede)
	var junto_parede = cena_parede.get_node("CharacterBody2D")
	await _aguardar(20)
	junto_parede.perseguir()
	_exigir(await _esperar_estado(junto_parede, MBAPPE.Estado.RECUPERANDO, 150), "Arrancada contra parede deve entrar em recuperação.")
	_exigir(junto_parede.global_position.x < 1540.0, "Mbappé não deve atravessar paredes.")
	global.qtd_vidas = 0
	await _aguardar(3)
	_exigir(is_zero_approx(junto_parede.velocity.x) and not junto_parede.get_node("Area2D").monitoring, "Jogador sem vidas deve interromper perseguição e contato.")
	fase.queue_free()
	await _aguardar(2)
	global.resetar_variaveis()
	var fase_real = load("res://cena_fase.tscn").instantiate()
	fase_real.get_node("HUD").apresentar_rivais = false
	root.add_child(fase_real)
	await _aguardar(30)
	_exigir(fase_real.has_node("Mbappe/CharacterBody2D") and fase_real.has_node("Inimigo1/CharacterBody2D") and fase_real.has_node("Inimigo2/CharacterBody2D") and fase_real.has_node("Chefao/Chefao"), "Fase deve conter três inimigos comuns e chefão, preservando obrigatórios.")
	_exigir(fase_real.get_node("Mbappe/CharacterBody2D").is_on_floor(), "Mbappé deve estar apoiado no terreno da fase real.")
	_exigir(fase_real.get_node("Inimigo2/CharacterBody2D").forcao_pulo == 250, "Goleiro original deve preservar salto.")
	global.personagem = null
	global.portao = null
	fase_real.queue_free()
	await process_frame
	print("Verificação do Mbappé: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
