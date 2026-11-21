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

func _obstaculo(posicao: Vector2, tamanho: Vector2) -> StaticBody2D:
	var corpo := StaticBody2D.new()
	var colisao := CollisionShape2D.new()
	var forma := RectangleShape2D.new()
	forma.size = tamanho
	colisao.shape = forma
	corpo.position = posicao
	corpo.add_child(colisao)
	root.add_child(corpo)
	return corpo

func _inimigo(posicao: Vector2) -> CharacterBody2D:
	var corpo := CharacterBody2D.new()
	corpo.collision_layer = 4
	corpo.collision_mask = 0
	corpo.position = posicao
	var colisao := CollisionShape2D.new()
	var forma := RectangleShape2D.new()
	forma.size = Vector2(16, 80)
	colisao.shape = forma
	corpo.add_child(colisao)
	root.add_child(corpo)
	return corpo

func _executar() -> void:
	var piso = _obstaculo(Vector2(500, 400), Vector2(2000, 40))
	var cena = load("res://cena_jogador.tscn").instantiate()
	cena.position = Vector2.ZERO
	root.add_child(cena)
	var personagem = cena.get_node("Personagem")
	personagem.position = Vector2(300, 300)
	await _aguardar(30)
	var visual = personagem.get_node("CarrinhoCristiano")
	var animacao = personagem.get_node("AnimationPlayer")
	var area = personagem.get_node("Area2D")
	var forma_ataque = area.get_node("CollisionShape2D")
	var inicio: float = personagem.position.x
	var frente = _inimigo(Vector2(inicio + 80, 340))
	var atras = _inimigo(Vector2(inicio - 100, 340))
	Input.action_press("carrinho")
	await _aguardar(4)
	_exigir(visual.visible and not personagem.get_node("Sprite2D").visible, "Carrinho deve usar apenas a arte aprovada.")
	_exigir(forma_ataque.disabled, "Preparação não deve acertar antes da janela original de 100 ms.")
	var tempo_antes: float = animacao.current_animation_position
	var posicao_antes: Vector2 = personagem.position
	paused = true
	await _aguardar(6)
	_exigir(animacao.current_animation_position == tempo_antes and personagem.position == posicao_antes, "Pausa deve congelar animação e impulso.")
	paused = false
	await _aguardar(9)
	_exigir(not forma_ataque.disabled and area.position.x > 0, "Janela ativa deve usar área de ataque à frente.")
	await _aguardar(30)
	_exigir(not is_instance_valid(frente), "Carrinho deve eliminar inimigo à frente pelo sinal existente.")
	_exigir(is_instance_valid(atras), "Carrinho não deve acertar inimigo distante atrás.")
	_exigir(personagem.position.x > inicio + 100 and personagem.position.x < inicio + 175, "Impulso deve ser curto e independente de segurar direção.")
	_exigir(not personagem._carrinho_em_andamento() and forma_ataque.disabled, "Segurar a tecla não deve repetir o carrinho nem manter dano ativo.")
	Input.action_release("carrinho")
	Input.action_press("ir_para_esquerda")
	await _aguardar(2)
	Input.action_release("ir_para_esquerda")
	Input.action_press("carrinho")
	await _aguardar(12)
	_exigir(visual.scale.x < 0 and area.scale.x < 0 and area.position.x < 0 and personagem.velocity.x < 0, "Arte, impulso e área devem acompanhar carrinho para esquerda.")
	Input.action_release("carrinho")
	Input.action_press("pular")
	await _aguardar(3)
	_exigir(not visual.visible and forma_ataque.disabled and personagem.velocity.y < 0, "Pulo deve cancelar o carrinho e desligar sua área de ataque.")
	Input.action_release("pular")
	await _aguardar(90)
	personagem.position = Vector2(550, 300)
	var parede = _obstaculo(Vector2(650, 300), Vector2(20, 180))
	Input.action_press("ir_para_direita")
	await _aguardar(2)
	Input.action_release("ir_para_direita")
	await _aguardar(20)
	Input.action_press("carrinho")
	await _aguardar(36)
	Input.action_release("carrinho")
	_exigir(personagem.position.x < 620, "Deslizamento com move_and_slide não deve atravessar parede.")
	Input.action_press("carrinho")
	await _aguardar(3)
	personagem.receber_dano()
	await _aguardar(2)
	_exigir(not visual.visible and forma_ataque.disabled, "Dano deve interromper visual e ataque do carrinho.")
	Input.action_release("carrinho")
	_exigir(personagem.velocidade == 500 and personagem.gravidade == 30 and personagem.forca_pulo == 800, "Parâmetros da movimentação normal devem permanecer originais.")
	_exigir(personagem.get_node("CollisionShape2D").shape.size == Vector2(43, 118.5), "Colisão física do jogador deve permanecer original.")
	root.get_node("ScriptGlobal").personagem = null
	for filho in personagem.get_children():
		if filho is AudioStreamPlayer:
			filho.stop()
			filho.stream = null
	if is_instance_valid(frente):
		frente.queue_free()
	if is_instance_valid(atras):
		atras.queue_free()
	cena.queue_free()
	parede.queue_free()
	piso.queue_free()
	await process_frame
	print("Verificação do carrinho: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
