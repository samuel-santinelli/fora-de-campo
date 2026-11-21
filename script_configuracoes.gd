extends Node2D

const FUNDO = preload("res://arte/telas/configuracoes-vestiario-v1.png")
const SILENCIADO = preload("res://arte/telas/ui/silenciar-ativo.svg")
const LIGADO = preload("res://arte/telas/ui/silenciar-inativo.svg")
var _origem := Vector2.ZERO
var _escala: float = 1.0
var _painel: StyleBoxFlat
var _saindo: bool = false

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_painel = StyleBoxFlat.new()
	_painel.bg_color = Color(0.035, 0.065, 0.115, 0.94)
	_painel.border_color = Color("b89b62")
	_painel.set_border_width_all(1)
	_painel.border_width_left = 3
	$Label.text = "CONFIGURAÇÕES"
	$Label.add_theme_font_size_override("font_size", 32)
	$Label.add_theme_color_override("font_color", Color("ecc681"))
	$Label2.text = "Silencia músicas e efeitos sonoros.\nUse Espaço ou clique para alternar."
	$Label2.add_theme_font_size_override("font_size", 15)
	$Label2.add_theme_color_override("font_color", Color("bdcada"))
	$CheckButton.text = "Silenciar áudio"
	$CheckButton.add_theme_font_size_override("font_size", 19)
	$CheckButton.add_theme_color_override("font_color", Color("f0e7d4"))
	for estado in ["font_hover_color", "font_pressed_color", "font_focus_color"]:
		$CheckButton.add_theme_color_override(estado, Color("fff0cf"))
	$CheckButton.add_theme_icon_override("checked", SILENCIADO)
	$CheckButton.add_theme_icon_override("unchecked", LIGADO)
	$CheckButton.add_theme_icon_override("checked_disabled", SILENCIADO)
	$CheckButton.add_theme_icon_override("unchecked_disabled", LIGADO)
	$CheckButton.add_theme_constant_override("h_separation", 18)
	$CheckButton.set_pressed_no_signal(AudioServer.is_bus_mute(AudioServer.get_bus_index("Master")))
	$ButtonVoltar.text = "VOLTAR AO INÍCIO  >"
	$ButtonVoltar.add_theme_font_size_override("font_size", 16)
	for estado in ["normal", "hover", "pressed", "focus"]:
		var estilo := StyleBoxFlat.new()
		estilo.bg_color = Color("edcc89") if estado in ["hover", "focus"] else Color("dbb569")
		estilo.skew = Vector2(0.1, 0)
		estilo.border_color = Color("fff0bb")
		estilo.set_border_width_all(3 if estado == "focus" else 1)
		estilo.border_width_left = 5
		$ButtonVoltar.add_theme_stylebox_override(estado, estilo)
		$ButtonVoltar.add_theme_color_override("font_" + estado + "_color" if estado != "normal" else "font_color", Color("142034"))
	var foco := StyleBoxFlat.new()
	foco.bg_color = Color(0, 0, 0, 0)
	foco.border_color = Color("f4d99e")
	foco.set_border_width_all(2)
	$CheckButton.add_theme_stylebox_override("focus", foco)
	for estado in ["normal", "hover", "pressed", "hover_pressed"]:
		var caixa := StyleBoxFlat.new()
		caixa.bg_color = Color("22354d") if estado in ["hover", "hover_pressed"] else Color("15253a")
		caixa.content_margin_left = 12
		caixa.content_margin_right = 12
		caixa.content_margin_top = 10
		caixa.content_margin_bottom = 10
		$CheckButton.add_theme_stylebox_override(estado, caixa)
	for nome in ["Marca", "StatusAudio"]:
		var rotulo := Label.new()
		rotulo.name = nome
		rotulo.add_theme_font_size_override("font_size", 14)
		rotulo.add_theme_color_override("font_color", Color("c9ad78"))
		add_child(rotulo)
	$Marca.text = "FORA DE CAMPO  /  ÁUDIO"
	# Ajuda fixa evita popups sobrepostos e rótulos não capturam o mouse.
	for nome in ["Marca", "Label", "Label2", "StatusAudio"]:
		get_node(nome).mouse_filter = Control.MOUSE_FILTER_IGNORE
	for nome in ["CheckButton", "ButtonVoltar"]:
		get_node(nome).tooltip_text = ""
	_atualizar_status()
	_criar_gerais()
	get_viewport().size_changed.connect(_organizar)
	_organizar()
	$CheckButton.grab_focus()

