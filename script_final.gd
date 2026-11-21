extends Node2D

var _texto: Node2D
var _painel: ColorRect
var _saindo: bool = false

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_painel = ColorRect.new()
	_painel.color = Color(0.025, 0.055, 0.10, 0.86)
	_painel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_painel)
	move_child(_painel, 1)
	_texto = Node2D.new()
	_texto.name = "TextoVitoria"
	add_child(_texto)
	_rotulo("Marca", "FORA DE CAMPO · PERCURSO CONCLUÍDO", 14, Color("c9a977"))
	_rotulo("Titulo", "A FINAL\nÉ SUA.", 58, Color("ecc681"))
	_rotulo("Mensagem", "O VAR-01 caiu.\nOs portões se abriram.\nCristiano chegou ao estádio.", 18, Color("d5dfeb"))
	_rotulo("Aviso", "O caminho terminou. A final vai começar.", 14, Color("b5c6d9"))
	$Button.text = "VOLTAR AO INÍCIO  >"
	$Button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	$Button.add_theme_font_size_override("font_size", 18)
	for estado in ["normal", "hover", "focus", "pressed", "disabled"]:
		var estilo := StyleBoxFlat.new()
		estilo.bg_color = Color("dbb569")
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
		$Button.add_theme_stylebox_override(estado, estilo)
	for estado in ["font_color", "font_hover_color", "font_focus_color", "font_pressed_color"]:
		$Button.add_theme_color_override(estado, Color("142034"))
	get_viewport().size_changed.connect(_organizar)
	_organizar()
	$Button.grab_focus()

func _rotulo(nome: String, texto: String, tamanho: int, cor: Color) -> void:
	var rotulo := Label.new()
	rotulo.name = nome
	rotulo.text = texto
	rotulo.add_theme_font_size_override("font_size", tamanho)
	rotulo.add_theme_color_override("font_color", cor)
	_texto.add_child(rotulo)

func _organizar() -> void:
	var tamanho := get_viewport_rect().size
	var escala_fundo: float = maxf(tamanho.x / 1672.0, tamanho.y / 941.0)
	$Sprite2D.scale = Vector2.ONE * escala_fundo
	$Sprite2D.position = Vector2((tamanho.x - 1672 * escala_fundo) * 0.68, (tamanho.y - 941 * escala_fundo) * 0.5) + Vector2(836, 470.5) * escala_fundo
	var escala_ui: float = clampf(minf(tamanho.y / 648.0, tamanho.x / 850.0), 0.45, 1.7)
	var titulo: Label = _texto.get_node("Titulo")
	var mensagem: Label = _texto.get_node("Mensagem")
	var aviso: Label = _texto.get_node("Aviso")
	titulo.position.y = 32
	mensagem.position.y = titulo.position.y + titulo.get_minimum_size().y + 28
	var inicio_botao: float = mensagem.position.y + mensagem.get_minimum_size().y + 32
	aviso.position.y = inicio_botao + 54 + 24
	var altura: float = aviso.position.y + aviso.get_minimum_size().y
	var origem := Vector2(maxf(24, tamanho.x * 0.07), maxf(14, (tamanho.y - altura * escala_ui) * 0.5))
	_texto.scale = Vector2.ONE * escala_ui
	_texto.position = origem
	_painel.position = origem - Vector2(12, 12)
	_painel.size = Vector2(390, altura + 24) * escala_ui
	_painel.visible = tamanho.x / tamanho.y < 1.5
	$Button.scale = Vector2.ONE * escala_ui
	$Button.position = origem + Vector2(4, inicio_botao) * escala_ui
	$Button.size = Vector2(330, 54)

func ir_para_inicio() -> void:
	if _saindo:
		return
	_saindo = true
	$Button.disabled = true
	get_tree().call_deferred("change_scene_to_file", "res://cena_inicio.tscn")
