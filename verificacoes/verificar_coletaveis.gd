extends SceneTree
var falhas: int = 0
func _initialize() -> void:
	call_deferred("_executar")
func _exigir(valor: bool, mensagem: String) -> void:
	if not valor:
		falhas += 1
		push_error(mensagem)
func _aguardar(n: int = 6) -> void:
	for i in range(n):
		await process_frame
func _executar() -> void:
	var global = root.get_node("ScriptGlobal")
	global.resetar_variaveis()
	_exigir(global.qtd_bolas == 10 and global.qtd_vidas == 10, "Reset deve restaurar recursos iniciais.")
	var fase = load("res://cena_fase.tscn").instantiate()
	fase.get_node("HUD").apresentar_rivais = false
	root.add_child(fase)
	await _aguardar(30)
	_exigir(get_nodes_in_group("coletaveis").size() == 11, "Percurso deve ter sete reservas e quatro curas.")
	for nome in ["Inimigo1", "Inimigo2", "Neymar", "Mbappe", "Haaland", "Impedimento", "Chefao", "Portao"]:
		fase.get_node(nome).queue_free()
	await process_frame
	var jogador = global.personagem
	global.qtd_vidas = 9
	jogador.global_position = fase.get_node("Coletaveis/Vida1800").global_position
	await _aguardar()
	_exigir(global.qtd_vidas == 10 and not fase.has_node("Coletaveis/Vida1800"), "Contato real cura sem ultrapassar limite e consome item uma vez.")
	jogador.global_position = fase.get_node("Coletaveis/Vida5300").global_position
	await _aguardar()
	_exigir(fase.has_node("Coletaveis/Vida5300"), "Vida cheia não deve desperdiçar cura.")
	global.qtd_vidas = 8
	await _aguardar()
	_exigir(global.qtd_vidas == 10 and not fase.has_node("Coletaveis/Vida5300"), "Recurso gasto ainda em contato deve permitir coleta.")
	global.qtd_bolas = 19
	jogador.global_position = fase.get_node("Coletaveis/Bolas650").global_position
	await _aguardar()
	_exigir(global.qtd_bolas == 20 and not fase.has_node("Coletaveis/Bolas650"), "Bolas devem respeitar capacidade máxima.")
	jogador.global_position = Vector2(1000, 547)
	await _aguardar(12)
	global.qtd_bolas = 1
	jogador.get_node("AnimationPlayer").play("chutando")
	jogador.spawnar_bolar()
	jogador.spawnar_bolar()
	_exigir(global.qtd_bolas == 0, "Um disparo deve gastar exatamente uma bola.")
	var quantidade: int = fase.get_node("Jogador").get_child_count()
	jogador._bola_disparada = false
	jogador.spawnar_bolar()
	_exigir(fase.get_node("Jogador").get_child_count() == quantidade, "Sem bolas não deve nascer projétil.")
	jogador.get_node("AnimationPlayer").stop()
	jogador.animando = false
	Input.action_press("carrinho")
	await _aguardar(2)
	Input.action_release("carrinho")
	_exigir(jogador._carrinho_em_andamento() and global.qtd_bolas == 0, "Carrinho deve continuar disponível sem munição.")
	jogador.set_process(false)
	global.qtd_vidas = 0
	var cura = fase.get_node("Coletaveis/Vida7400")
	cura._coletar(jogador)
	_exigir(not cura.consumido and global.qtd_vidas == 0, "Coleta não pode reviver derrotado.")
	global.resetar_variaveis()
	await _aguardar(2)
	_exigir(fase.get_node("HUD/ParallaxBackground/Bolas").text.contains("10 / 20"), "HUD deve mostrar estoque atual.")
	global.personagem = null
	global.portao = null
	fase.queue_free()
	await process_frame
	print("Verificação de coletas e munição: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
