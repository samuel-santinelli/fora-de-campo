extends SceneTree

var falhas: int = 0
var trocas_cena: int = 0

func _initialize() -> void:
	scene_changed.connect(_ao_trocar_cena)
	call_deferred("_executar")

func _ao_trocar_cena() -> void:
	trocas_cena += 1

func _exigir(condicao: bool, mensagem: String) -> void:
	if not condicao:
		falhas += 1
		push_error(mensagem)

func _aguardar(quantidade: int) -> void:
	for i in range(quantidade):
		await process_frame

func _tem_bola(pai: Node) -> bool:
	for filho in pai.get_children():
		if filho.has_node("CharacterBody2D"):
			return true
	return false

func _executar() -> void:
	var visual = load("res://script_reacoes_cristiano.gd").new()
	root.add_child(visual)
	visual.receber_dano(-1)
	_exigir(visual.visible and visual.scale.x < 0.0, "Dano deve aparecer imediatamente e respeitar direção.")
	visual.atualizar(0.12)
	_exigir(visual._quadro == 2, "Reação deve percorrer os quadros aprovados.")
	_exigir(not visual.atualizar(0.4), "Reação de dano deve terminar em meio segundo.")
	visual.iniciar_derrota(1)
	visual.atualizar(0.3)
	visual.iniciar_derrota(1)
	visual.receber_dano(-1)
	_exigir(is_equal_approx(visual._tempo, 0.3) and visual._modo == &"derrota", "Golpes repetidos não devem reiniciar derrota.")
	visual.atualizar(1.0)
	_exigir(visual.derrota_concluida() and visual._quadro == 7 and visual.visible, "Derrota deve terminar mantendo pose caída.")
	visual.free()

	var global = root.get_node("ScriptGlobal")
	global.resetar_variaveis()
	var fase := Node2D.new()
	fase.name = "FaseTeste"
	root.add_child(fase)
	current_scene = fase
	var piso := StaticBody2D.new()
	var colisao := CollisionShape2D.new()
	var forma := RectangleShape2D.new()
	forma.size = Vector2(2000, 40)
	colisao.shape = forma
	piso.position = Vector2(500, 400)
	piso.add_child(colisao)
	fase.add_child(piso)
	var cena = load("res://cena_jogador.tscn").instantiate()
	cena.position = Vector2.ZERO
	fase.add_child(cena)
	var personagem = cena.get_node("Personagem")
	personagem.position = Vector2(300, 300)
	await _aguardar(30)
	var reacao = personagem.get_node("ReacoesCristiano")
	Input.action_press("chutar")
	await _aguardar(3)
	Input.action_release("chutar")
	personagem.receber_dano()
	_exigir(global.qtd_vidas == 9 and reacao.visible and not personagem.get_node("Sprite2D").visible, "Dano deve descontar vida e mostrar a reação nova.")
	Input.action_press("chutar")
	Input.action_press("carrinho")
	await _aguardar(3)
	_exigir(not personagem._chute_em_andamento() and not personagem._carrinho_em_andamento() and not _tem_bola(cena), "Reação deve cancelar e impedir ataques invisíveis.")
	Input.action_release("chutar")
	Input.action_release("carrinho")
	var x_antes: float = personagem.position.x
	Input.action_press("ir_para_direita")
	await _aguardar(3)
	Input.action_release("ir_para_direita")
	_exigir(personagem.position.x > x_antes, "Dano não deve bloquear movimentação normal.")
	Input.action_press("pular")
	await _aguardar(3)
	Input.action_release("pular")
	var posicao_no_ar: Vector2 = personagem.position
	var velocidade_no_ar: Vector2 = personagem.velocity
	personagem.receber_dano()
	_exigir(global.qtd_vidas == 8, "Golpes sucessivos devem manter o desconto original de vida, sem invulnerabilidade nova.")
	_exigir(personagem.position == posicao_no_ar and personagem.velocity == velocidade_no_ar, "Dano no ar não deve teletransportar nem aplicar impulso.")
	var tempo_antes: float = reacao._tempo
	paused = true
	await _aguardar(12)
	_exigir(reacao._tempo == tempo_antes and personagem.position == posicao_no_ar, "Pausa deve congelar reação e física.")
	paused = false
	await _aguardar(60)
	# O salto e sua aterrissagem continuam independentes da reação de 500 ms.
	_exigir(not reacao.visible and not personagem.get_node("Sprite2D").visible, "Reação deve terminar mantendo uma das artes novas.")
	var espera_pouso: int = 0
	while (not personagem.is_on_floor() or personagem.get_node("SaltoCristiano").visible) and espera_pouso < 30:
		await process_frame
		espera_pouso += 1
	_exigir(personagem.is_on_floor() and not reacao.visible and personagem.get_node("EsperaCristiano").visible and not _tem_bola(cena), "Após reação deve voltar ao visual novo, sem disparo atrasado.")
	var chefao = load("res://script_chefao.gd").new()
	chefao.esta_na_tela = true
	chefao.causar_dano_personagem()
	_exigir(global.qtd_vidas == 7 and reacao._modo == &"dano", "Chefão deve usar a mesma função de dano e reação.")
	chefao.free()
	await _aguardar(35)

	global.qtd_vidas = 1
	personagem.receber_dano()
	_exigir(global.qtd_vidas == 0 and personagem._em_derrota and current_scene == fase, "Golpe fatal deve iniciar derrota antes de trocar a cena.")
	var x_fatal: float = personagem.position.x
	for acao in ["ir_para_direita", "chutar", "carrinho", "pular"]:
		Input.action_press(acao)
	await _aguardar(8)
	_exigir(personagem.position.x == x_fatal and not personagem._chute_em_andamento() and not personagem._carrinho_em_andamento() and not _tem_bola(cena), "Derrota deve impedir ações e novos projéteis.")
	_exigir(personagem.get_node("Area2D/CollisionShape2D").disabled, "Derrota deve desligar ataque próximo.")
	tempo_antes = reacao._tempo
	paused = true
	await _aguardar(100)
	_exigir(current_scene == fase and reacao._tempo == tempo_antes, "Pausa deve adiar Game Over até retomar a animação.")
	paused = false
	var portao = load("res://cena_portao.tscn").instantiate()
	fase.add_child(portao)
	portao.ir_para_final(personagem)
	await _aguardar(15)
	_exigir(current_scene == fase, "Personagem derrotado não deve atravessar portão para vitória.")
	tempo_antes = reacao._tempo
	for i in range(10):
		personagem.receber_dano()
	_exigir(global.qtd_vidas == 0 and reacao._tempo == tempo_antes, "Golpes após derrota não devem negativar vida ou reiniciar animação.")
	await _aguardar(26)
	_exigir(current_scene == fase, "Game Over não deve interromper a animação de 1,2 segundos.")
	for acao in ["ir_para_direita", "chutar", "carrinho", "pular"]:
		Input.action_release(acao)
	var viu_pose_final: bool = false
	var limite: int = 0
	while current_scene == fase and limite < 100:
		viu_pose_final = viu_pose_final or reacao._quadro == 7
		await process_frame
		limite += 1
	_exigir(viu_pose_final, "Animação deve mostrar a pose final caída.")
	_exigir(current_scene != null and current_scene.scene_file_path == "res://cena_game_over.tscn" and trocas_cena == 1, "Derrota deve abrir Game Over uma única vez.")
	_exigir(global.personagem == null, "Referência global do personagem deve ser limpa ao sair da fase.")
	await _aguardar(6)
	_exigir(trocas_cena == 1, "Não deve haver troca duplicada após Game Over.")
	current_scene.reiniciar()
	await scene_changed
	_exigir(current_scene.scene_file_path == "res://cena_fase.tscn" and global.qtd_vidas == 10 and global.fase_atual == 1, "Reiniciar deve carregar a fase existente com vidas restauradas.")
	var novo = current_scene.get_node("Jogador/Personagem")
	_exigir(not novo._em_derrota and not novo._game_over_agendado and not novo.get_node("ReacoesCristiano").esta_ativa(), "Nova partida deve começar sem estado de derrota anterior.")
	_exigir(novo.get_node("CollisionShape2D").shape.size == Vector2(43, 118.5) and novo.forca_pulo == 800 and novo.gravidade == 30, "Física e colisão originais devem permanecer intactas.")
	print("Verificação de dano e derrota: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
