extends Node2D
@export var apresentar_rivais: bool = true

func _ready() -> void:
	var alerta := CanvasLayer.new()
	alerta.name = "AlertaVida"
	alerta.set_script(preload("res://script_alerta_vida.gd"))
	add_child(alerta)
	$ParallaxBackground/Sprite2D.hide()
	var painel := Panel.new()
	painel.name = "PainelRecursos"
	painel.position = Vector2(18, 18)
	painel.size = Vector2(300, 102)
	painel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color(0.025, 0.055, 0.10, 0.88)
	estilo.border_color = Color("c5a365")
	estilo.set_border_width_all(1)
	painel.add_theme_stylebox_override("panel", estilo)
	$ParallaxBackground.add_child(painel)
	$ParallaxBackground.move_child(painel, 0)
	var bolas := Label.new()
	bolas.name = "Bolas"
	bolas.position = Vector2(62, 82)
	bolas.add_theme_font_size_override("font_size", 16)
	bolas.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$ParallaxBackground.add_child(bolas)
	$ParallaxBackground/Label.position = Vector2(32, 28)
	$ParallaxBackground/Label.add_theme_font_size_override("font_size", 16)
	$ParallaxBackground/Label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var barra := ProgressBar.new()
	barra.name = "BarraVida"
	barra.position = Vector2(62, 56)
	barra.size = Vector2(242, 18)
	barra.show_percentage = false
	barra.mouse_filter = Control.MOUSE_FILTER_IGNORE
	barra.focus_mode = Control.FOCUS_NONE
	var fundo := StyleBoxFlat.new()
	fundo.bg_color = Color("162136")
	fundo.border_color = Color("c5a365")
	fundo.set_border_width_all(1)
	barra.add_theme_stylebox_override("background", fundo)
	var preenchimento := StyleBoxFlat.new()
	preenchimento.bg_color = Color("4aaf79")
	barra.add_theme_stylebox_override("fill", preenchimento)
	$ParallaxBackground.add_child(barra)
	_icone("IconeSaude", preload("res://arte/telas/ui/saude-hud.svg"), Vector2(32, 53))
	_icone("IconeBola", preload("res://arte/telas/ui/bola-hud.svg"), Vector2(32, 81))
	var pausa := Button.new()
	pausa.name = "BotaoPausa"
	pausa.text = "PAUSA"
	pausa.icon = preload("res://arte/telas/ui/pausa.svg")
	pausa.add_theme_constant_override("icon_max_width", 18)
	pausa.process_mode = Node.PROCESS_MODE_ALWAYS
	pausa.size = Vector2(124, 40)
	pausa.add_theme_font_size_override("font_size", 16)
	var caixa := StyleBoxFlat.new()
	caixa.bg_color = Color("15253a")
	caixa.border_color = Color("c5a365")
	caixa.set_border_width_all(1)
	pausa.add_theme_stylebox_override("normal", caixa)
	$ParallaxBackground.add_child(pausa)
	pausa.pressed.connect(func(): $ParallaxBackground/pausa._definir_pausa(not get_tree().paused))
	get_viewport().size_changed.connect(_posicionar_pausa)
	_posicionar_pausa()
	_process(0)
	var orientacao := Control.new()
	orientacao.name = "OrientacaoFase"
	orientacao.set_script(preload("res://script_orientacao_fase.gd"))
	orientacao.apresentacoes_ativas = apresentar_rivais
	$ParallaxBackground.add_child(orientacao)
	$ParallaxBackground.move_child(orientacao, $ParallaxBackground/pausa.get_index())

func _posicionar_pausa() -> void:
	$ParallaxBackground/BotaoPausa.position = Vector2(get_viewport_rect().size.x - 146, 24)

func _icone(nome: String, textura: Texture2D, ponto: Vector2) -> void:
	var icone := TextureRect.new()
	icone.name = nome
	icone.texture = textura
	icone.position = ponto
	icone.size = Vector2(24, 24)
	icone.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	icone.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icone.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icone.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$ParallaxBackground.add_child(icone)

func _process(_delta: float) -> void:
	$ParallaxBackground/Label.text = "CRISTIANO  ·  PORTUGAL 7"
	$ParallaxBackground/BarraVida.max_value = ScriptGlobal.VIDAS_MAXIMAS
	$ParallaxBackground/BarraVida.value = ScriptGlobal.qtd_vidas
	var preenchimento: StyleBoxFlat = $ParallaxBackground/BarraVida.get_theme_stylebox("fill")
	preenchimento.bg_color = Color("cf515b") if ScriptGlobal.qtd_vidas <= 3 else Color("4aaf79")
	$ParallaxBackground/Bolas.text = "BOLAS  %d / %d" % [ScriptGlobal.qtd_bolas, ScriptGlobal.BOLAS_MAXIMAS]
	$ParallaxBackground/Bolas.add_theme_color_override("font_color", Color("f2bc68") if ScriptGlobal.qtd_bolas == 0 else Color("eee5d0"))
