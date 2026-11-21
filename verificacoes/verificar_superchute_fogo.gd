extends SceneTree
var falhas: int = 0
func _initialize() -> void:
	call_deferred("_executar")
func _exigir(valor: bool, mensagem: String) -> void:
	if not valor:
		falhas += 1
		push_error(mensagem)
func _executar() -> void:
	for direcao in [1, -1]:
		var arena := Node2D.new()
		root.add_child(arena)
		var parede := StaticBody2D.new()
		parede.position = Vector2(500 + direcao * 50, 300)
		var forma := RectangleShape2D.new()
		forma.size = Vector2(2, 120)
		var colisao := CollisionShape2D.new()
		colisao.shape = forma
		parede.add_child(colisao)
		arena.add_child(parede)
		var projetil = load("res://cena_bola.tscn").instantiate()
		projetil.position = Vector2(500, 300)
		var corpo = projetil.get_node("CharacterBody2D")
		corpo.dano = 2
		corpo.velocidade = 720
		corpo.direcao = direcao
		arena.add_child(projetil)
		await process_frame
		await process_frame
		_exigir(corpo.get_node("Energia").fogo and corpo.get_node("Energia").direcao == direcao, "Chamas devem acompanhar a direção do disparo.")
		for i in range(8):
			await process_frame
		_exigir(not is_instance_valid(projetil) and is_instance_valid(parede), "Superchute rápido não deve atravessar ou destruir parede fina.")
		var impacto_fogo: bool = false
		for filho in arena.get_children():
			if filho.get_script() == load("res://script_energia_bola.gd"):
				impacto_fogo = filho.impacto and filho.fogo
		_exigir(impacto_fogo, "Colisão deve criar impacto de fogo.")
		arena.queue_free()
		await process_frame
	print("Verificação do fogo e colisão do superchute: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
