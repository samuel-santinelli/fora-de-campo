extends SceneTree
var falhas: int = 0
func _initialize() -> void:
	call_deferred("_executar")
func _exigir(valor: bool, mensagem: String) -> void:
	if not valor:
		falhas += 1
		push_error(mensagem)
func _limites(painel: Control, tela: Vector2) -> void:
	_exigir(painel.size.x <= 580 and painel.size.y <= 126, "Card deve permanecer compacto: %s %s." % [painel.name, painel.size])
	_exigir(painel.position.x >= 0 and painel.position.y >= 0 and painel.position.x + painel.size.x <= tela.x and painel.position.y + painel.size.y <= tela.y, "Card deve caber na tela: " + str(tela))
	for rotulo in painel.get_children():
		_exigir(rotulo.position.x >= 0 and rotulo.position.y >= 0 and rotulo.position.x + rotulo.size.x <= painel.size.x and rotulo.position.y + rotulo.size.y <= painel.size.y, "Texto deve permanecer dentro do card: " + rotulo.text)
func _executar() -> void:
	var global = root.get_node("ScriptGlobal")
	global.resetar_variaveis()
	var fase = load("res://cena_fase.tscn").instantiate()
	fase.get_node("HUD").apresentar_rivais = false
	root.add_child(fase)
	for i in range(10):
		await process_frame
	global.personagem.set_process(false)
	var ui = fase.get_node("HUD/ParallaxBackground/OrientacaoFase")
	ui.set_process(false)
	var estoque: int = global.qtd_bolas
	for tela in [Vector2(1152, 648), Vector2(640, 480), Vector2(360, 640), Vector2(1920, 1080)]:
		for dado in ui.DICAS:
			ui._dica.hide()
			ui._titulo_dica.text = "OK: " + dado.titulo
			ui._texto_dica.text = dado.texto
			ui._posicionar_paineis(tela)
			ui._dica.show()
			_limites(ui._dica, tela)
			for i in range(4):
				await process_frame
				_limites(ui._dica, tela)
		for rival in ui.RIVAIS:
			var modal = load("res://script_apresentacao_rival.gd").new()
			modal.dados = load("res://script_catalogo_rivais.gd").DADOS[rival[0]]
			modal.nome_rival = rival[1]
			root.add_child(modal)
			modal._posicionar(tela)
			for i in range(4):
				await process_frame
				var rect: Rect2 = modal.painel.get_global_rect()
				_exigir(rect.position.x >= 0 and rect.position.y >= 0 and rect.end.x <= tela.x and rect.end.y <= tela.y, "Apresentação com retrato deve caber: " + rival[1])
			modal.tempo = 0.5
			modal.concluir()
			await process_frame
	_exigir(global.qtd_bolas == estoque and not paused, "Ajuste visual não deve alterar estoque ou pausar.")
	global.personagem = null
	global.portao = null
	fase.queue_free()
	await process_frame
	global.resetar_variaveis()
	print("Verificação do tamanho dos cards: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
