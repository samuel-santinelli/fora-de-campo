extends Control
## Dicas e apresentações locais à partida. Não altera IA, recursos ou tempo.
const DICAS = [
	{"acao": &"mover", "titulo": "RUMO À FINAL", "texto": "A / D ou ESQ / DIR para se movimentar."},
	{"acao": &"pular", "titulo": "GANHE ALTURA", "texto": "W ou CIMA para pular e escapar dos ataques."},
	{"acao": &"carrinho", "titulo": "CARRINHO RELÂMPAGO", "texto": "ESPAÇO para atacar de perto. Não gasta bolas."},
	{"acao": &"chutar", "titulo": "CHUTE DE ENERGIA", "texto": "Toque C e solte para chutar. Cada chute gasta uma bola."},
	{"acao": &"superchute", "titulo": "SOLTE O SUPERCHUTE", "texto": "Segure C por 1 segundo e solte: fogo, velocidade e dano dobrado."},
]
const RIVAIS = [
	["Inimigo2/CharacterBody2D", "MURALHA", "O GOLEIRO · Persegue e salta em sua direção."],
	["Inimigo1/CharacterBody2D", "SENTENÇA", "A ARBITRAGEM · Cuidado com os cartões."],
	["Neymar/CharacterBody2D", "NEYMAR", "O DRIBLADOR · Fintas e bolas para surpreender."],
	["Mbappe/CharacterBody2D", "MBAPPÉ", "O RELÂMPAGO · Observe o aviso antes da arrancada."],
	["Haaland/CharacterBody2D", "HAALAND", "O TANQUE · Resistência e avanço pesado."],
	["Impedimento/CharacterBody2D", "O IMPEDIMENTO", "O GUARDIÃO · O último bloqueio antes do VAR."],
	["Chefao/Chefao", "VAR-01", "A DECISÃO FINAL · Pule o laser ou interrompa a carga com uma bola."],
]
var concluidas: Dictionary = {}
var apresentados: Dictionary = {}
var indice_dica: int = 0
var _tempo_dica: float = 0.0
var _intervalo_apresentacao: float = 0.0
var _modal: CanvasLayer
var apresentacoes_ativas: bool = true
var _distancia_andada: float = 0.0
var _ultima_posicao: Vector2
var _jogador: CharacterBody2D
var _fase: Node
var _dica: Panel
var _titulo_dica: Label
var _texto_dica: Label
var rival_atual: String = ""

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	set_process(false)
	_iniciar.call_deferred()

func _iniciar() -> void:
	_fase = get_parent().get_parent().get_parent()
	_jogador = ScriptGlobal.personagem
	if not is_instance_valid(_jogador):
		set_process(false)
		return
	_ultima_posicao = _jogador.global_position
	_jogador.acao_realizada.connect(_registrar_acao)
	_dica = _painel("DicaComando")
	_titulo_dica = _linha(_dica, 15, Color("ebc46c"))
	_texto_dica = _linha(_dica, 15, Color("e5ecf5"))
	_atualizar_dica()
	get_viewport().size_changed.connect(_organizar)
	_organizar()
	_organizar.call_deferred()
	set_process(true)

func _painel(nome: String) -> Panel:
	# Panel não propaga o tamanho mínimo do texto para o cartão.
	# Containers + autowrap podiam aumentar a altura durante a primeira exibição.
	var painel := Panel.new()
	painel.name = nome
	painel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	painel.clip_contents = true
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color(0.025, 0.055, 0.10, 0.92)
	estilo.border_color = Color("8e794c")
	estilo.set_border_width_all(1)
	estilo.border_width_left = 4
	estilo.content_margin_left = 18
	estilo.content_margin_right = 18
	estilo.content_margin_top = 12
	estilo.content_margin_bottom = 12
	painel.add_theme_stylebox_override("panel", estilo)
	add_child(painel)
	return painel

func _linha(painel: Panel, tamanho: int, cor: Color) -> Label:
	var texto := Label.new()
	texto.mouse_filter = Control.MOUSE_FILTER_IGNORE
	texto.add_theme_font_size_override("font_size", tamanho)
	texto.add_theme_color_override("font_color", cor)
	texto.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	texto.max_lines_visible = 3
	texto.clip_text = true
	painel.add_child(texto)
	return texto

func _organizar() -> void:
	_posicionar_paineis(get_viewport_rect().size)

