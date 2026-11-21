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
	root.add_child(fase)
	var piso := StaticBody2D.new()
	piso.position = Vector2(1000, 500)
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
	personagem.position = Vector2(650, 423)
	var cena = load("res://cena_chefao.tscn").instantiate()
	cena.position = Vector2(900, 390)
	fase.add_child(cena)
	var chefe = cena.get_node("Chefao")
	await _aguardar(20)
	_exigir(chefe.is_on_floor() and chefe.get_node("Resistencia").vida_atual == 6, "Preservar chão e seis vidas.")
	chefe.perseguir()
	for i in range(100):
		if chefe._estado == chefe.Estado.CARGA:
			break
		await process_frame
	_exigir(chefe._estado == chefe.Estado.CARGA, "Primeiro ataque deve carregar laser.")
	_exigir(chefe.segmento_laser()[0].y < chefe.global_position.y - 50, "Laser deve sair do monitor, acima do corpo.")
	var vidas: int = global.qtd_vidas
	await _aguardar(10)
	_exigir(global.qtd_vidas == vidas, "Aviso não deve causar dano.")
	var posicao: Vector2 = chefe.position
	var tempo: float = chefe._tempo
	paused = true
	await _aguardar(20)
	_exigir(chefe.position == posicao and chefe._tempo == tempo, "Pausa deve congelar carga.")
	paused = false
	var bola = load("res://cena_bola.tscn").instantiate()
	bola.position = personagem.global_position + Vector2(58, 39)
	fase.add_child(bola)
	for i in range(45):
		if chefe._estado == chefe.Estado.ATORDOADO:
			break
		await process_frame
	_exigir(chefe._estado == chefe.Estado.ATORDOADO and chefe.get_node("Resistencia").vida_atual == 5, "Bola real na altura do chute deve cancelar laser e tirar uma vida.")
	_exigir(global.qtd_vidas == vidas, "Laser cancelado não pode causar dano atrasado.")
	chefe.set_process(false)
	chefe._direcao_ataque = -1
	chefe._comprimento = 480
	chefe._mudar(chefe.Estado.LASER)
	chefe._tentar_atingir_laser()
	chefe._tentar_atingir_laser()
	_exigir(global.qtd_vidas == vidas - 1, "Laser deve causar dano uma única vez por disparo.")
	vidas = global.qtd_vidas
	personagem.position.y = 280
	chefe._mudar(chefe.Estado.LASER)
	chefe._tentar_atingir_laser()
	_exigir(global.qtd_vidas == vidas, "Salto acima da faixa deve desviar laser.")
	personagem.position = Vector2(chefe.global_position.x + 150, 423)
	chefe._mudar(chefe.Estado.LASER)
	chefe._tentar_atingir_laser()
	_exigir(global.qtd_vidas == vidas, "Mudar de lado deve desviar da direção capturada.")
	personagem.position = Vector2(chefe.global_position.x - 140, 423)
	chefe._mudar(chefe.Estado.GOLPE)
	chefe.set_process(true)
	await _aguardar(15)
	_exigir(global.qtd_vidas == vidas, "Preparação do punho não deve causar dano.")
	await _aguardar(45)
	_exigir(global.qtd_vidas == vidas - 1, "Onda local deve atingir jogador próximo no chão uma vez.")
	vidas = global.qtd_vidas
	personagem.position.x = chefe.global_position.x - 400
	chefe._mudar(chefe.Estado.GOLPE)
	await _aguardar(65)
	_exigir(global.qtd_vidas == vidas, "Golpe no chão não deve atingir jogador distante.")
	personagem.position = Vector2(chefe.global_position.x - 140, 280)
	chefe._mudar(chefe.Estado.GOLPE)
	await _aguardar(65)
	_exigir(global.qtd_vidas == vidas, "Salto deve desviar onda de choque.")
	# Uma parede deve encurtar o feixe antes do jogador.
	var parede := StaticBody2D.new()
	parede.position = chefe.global_position + Vector2(-100, 0)
	var shape := RectangleShape2D.new()
	shape.size = Vector2(20, 200)
	var c := CollisionShape2D.new()
	c.shape = shape
	parede.add_child(c)
	fase.add_child(parede)
	await _aguardar(2)
	chefe._direcao_ataque = -1
	chefe._capturar_mira()
	chefe._atualizar_laser()
	_exigir(chefe.segmento_laser()[0].distance_to(chefe.segmento_laser()[1]) < 100, "Laser deve parar no terreno.")
	global.qtd_vidas = 0
	await _aguardar(2)
	_exigir(chefe._estado == chefe.Estado.AVANCO and is_zero_approx(chefe.velocity.x), "Derrota do jogador deve cancelar ataques.")
	global.personagem = null
	global.portao = null
	fase.queue_free()
	await process_frame
	print("Verificação do VAR-01: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