func _criar_gerais() -> void:
	var nomes := ["Principal", "Musica", "Personagens"]
	var textos := ["Volume principal", "Música", "Personagens e efeitos"]
	var canais := ["Master", "Musica", "Efeitos"]
	for i in range(3):
		var rotulo := Label.new()
		rotulo.name = "Nome" + nomes[i]
		rotulo.text = textos[i]
		rotulo.add_theme_font_size_override("font_size", 16)
		rotulo.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(rotulo)
		var valor := Label.new()
		valor.name = "Valor" + nomes[i]
		valor.add_theme_font_size_override("font_size", 14)
		valor.mouse_filter = Control.MOUSE_FILTER_IGNORE
		valor.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		add_child(valor)
		var slider := HSlider.new()
		slider.name = "Volume" + nomes[i]
		slider.min_value = 0
		slider.max_value = 100
		slider.step = 1
		slider.value = roundf(Preferencias.volume(canais[i]))
		valor.text = "%d%%" % slider.value
		var trilho := StyleBoxFlat.new()
		trilho.bg_color = Color("33445a")
		trilho.content_margin_top = 3
		trilho.content_margin_bottom = 3
		slider.add_theme_stylebox_override("slider", trilho)
		var preenchido := trilho.duplicate() as StyleBoxFlat
		preenchido.bg_color = Color("dfbd76")
		slider.add_theme_stylebox_override("grabber_area", preenchido)
		slider.add_theme_stylebox_override("grabber_area_highlight", preenchido)
		add_child(slider)
		slider.value_changed.connect(func(v: float):
			Preferencias.definir_volume(canais[i], v)
			valor.text = "%d%%" % v)
	$Label2.text = "Inclui músicas, ataques e sons dos inimigos."
	$Label2.add_theme_font_size_override("font_size", 13)
	$StatusAudio.hide()
	var ordem := [$VolumePrincipal, $VolumeMusica, $VolumePersonagens, $CheckButton, $ButtonVoltar]
	for i in range(ordem.size()):
		ordem[i].focus_next = ordem[i].get_path_to(ordem[(i + 1) % ordem.size()])
		ordem[i].focus_previous = ordem[i].get_path_to(ordem[(i - 1 + ordem.size()) % ordem.size()])

func _organizar() -> void:
	var tamanho := get_viewport_rect().size
	_escala = maxf(0.25, minf(1.0, minf((tamanho.y - 40) / 450.0, tamanho.x / 1000.0)))
	_origem = Vector2(maxf(20, tamanho.x * 0.07), (tamanho.y - 450 * _escala) / 2)
	var pontos := {"Marca": Vector2(28, 20), "Label": Vector2(28, 46), "CheckButton": Vector2(28, 292), "Label2": Vector2(28, 350), "StatusAudio": Vector2(28, 368), "ButtonVoltar": Vector2(32, 390)}
	var nomes := ["Principal", "Musica", "Personagens"]
	for i in range(3):
		pontos["Nome" + nomes[i]] = Vector2(28, 112 + i * 58)
		pontos["Valor" + nomes[i]] = Vector2(332, 112 + i * 58)
		pontos["Volume" + nomes[i]] = Vector2(28, 136 + i * 58)
	for nome in pontos:
		var controle: Control = get_node(nome)
		controle.scale = Vector2.ONE * _escala
		controle.position = _origem + pontos[nome] * _escala
		controle.size = controle.get_minimum_size()
	$CheckButton.size = Vector2(384, 48)
	$ButtonVoltar.size = Vector2(376, 44)
	for nome in nomes:
		get_node("Volume" + nome).size = Vector2(384, 24)
		get_node("Valor" + nome).size = Vector2(80, 24)
	queue_redraw()

func _draw() -> void:
	if _painel == null:
		return
	var tamanho := get_viewport_rect().size
	var escala: float = maxf(tamanho.x / 1672.0, tamanho.y / 941.0)
	var origem := Vector2((tamanho.x - 1672 * escala) * 0.68, (tamanho.y - 941 * escala) * 0.5)
	draw_texture_rect(FUNDO, Rect2(origem, Vector2(1672, 941) * escala), false)
	draw_style_box(_painel, Rect2(_origem, Vector2(440, 450) * _escala))

func voltar() -> void:
	if _saindo:
		return
	_saindo = true
	get_tree().call_deferred("change_scene_to_file", "res://cena_inicio.tscn")

func _silenciar() -> void:
	var volume = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(volume, $CheckButton.button_pressed)
	_atualizar_status()

func _atualizar_status() -> void:
	$StatusAudio.text = "Áudio silenciado" if $CheckButton.button_pressed else "Áudio ligado"
