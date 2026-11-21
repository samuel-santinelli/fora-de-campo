extends SceneTree
var falhas: int = 0
func _initialize() -> void:
	call_deferred("_executar")
func _exigir(valor: bool, mensagem: String) -> void:
	if not valor:
		falhas += 1
		push_error(mensagem)
func _executar() -> void:
	var global = root.get_node("ScriptGlobal")
	global.resetar_variaveis()
	var fase = load("res://cena_fase.tscn").instantiate()
	fase.get_node("HUD").apresentar_rivais = false
	root.add_child(fase)
	for i in range(30):
		await process_frame
	_exigir(fase.get_node("Cenario/CollisionShape2D3").disabled, "Pedestal antigo deve permanecer desativado.")
	_exigir(fase.get_node("AcabamentoPercurso").get_child_count() == 1, "Remover caixas, degraus e arcos improvisados.")
	var rampa = fase.get_node("AcabamentoPercurso/DesembarqueNavio")
	_exigir(rampa.get_child(0).polygon.size() == 6, "Colisão deve acompanhar prancha e convés da imagem.")
	var ordem = ["Inimigo2/CharacterBody2D", "Inimigo1/CharacterBody2D", "Neymar/CharacterBody2D", "Mbappe/CharacterBody2D", "Haaland/CharacterBody2D", "Impedimento/CharacterBody2D", "Chefao/Chefao"]
	var anterior: float = -1000
	for caminho in ordem:
		var corpo = fase.get_node(caminho)
		_exigir(corpo.global_position.x - anterior >= 1500, "Manter aproximação espaçosa entre encontros: " + caminho)
		anterior = corpo.global_position.x
	for nome in ["Inimigo1", "Inimigo2", "Neymar", "Mbappe", "Impedimento", "Chefao", "Portao"]:
		fase.get_node(nome).queue_free()
	var jogador = global.personagem
	jogador.set_process(false)
	jogador.global_position = fase.to_global(Vector2(8350, 547))
	var haaland = fase.get_node("Haaland/CharacterBody2D")
	_exigir(haaland.is_on_floor() and fase.to_local(haaland.global_position).y < 450, "Haaland deve nascer apoiado no convés.")
	haaland.perseguir()
	for i in range(350):
		await process_frame
	var desembarque: Vector2 = fase.to_local(haaland.global_position)
	_exigir(desembarque.x < 8500 and desembarque.y > 500 and haaland.is_on_floor(), "Haaland deve descer pela prancha até o calçadão: %s." % desembarque)
	global.personagem = null
	global.portao = null
	fase.queue_free()
	await process_frame
	global.resetar_variaveis()
	print("Verificação do percurso v2 e desembarque: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
