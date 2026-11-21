extends SceneTree
var falhas: int = 0
func _initialize() -> void:
	call_deferred("_executar")
func _exigir(valor: bool, mensagem: String) -> void:
	if not valor:
		falhas += 1
		push_error(mensagem)
func _aguardar(n: int = 4) -> void:
	for i in range(n):
		await process_frame
func _executar() -> void:
	var global = root.get_node("ScriptGlobal")
	global.resetar_variaveis()
	var fase = load("res://cena_fase.tscn").instantiate()
	fase.get_node("HUD").apresentar_rivais = false
	root.add_child(fase)
	await _aguardar(30)
	var hud: ProgressBar = fase.get_node("HUD/ParallaxBackground/BarraVida")
	_exigir(hud.value == 10 and hud.max_value == 10 and not hud.show_percentage, "Vida do Cristiano deve usar barra cheia sem porcentagem.")
	var saude: TextureRect = fase.get_node("HUD/ParallaxBackground/IconeSaude")
	var bola: TextureRect = fase.get_node("HUD/ParallaxBackground/IconeBola")
	_exigir(saude.size == Vector2(24,24) and saude.get_global_rect().end.x < hud.get_global_rect().position.x, "Ícone de saúde deve ficar ao lado sem cobrir barra.")
	_exigir(bola.get_global_rect().end.x < fase.get_node("HUD/ParallaxBackground/Bolas").get_global_rect().position.x, "Ícone de bola deve ficar antes do contador.")
	var ponto: Vector2 = hud.get_global_transform_with_canvas().origin
	global.personagem.receber_dano()
	await _aguardar()
	_exigir(hud.value == 9, "Dano deve diminuir barra do jogador.")
	global.recuperar_vida(2)
	await _aguardar()
	_exigir(hud.value == 10, "Cura deve preencher barra até o limite.")
	global.qtd_vidas = 3
	await _aguardar()
	_exigir(hud.get_theme_stylebox("fill").bg_color == Color("cf515b"), "Vida baixa deve mudar cor.")
	global.personagem.global_position.x += 1000
	await _aguardar()
	_exigir(hud.get_global_transform_with_canvas().origin == ponto, "Barra do jogador deve ficar fixa na tela ao mover câmera.")
	var nomes := ["Inimigo1", "Inimigo2", "Mbappe", "Haaland", "Neymar", "Impedimento", "Chefao"]
	var vidas := [1, 1, 2, 4, 3, 5, 6]
	for i in range(nomes.size()):
		var corpo = fase.get_node(nomes[i] + ("/Chefao" if nomes[i] == "Chefao" else "/CharacterBody2D"))
		corpo.set_process(false)
		var barra: ProgressBar = corpo.get_node("BarraVida")
		_exigir(barra.value == vidas[i] and barra.max_value == vidas[i], "Resistência preservada: " + nomes[i])
		var colisao: CollisionShape2D = corpo.get_node("CollisionShape2D")
		_exigir(barra.position.y + barra.size.y < colisao.position.y - colisao.shape.size.y / 2, "Barra deve ficar acima do corpo: " + nomes[i])
		_exigir(barra.mouse_filter == Control.MOUSE_FILTER_IGNORE, "Barra não deve interceptar comandos.")
		var antes: Vector2 = barra.global_position
		corpo.position += Vector2(100, -20)
		_exigir(barra.global_position.is_equal_approx(antes + Vector2(100, -20)), "Barra deve acompanhar deslocamento e salto: " + nomes[i])
	var haaland = fase.get_node("Haaland/CharacterBody2D")
	haaland.receber_dano(1)
	_exigir(haaland.get_node("BarraVida").value == 3, "Dano deve atualizar barra do inimigo imediatamente.")
	var barra_fraca: ProgressBar = fase.get_node("Inimigo1/CharacterBody2D/BarraVida")
	fase.get_node("Inimigo1/CharacterBody2D").receber_dano(1)
	await _aguardar()
	_exigir(not is_instance_valid(barra_fraca), "Barra deve desaparecer junto ao inimigo derrotado.")
	global.personagem = null
	global.portao = null
	fase.queue_free()
	await process_frame
	global.resetar_variaveis()
	print("Verificação das barras de vida: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
