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

func _executar() -> void:
	var visual = load("res://script_salto_cristiano.gd").new()
	root.add_child(visual)
	_exigir(not visual.atualizar(0.016, 1, true, 0.0, true, true), "Parado no chão não deve iniciar salto.")
	visual.atualizar(0.016, 1, false, -800.0, true, true)
	_exigir(visual._quadro == 1, "Impulso deve aparecer sem atraso.")
	visual.atualizar(0.1, -1, false, -400.0, true, false)
	_exigir(visual._quadro == 2 and visual.scale.x < 0.0, "Subida deve acompanhar velocidade e direção.")
	visual.atualizar(0.016, 1, false, 0.0, true, true)
	_exigir(visual._quadro == 3, "Ápice deve usar a pose equilibrada.")
	visual.atualizar(0.016, 1, false, 200.0, true, true)
	_exigir(visual._quadro == 4, "Início da queda deve ter transição.")
	visual.atualizar(2.0, 1, false, 900.0, true, true)
	_exigir(visual._quadro == 5, "Queda longa não deve reiniciar ciclo de salto.")
	visual.atualizar(0.016, 1, true, 0.0, true, true)
	_exigir(visual._quadro == 6, "Contato com o piso deve iniciar aterrissagem.")
	_exigir(not visual.atualizar(0.016, 1, true, 0.0, true, false), "Andar deve interromper aterrissagem imediatamente.")
	visual.atualizar(0.2, 1, false, 500.0, true, true)
	_exigir(visual._quadro == 5, "Sair de plataforma deve mostrar queda, sem simular impulso.")
	_exigir(not visual.atualizar(0.016, 1, true, 0.0, false, true), "Ataque deve interromper aterrissagem.")
	visual.interromper(0.5)
	_exigir(not visual.atualizar(0.1, 1, false, 300.0, true, true), "Dano deve bloquear visual do salto.")
	_exigir(visual.atualizar(0.41, 1, false, 500.0, true, true), "Visual deve retomar após o bloqueio.")
	visual.free()

	var piso := StaticBody2D.new()
	var colisao := CollisionShape2D.new()
	var forma := RectangleShape2D.new()
	forma.size = Vector2(2000, 40)
	colisao.shape = forma
	piso.position = Vector2(500, 400)
	piso.add_child(colisao)
	root.add_child(piso)
	var cena = load("res://cena_jogador.tscn").instantiate()
	cena.position = Vector2.ZERO
	root.add_child(cena)
	var personagem = cena.get_node("Personagem")
	personagem.position = Vector2(300, 300)
	await _aguardar(30)
	_exigir(personagem.is_on_floor(), "Piso de teste deve suportar o jogador.")
	_exigir(personagem.forca_pulo == 800 and personagem.gravidade == 30 and personagem.velocidade == 500, "Parâmetros de movimento devem permanecer originais.")
	Input.action_press("pular")
	await _aguardar(3)
	Input.action_release("pular")
	var salto = personagem.get_node("SaltoCristiano")
	_exigir(salto.visible and personagem.velocity.y < 0.0, "Pulo real deve mostrar a nova arte imediatamente.")
	_exigir(not personagem.get_node("Sprite2D").visible and not personagem.get_node("CorridaCristiano").visible, "Salto não deve sobrepor outros sprites.")
	var y_antes: float = personagem.position.y
	var quadro_antes: int = salto._quadro
	paused = true
	await _aguardar(10)
	_exigir(personagem.position.y == y_antes and salto._quadro == quadro_antes, "Pausa deve congelar corpo e visual no ar.")
	paused = false
	var viu_apice: bool = false
	var viu_queda: bool = false
	var viu_pouso: bool = false
	for i in range(75):
		await process_frame
		if salto.visible:
			viu_apice = viu_apice or salto._quadro == 3
			viu_queda = viu_queda or salto._quadro == 5
			viu_pouso = viu_pouso or salto._quadro == 6
	_exigir(viu_apice and viu_queda and viu_pouso, "Pulo real deve percorrer ápice, queda e aterrissagem.")
	_exigir(personagem.is_on_floor() and personagem.get_node("EsperaCristiano").visible, "Após aterrissar deve retornar à espera.")
	_exigir(personagem.get_node("CollisionShape2D").shape.size == Vector2(43, 118.5), "Colisão original deve permanecer intacta.")
	root.get_node("ScriptGlobal").personagem = null
	for filho in personagem.get_children():
		if filho is AudioStreamPlayer:
			filho.stop()
			filho.stream = null
	cena.queue_free()
	piso.queue_free()
	await process_frame
	print("Verificação do salto: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
