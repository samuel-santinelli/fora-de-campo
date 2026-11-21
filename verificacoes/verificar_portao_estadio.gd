extends SceneTree
var falhas: int = 0

func _initialize() -> void:
	call_deferred("_executar")

func _exigir(condicao: bool, mensagem: String) -> void:
	if not condicao:
		falhas += 1
		push_error(mensagem)

func _executar() -> void:
	var global = root.get_node("ScriptGlobal")
	global.resetar_variaveis()
	var fase = load("res://cena_fase.tscn").instantiate()
	fase.get_node("HUD").apresentar_rivais = false
	root.add_child(fase)
	await process_frame
	var portao = fase.get_node("Portao")
	var visual = portao.get_node("VisualEstadio")
	var animacao: AnimationPlayer = portao.get_node("AnimationPlayer")
	var gatilho: CollisionShape2D = portao.get_node("Area2D/CollisionShape2D")
	_exigir(global.portao == portao and portao.position == Vector2(12570, 516), "Manter registro e posição do portão funcional.")
	_exigir(not portao.get_node("Sprite2D").visible and is_zero_approx(visual.abertura), "Arte antiga oculta e folhas novas fechadas.")
	_exigir((visual.global_scale - Vector2.ONE).length() < 0.001, "Acabamento deve preservar proporção apesar da escala herdada.")
	_exigir(gatilho.disabled and gatilho.shape.size == Vector2(52, 408.5), "Gatilho original deve começar desabilitado e manter dimensões.")
	# Avançar a animação original sem atravessar o gatilho com o jogador.
	animacao.play("abrir")
	animacao.advance(0.2)
	visual._process(0)
	_exigir(visual.abertura > 0.45 and visual.abertura < 0.55 and gatilho.disabled, "Metade da abertura não deve liberar vitória.")
	animacao.advance(0.21)
	visual._process(0)
	_exigir(is_equal_approx(visual.abertura, 1.0) and not gatilho.disabled, "Folhas recolhidas quando animação habilita vitória.")
	animacao.advance(0.3)
	visual._process(0)
	_exigir(is_equal_approx(visual.abertura, 1.0), "Portão deve continuar aberto após terminar animação.")
	animacao.play("RESET")
	animacao.advance(0.01)
	visual._process(0)
	_exigir(is_zero_approx(visual.abertura) and gatilho.disabled, "RESET deve sincronizar folhas e gatilho.")
	global.personagem = null
	global.portao = null
	fase.queue_free()
	await process_frame
	print("Verificação do portão do estádio: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
