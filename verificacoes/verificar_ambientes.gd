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
	var fundos = fase.get_node("AmbientesIniciais")
	_exigir(fundos.z_index < 0 and fundos.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST, "Fundos devem ficar atrás dos personagens com filtro pixel art.")
	_exigir(fundos.QUADRA.get_size() == Vector2(2172, 724) and fundos.RUA.get_size() == Vector2(2172, 724), "Preservar as duas referências iniciais.")
	_exigir(is_equal_approx(fundos.CORTE_CHAO * fundos.ESCALA, 607), "Corte do fundo deve coincidir com altura do piso inicial.")
	var lista: Array = fundos.paineis()
	_exigir(lista.size() == 7, "Carregar sete ambientes no percurso.")
	for i in range(1, lista.size()):
		var anterior: Dictionary = lista[i - 1]
		var atual: Dictionary = lista[i]
		var fim_anterior: float = anterior.inicio + anterior.textura.get_width() * fundos.ALTURA_FUNDO / anterior.corte
		_exigir(fim_anterior >= atual.inicio + fundos.TRANSICAO, "Sobrepor painéis durante toda transição para não abrir faixa vazia.")
	for trecho in [{"indice": 2, "x": 4700.0}, {"indice": 3, "x": 6500.0}, {"indice": 4, "x": 8860.0}, {"indice": 5, "x": 10450.0}, {"indice": 6, "x": 12050.0}]:
		var painel: Dictionary = lista[trecho.indice]
		var fim: float = painel.inicio + painel.textura.get_width() * fundos.ALTURA_FUNDO / painel.corte
		_exigir(trecho.x > painel.inicio + fundos.TRANSICAO and trecho.x < fim - fundos.TRANSICAO, "Ambiente deve cobrir o encontro correspondente fora da faixa de mistura.")
	_exigir(fase.get_node("Cenario/TerrenoProvisorio").FIM_ARTE >= 13000, "Revestimento deve chegar ao fim do mapa.")
	var entrada: Dictionary = lista.back()
	_exigir(entrada.fim >= 13000, "Fundo final deve cobrir o limite da câmera.")
	var centro_tunel: float = entrada.inicio + 1638.0 * fundos.ALTURA_FUNDO / entrada.corte
	_exigir(absf(centro_tunel - fase.get_node("Portao").position.x) < 4, "Centro visual do túnel deve alinhar ao portão real.")
	_exigir(not fase.get_node("Cenario/Sprite2D").visible and not fase.get_node("Nuvem").visible, "Arte antiga não deve sobrepor os fundos novos.")
	var cenario = fase.get_node("Cenario")
	_exigir(cenario.get_node("CollisionPolygon2D").polygon[1] == Vector2(12417, -1), "Preservar subida do percurso validado.")
	_exigir(cenario.get_node("CollisionShape2D3").disabled, "Desativar pedestal antigo do Haaland.")
	_exigir(fase.has_node("AcabamentoPercurso/DesembarqueNavio"), "Navio deve ter colisao da prancha.")
	_exigir(fase.get_node("Inimigo1/CharacterBody2D").is_on_floor() and fase.get_node("Inimigo2/CharacterBody2D").is_on_floor(), "Arbitragem e goleiro devem permanecer apoiados.")
	_exigir(fase.get_node("Jogador/Personagem/Camera2D").limit_right == 13000, "Preservar câmera do percurso completo.")
	global.personagem = null
	global.portao = null
	fase.queue_free()
	await process_frame
	print("Verificação de ambientes: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
