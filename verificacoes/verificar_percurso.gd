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
	var ordem = ["Inimigo2/CharacterBody2D", "Inimigo1/CharacterBody2D", "Neymar/CharacterBody2D", "Mbappe/CharacterBody2D", "Haaland/CharacterBody2D", "Impedimento/CharacterBody2D", "Chefao/Chefao"]
	var ultimo: float = -1000
	for caminho in ordem:
		var corpo = fase.get_node(caminho)
		_exigir(corpo.position.x + corpo.get_parent().position.x >= ultimo + 899, "Separar encontros na ordem: " + caminho)
		ultimo = corpo.position.x + corpo.get_parent().position.x
		if caminho != "Chefao/Chefao":
			_exigir(corpo.is_on_floor(), "Inimigo deve estar apoiado: " + caminho)
	var personagem = fase.get_node("Jogador/Personagem")
	_exigir(personagem.get_node("Camera2D").limit_right == 13000, "Câmera deve cobrir percurso ampliado.")
	# Testar travessia usando movimentação e salto reais, sem inimigos no teste.
	for nome in ["Inimigo1", "Inimigo2", "Neymar", "Mbappe", "Haaland", "Impedimento", "Chefao", "Portao"]:
		fase.get_node(nome).queue_free()
	await process_frame
	global.portao = null
	Input.action_press("ir_para_direita")
	var chegou: bool = false
	for i in range(2200):
		Input.action_release("pular")
		if personagem.is_on_floor() and personagem.is_on_wall():
			Input.action_press("pular")
		await process_frame
		if personagem.global_position.x >= 12570:
			chegou = true
			break
		if personagem.global_position.y > 850:
			break
	Input.action_release("ir_para_direita")
	Input.action_release("pular")
	_exigir(chegou, "Movimento e salto existentes devem atravessar terreno até o estádio (x=%s y=%s)." % [personagem.global_position.x, personagem.global_position.y])
	global.personagem = null
	fase.queue_free()
	await process_frame
	print("Verificação do percurso: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
