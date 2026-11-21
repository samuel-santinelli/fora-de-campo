extends SceneTree
## Executar no Godot: --headless --path . --script res://verificacoes/verificar_espera_cristiano.gd

var falhas: int = 0

func _initialize() -> void:
	call_deferred("_executar")

func _exigir(condicao: bool, mensagem: String) -> void:
	if not condicao:
		falhas += 1
		push_error(mensagem)

func _executar() -> void:
	var visual = load("res://script_espera_cristiano.gd").new()
	root.add_child(visual)
	_exigir(not visual.visible, "A espera deve iniciar oculta.")
	_exigir(visual.atualizar(0.5, 1, true), "Deve mostrar repouso quando permitido.")
	_exigir(not visual._fazendo_gesto, "Não deve executar gesto imediatamente.")
	_exigir(is_equal_approx(visual._sprite.position.y + 240.0 * visual._sprite.scale.y, 0.0), "A respiração deve manter a sola fixa.")
	visual.atualizar(2.5, 1, true)
	_exigir(visual._fazendo_gesto, "Deve iniciar gesto após três segundos.")
	visual.atualizar(1.0, 1, true)
	_exigir(visual._quadro == 6, "Deve chegar ao sorriso após os primeiros seis quadros.")
	visual.atualizar(0.1, -1, true)
	_exigir(visual.scale.x < 0.0, "A espera e seus efeitos devem acompanhar a direção.")
	_exigir(not visual.atualizar(0.016, 1, false), "Movimento/ataque deve interromper a espera.")
	_exigir(not visual.visible and visual._quadro == 0, "A interrupção deve ocultar e reiniciar o gesto.")
	visual.interromper(0.5)
	_exigir(not visual.atualizar(0.1, 1, true), "O bloqueio por dano deve impedir retomada imediata.")
	_exigir(visual.atualizar(0.41, 1, true), "Deve retomar repouso após o bloqueio.")
	visual.interromper()
	visual.atualizar(3.0, 1, true)
	visual.atualizar(2.0, 1, true)
	_exigir(not visual._fazendo_gesto and visual._quadro == 0, "O gesto deve terminar e retornar ao repouso.")
	visual.free()

	var cena = load("res://cena_jogador.tscn").instantiate()
	root.add_child(cena)
	var personagem = cena.get_node("Personagem")
	_exigir(personagem.has_node("EsperaCristiano"), "A cena deve incluir o novo visual.")
	_exigir(personagem.get_node("CollisionShape2D").shape.size == Vector2(43, 118.5), "A colisão original deve permanecer intacta.")
	var global = root.get_node("ScriptGlobal")
	var vidas_antes: int = global.qtd_vidas
	personagem.receber_dano()
	_exigir(global.qtd_vidas == vidas_antes - global.valor_dano, "O dano original deve continuar descontando vida.")
	_exigir(not personagem.get_node("EsperaCristiano").visible, "Dano deve ocultar a espera.")
	global.qtd_vidas = vidas_antes
	for filho in personagem.get_children():
		if filho is AudioStreamPlayer:
			filho.stop()
			filho.stream = null
	await create_timer(0.1).timeout
	cena.free()
	global.personagem = null
	print("Verificação da espera: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
