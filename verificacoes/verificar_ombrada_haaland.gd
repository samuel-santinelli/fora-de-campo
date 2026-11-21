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
	var tanque = fase.get_node("Haaland/CharacterBody2D")
	var jogador = global.personagem
	jogador.set_process(false)
	jogador.global_position = tanque.global_position + Vector2(-40, 0)
	tanque.perseguir()
	tanque.set_process(false)
	var vida: int = global.qtd_vidas
	tanque.causar_dano_personagem(jogador)
	_exigir(global.qtd_vidas == vida - 1, "Ombrada deve manter o dano existente de um ponto.")
	var sprite = tanque.get_node("Sprite2D")
	_exigir(sprite.texture == tanque.OMBRADA, "Contato deve usar folha própria de ataque.")
	var quadros: Dictionary = {}
	for i in range(40):
		tanque._process(1.0 / 60.0)
		quadros[sprite.region_rect.position] = true
		_exigir(sprite.region_rect.end.x <= sprite.texture.get_width() and sprite.region_rect.end.y <= sprite.texture.get_height(), "Quadro deve permanecer dentro da folha.")
	_exigir(quadros.size() == 6, "Ombrada deve mostrar seis poses distintas.")
	tanque.receber_dano(1)
	_exigir(tanque._tempo_tranco == 0 and sprite.texture == tanque.PARADO, "Dano recebido deve cancelar ataque e restaurar a referência de espera.")
	global.personagem = null
	global.portao = null
	fase.queue_free()
	await process_frame
	global.resetar_variaveis()
	print("Verificação da ombrada do Haaland: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
