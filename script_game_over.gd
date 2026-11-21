extends Node2D


var _menu: Node2D
var _painel: ColorRect
var _saindo: bool = false

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_painel = ColorRect.new()
	_painel.color = Color(0.025, 0.055, 0.10, 0.84)
	_painel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_painel)
	move_child(_painel, 1)
	_menu = Node2D.new()
	_menu.name = "TextoDerrota"
	add_child(_menu)
	_rotulo("Marca", "FORA DE CAMPO", Vector2.ZERO, 14, Color("c9a977"))
	_rotulo("Titulo", "FIM\nDE JOGO", Vector2(0, 32), 62, Color("ecc681"))
	_rotulo("Mensagem", "O caminho foi interrompido.\nA vontade de chegar à final, não.", Vector2(0, 192), 18, Color("bcc8d9"))
	_rotulo("Aviso", "Uma nova tentativa começa\ndo início do percurso.", Vector2(0, 410), 14, Color("a9b8ce"))
	$ButtonReiniciar.text = "TENTAR NOVAMENTE  >"
	$ButtonSair.text = "VOLTAR AO INÍCIO  >"
	_estilizar($ButtonReiniciar, true)
	_estilizar($ButtonSair, false)
	get_viewport().size_changed.connect(_organizar)
	_organizar()
	$ButtonReiniciar.grab_focus()

func _rotulo(nome: String, texto: String, ponto: Vector2, tamanho: int, cor: Color) -> void:
	var rotulo := Label.new()
	rotulo.name = nome
	rotulo.text = texto
	rotulo.position = ponto
	rotulo.add_theme_font_size_override("font_size", tamanho)
	rotulo.add_theme_color_override("font_color", cor)
	_menu.add_child(rotulo)

func _estilizar(botao: Button, principal: bool) -> void:
	botao.alignment = HORIZONTAL_ALIGNMENT_LEFT
	botao.add_theme_font_size_override("font_size", 17)
	for estado in ["normal", "hover", "pressed", "focus", "disabled"]:
		var estilo := StyleBoxFlat.new()
		estilo.bg_color = Color("dbb569") if principal else Color("17273c")
		if estado in ["hover", "focus"]:
			estilo.bg_color = estilo.bg_color.lightened(0.16)
		elif estado == "pressed":
			estilo.bg_color = estilo.bg_color.darkened(0.18)
		estilo.skew = Vector2(0.12, 0)
		estilo.border_color = Color("fff0bb") if estado == "focus" else Color("b89b62")
		estilo.set_border_width_all(3 if estado == "focus" else 1)
		estilo.border_width_left = 5
		estilo.border_width_bottom = 3
		estilo.content_margin_left = 20
		estilo.content_margin_right = 20
		botao.add_theme_stylebox_override(estado, estilo)
	for estado in ["font_color", "font_hover_color", "font_focus_color", "font_pressed_color"]:
		botao.add_theme_color_override(estado, Color("142034") if principal else Color("f3e9d3"))

func _organizar() -> void:
	var tamanho := get_viewport_rect().size
	var escala_fundo: float = maxf(tamanho.x / 1672.0, tamanho.y / 941.0)
	$Sprite2D.scale = Vector2.ONE * escala_fundo
	$Sprite2D.position = Vector2((tamanho.x - 1672 * escala_fundo) * 0.68, (tamanho.y - 941 * escala_fundo) * 0.5) + Vector2(836, 470.5) * escala_fundo
	var escala_ui: float = clampf(minf(tamanho.y / 648.0, tamanho.x / 850.0), 0.45, 1.7)
	var titulo: Label = _menu.get_node("Titulo")
	var mensagem: Label = _menu.get_node("Mensagem")
	var aviso: Label = _menu.get_node("Aviso")
	mensagem.position.y = titulo.position.y + titulo.get_minimum_size().y + 28
	var inicio_botoes: float = mensagem.position.y + mensagem.get_minimum_size().y + 32
	aviso.position.y = inicio_botoes + 66 + 54 + 22
	var altura_menu: float = aviso.position.y + aviso.get_minimum_size().y
	var origem := Vector2(maxf(24, tamanho.x * 0.07), maxf(14, (tamanho.y - altura_menu * escala_ui) * 0.5))
	_menu.scale = Vector2.ONE * escala_ui
	_menu.position = origem
	_painel.position = origem - Vector2(12, 12)
	_painel.size = Vector2(360, altura_menu + 24) * escala_ui
	_painel.visible = tamanho.x / tamanho.y < 1.5
	var botoes := [$ButtonReiniciar, $ButtonSair]
	for i in range(2):
		botoes[i].scale = Vector2.ONE * escala_ui
		botoes[i].position = origem + Vector2(4, inicio_botoes + i * 66) * escala_ui
		botoes[i].size = Vector2(330, 54)

func _preparar_saida() -> bool:
	if _saindo:
		return false
	_saindo = true
	$ButtonReiniciar.disabled = true
	$ButtonSair.disabled = true
	return true

func reiniciar() -> void:
	if not _preparar_saida():
		return
	ScriptGlobal.resetar_variaveis()
	get_tree().call_deferred("change_scene_to_file", "res://cena_fase.tscn")

func sair() -> void:
	if not _preparar_saida():
		return
	ScriptGlobal.resetar_variaveis()
	get_tree().call_deferred("change_scene_to_file", "res://cena_inicio.tscn")