func _posicionar_paineis(tela: Vector2) -> void:
	var largura_dica: float = clampf(tela.x - 32, 1, 580)
	var altura_dica: float = minf(122 if largura_dica < 420 else 100, maxf(1, tela.y - 32))
	_dica.size = Vector2(largura_dica, altura_dica)
	_dica.position = Vector2((tela.x - largura_dica) / 2, maxf(16, tela.y - altura_dica - 22))
	_enquadrar_texto(_titulo_dica, Vector2(18, 10), Vector2(largura_dica - 36, 24), 1)
	_enquadrar_texto(_texto_dica, Vector2(18, 38), Vector2(largura_dica - 36, altura_dica - 48), 3)

func _enquadrar_texto(rotulo: Label, ponto: Vector2, tamanho: Vector2, linhas: int) -> void:
	rotulo.position = ponto
	rotulo.custom_minimum_size = Vector2.ZERO
	rotulo.size = Vector2(maxf(1, tamanho.x), maxf(1, tamanho.y))
	rotulo.max_lines_visible = linhas
	rotulo.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS

func _registrar_acao(acao: StringName) -> void:
	concluidas[acao] = true
	if acao == &"superchute":
		concluidas[&"chutar"] = true
	# Breve confirmação antes de avançar para a próxima instrução.
	if indice_dica < DICAS.size() and concluidas.has(DICAS[indice_dica].acao):
		_titulo_dica.text = "OK: " + DICAS[indice_dica].titulo
		_tempo_dica = maxf(_tempo_dica, 6.4)

func _atualizar_dica() -> void:
	while indice_dica < DICAS.size() and concluidas.has(DICAS[indice_dica].acao):
		indice_dica += 1
	_dica.visible = indice_dica < DICAS.size()
	if _dica.visible:
		_titulo_dica.text = DICAS[indice_dica].titulo
		_texto_dica.text = DICAS[indice_dica].texto
	_tempo_dica = 0.0
	_organizar()
	_organizar.call_deferred()

func _rival_visivel(corpo: Node2D) -> bool:
	if not corpo.can_process() or corpo.get_node("Resistencia").derrotado:
		return false
	if absf(corpo.global_position.x - _jogador.global_position.x) > 620:
		return false
	var ponto: Vector2 = corpo.get_global_transform_with_canvas().origin
	return get_viewport_rect().grow(40).has_point(ponto)

func _process(delta: float) -> void:
	if not is_instance_valid(_jogador) or ScriptGlobal.qtd_vidas <= 0:
		hide()
		return
	var deslocamento: float = absf(_jogador.global_position.x - _ultima_posicao.x)
	_ultima_posicao = _jogador.global_position
	if deslocamento < 40 and (Input.is_action_pressed("ir_para_esquerda") or Input.is_action_pressed("ir_para_direita")):
		_distancia_andada += deslocamento
		if _distancia_andada >= 60 and not concluidas.has(&"mover"):
			_registrar_acao(&"mover")
	_tempo_dica += delta
	if _dica.visible:
		_dica.modulate.a = minf(1.0, (7.0 - _tempo_dica) / 0.25)
		if _tempo_dica >= 7.0:
			indice_dica += 1
			_atualizar_dica()
	_intervalo_apresentacao = maxf(0, _intervalo_apresentacao - delta)
	if not apresentacoes_ativas or _intervalo_apresentacao > 0 or is_instance_valid(_modal):
		return
	for i in range(RIVAIS.size()):
		var rival: Array = RIVAIS[i]
		var caminho: String = rival[0]
		if apresentados.has(caminho):
			continue
		var corpo = _fase.get_node_or_null(caminho)
		if is_instance_valid(corpo) and _rival_visivel(corpo):
			_abrir_rival(caminho, rival[1], i + 1)
			break

func _abrir_rival(caminho: String, nome: String, numero: int) -> void:
	if get_tree().paused or is_instance_valid(_modal):
		return
	_modal = preload("res://script_apresentacao_rival.gd").new()
	_modal.name = "ApresentacaoRival"
	_modal.dados = preload("res://script_catalogo_rivais.gd").DADOS[caminho]
	_modal.nome_rival = nome
	_modal.numero = numero
	_modal.encerrada.connect(_encerrar_apresentacao)
	apresentados[caminho] = true
	rival_atual = caminho
	add_child(_modal)

func _encerrar_apresentacao() -> void:
	_modal = null
	_intervalo_apresentacao = 0.8
