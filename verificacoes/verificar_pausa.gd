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
	var fase = load("res://cena_fase.tscn").instantiate()
	fase.get_node("HUD").apresentar_rivais = false
	root.add_child(fase)
	await _aguardar(30)
	var painel = fase.get_node("HUD/ParallaxBackground/pausa")
	var continuar: Button = painel.get_node("Painel/Margem/Conteudo/Continuar")
	var personagem = fase.get_node("Jogador/Personagem")
	var rival = fase.get_node("Mbappe/CharacterBody2D")
	Input.action_press("pausa")
	await _aguardar(2)
	Input.action_release("pausa")
	_exigir(paused and painel.visible and continuar.has_focus(), "Pausa deve exibir painel e focar Continuar.")
	var posicao: Vector2 = personagem.global_position
	var posicao_rival: Vector2 = rival.global_position
	Input.action_press("ir_para_direita")
	await _aguardar(20)
	_exigir(personagem.global_position == posicao and rival.global_position == posicao_rival, "Jogador e inimigo devem ficar congelados.")
	for tamanho in [Vector2i(1152,648), Vector2i(640,480), Vector2i(1920,1080)]:
		root.size = tamanho
		await _aguardar(3)
		var viewport: Vector2 = painel.get_viewport_rect().size
		var rect: Rect2 = painel.get_node("Painel").get_global_rect()
		_exigir(rect.position.x >= 0 and rect.position.y >= 0 and rect.end.x <= viewport.x and rect.end.y <= viewport.y, "Painel deve caber no viewport.")
		_exigir(painel.get_node("ColorRect").size == viewport, "Escurecimento deve cobrir viewport inteiro.")
	continuar.pressed.emit()
	_exigir(not paused and not painel.visible, "Botão deve retomar e esconder painel.")
	await _aguardar(6)
	_exigir(personagem.global_position.x > posicao.x, "Movimento real deve voltar após continuar.")
	Input.action_release("ir_para_direita")
	Input.action_press("pausa")
	await _aguardar(2)
	Input.action_release("pausa")
	await _aguardar(2)
	_exigir(paused and continuar.has_focus(), "Reabrir deve restaurar foco.")
	Input.action_press("pausa")
	await _aguardar(2)
	Input.action_release("pausa")
	_exigir(not paused and not painel.visible, "Atalho deve retomar sem botão.")
	root.size = Vector2i(1152,648)
	global.personagem = null
	global.portao = null
	fase.queue_free()
	await process_frame
	print("Verificação da pausa: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
