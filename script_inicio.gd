extends Node2D

const CAPA = preload("res://arte/telas/inicio-v1.png")
const FUNDO = preload("res://arte/telas/inicio-fundo-v2.png")
const QUADROS = preload("res://arte/telas/cristiano-abertura-v1.png")
const DURACAO: float = 3.18
var _quadros: Array = []
var _menu: Node2D
var _pular: Button
var _tempo: float = -1.0
var _saindo: bool = false
var _escala_fundo: float = 1.0
var _origem_fundo := Vector2.ZERO
var _posicao_menu := Vector2.ZERO

func _ready() -> void:
	_quadros = preload("res://script_dados_abertura.gd").QUADROS
	$Sprite2D.hide()
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_menu = Node2D.new()
	_menu.name = "Menu"
	add_child(_menu)
	_rotulo("Chamada", "O CAMINHO ATÉ A FINAL", Vector2.ZERO, 14, Color("d7b578"))
	_rotulo("Titulo", "FORA\nDE CAMPO", Vector2(0, 30), 56, Color("f2ce86"))
	_rotulo("Historia", "Atravesse os bloqueios.\nDerrube o VAR-01. Chegue à final.", Vector2(0, 174), 17, Color("e2e6ed"))
	var nomes := ["ButtonIniciar", "Buttonconfig", "ButtonSair"]
	var textos := ["INICIAR JOGO  >", "CONFIGURAÇÕES  >", "SAIR  >"]
	for i in range(nomes.size()):
		var botao: Button = get_node(nomes[i])
		botao.reparent(_menu)
		botao.position = Vector2(4, 245 + i * 64)
		botao.size = Vector2(310, 52)
		botao.text = textos[i]
		_estilizar(botao, i == 0)
	_rotulo("Controles", "A/D ou ESQ/DIR: mover   |   W/CIMA: pular\nEspaço: carrinho   |   C: segurar e soltar\nSegure 1s: superchute   |   P/Esc: pausa", Vector2(0, 440), 13, Color("b9c8dc"))
	_pular = Button.new()
	_pular.name = "PularAbertura"
	_pular.text = "PULAR ABERTURA  >"
	_estilizar(_pular, false)
	_pular.hide()
	add_child(_pular)
	_pular.pressed.connect(_concluir_abertura)
	get_viewport().size_changed.connect(_organizar)
	_organizar()
	_menu.get_node("ButtonIniciar").grab_focus()
	if OS.has_feature("web") and not Preferencias.entrada_web_confirmada:
		_mostrar_entrada_web()

func _mostrar_entrada_web() -> void:
	var camada := CanvasLayer.new()
	camada.name = "EntradaWeb"
	camada.layer = 5
	var fundo := ColorRect.new()
	fundo.color = Color(0.025, 0.045, 0.08, 0.92)
	fundo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	camada.add_child(fundo)
	var centro := CenterContainer.new()
	centro.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	camada.add_child(centro)
	var linhas := VBoxContainer.new()
	linhas.add_theme_constant_override("separation", 18)
	centro.add_child(linhas)
	var titulo := Label.new()
	titulo.text = "FORA DE CAMPO"
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.add_theme_font_size_override("font_size", 30)
	titulo.add_theme_color_override("font_color", Color("edc77f"))
	linhas.add_child(titulo)
	var entrar := Button.new()
	entrar.name = "Entrar"
	entrar.text = "CLIQUE PARA ENTRAR"
	entrar.custom_minimum_size = Vector2(310, 58)
	_estilizar(entrar, true)
	linhas.add_child(entrar)
	var ajuda := Label.new()
	ajuda.text = "Este clique libera o som no navegador."
	ajuda.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ajuda.add_theme_font_size_override("font_size", 14)
	linhas.add_child(ajuda)
	add_child(camada)
	entrar.pressed.connect(func():
		Preferencias.entrada_web_confirmada = true
		camada.queue_free()
		_menu.get_node("ButtonIniciar").grab_focus())
	entrar.grab_focus()

func _rotulo(nome: String, texto: String, ponto: Vector2, tamanho: int, cor: Color) -> void:
	var rotulo := Label.new()
	rotulo.name = nome
	rotulo.text = texto
	rotulo.position = ponto
	rotulo.add_theme_font_size_override("font_size", tamanho)
	rotulo.add_theme_color_override("font_color", cor)
	rotulo.add_theme_color_override("font_shadow_color", Color("07101d"))
	rotulo.add_theme_constant_override("shadow_offset_x", 2)
	rotulo.add_theme_constant_override("shadow_offset_y", 2)
	_menu.add_child(rotulo)

func _estilizar(botao: Button, principal: bool) -> void:
	botao.alignment = HORIZONTAL_ALIGNMENT_LEFT
	botao.add_theme_font_size_override("font_size", 18)
	botao.add_theme_color_override("font_color", Color("142034") if principal else Color("f3e9d3"))
	botao.add_theme_color_override("font_hover_color", Color("142034") if principal else Color.WHITE)
	botao.add_theme_color_override("font_focus_color", Color("142034") if principal else Color.WHITE)
	for estado in ["normal", "hover", "pressed", "focus", "disabled"]:
		var estilo := StyleBoxFlat.new()
		estilo.bg_color = Color("dbb569") if principal else Color("17273c")
		if estado == "hover" or estado == "focus":
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

func _organizar() -> void:
	var tamanho := get_viewport_rect().size
	_escala_fundo = maxf(tamanho.x / 1672.0, tamanho.y / 941.0)
	_origem_fundo = Vector2((tamanho.x - 1672 * _escala_fundo) * 0.68, (tamanho.y - 941 * _escala_fundo) * 0.5)
	var escala_ui: float = clampf(minf(tamanho.y / 648.0, tamanho.x / 850.0), 0.45, 1.7)
	_menu.scale = Vector2.ONE * escala_ui
	_posicao_menu = Vector2(maxf(24, tamanho.x * 0.07), maxf(14, (tamanho.y - 500 * escala_ui) * 0.5))
	_menu.position = _posicao_menu
	_pular.size = Vector2(230, 46)
	_pular.position = Vector2(maxf(8, tamanho.x - _pular.size.x - 20), 16)
	queue_redraw()

func _process(delta: float) -> void:
	if _tempo < 0 or _saindo:
		return
	_tempo += delta
	var saida: float = clampf(_tempo / 0.42, 0, 1)
	_menu.position.x = _posicao_menu.x - 520 * _menu.scale.x * saida * saida
	_menu.modulate.a = 1 - saida
	queue_redraw()
	if _tempo >= DURACAO:
		_concluir_abertura()

func _unhandled_input(event: InputEvent) -> void:
	if _tempo >= 0 and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_concluir_abertura()

func iniciar_jogo() -> void:
	if _tempo >= 0 or _saindo:
		return
	_tempo = 0
	for nome in ["ButtonIniciar", "Buttonconfig", "ButtonSair"]:
		_menu.get_node(nome).disabled = true
	_pular.show()
	_pular.grab_focus()
	queue_redraw()

func _concluir_abertura() -> void:
	if _tempo < 0 or _saindo:
		return
	_saindo = true
	_pular.disabled = true
	ScriptGlobal.resetar_variaveis()
	get_tree().call_deferred("change_scene_to_file", "res://cena_fase.tscn")

func sair() -> void:
	if _tempo < 0:
		get_tree().quit()

func ir_para_configuracoes() -> void:
	if _tempo < 0:
		get_tree().change_scene_to_file("res://cena_configuracoes.tscn")

func _draw() -> void:
	var tamanho := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, tamanho), Color("08101d"))
	draw_set_transform(_origem_fundo, 0, Vector2.ONE * _escala_fundo)
	draw_texture_rect(CAPA, Rect2(0, 0, 1672, 941), false)
	if _tempo >= 0:
		_desenhar_abertura()
	draw_set_transform(Vector2.ZERO)
	if tamanho.x / tamanho.y < 1.5 and _tempo < 0:
		draw_rect(Rect2(_posicao_menu - Vector2(12, 12), Vector2(350, 510) * _menu.scale), Color(0.025, 0.055, 0.10, 0.84))

func _desenhar_abertura() -> void:
	var mistura: float = clampf(_tempo / 0.18, 0, 1)
	draw_texture_rect(FUNDO, Rect2(0, 0, 1672, 941), false, Color(1, 1, 1, mistura))
	var indice: int = 0
	var elevacao: float = 0
	if _tempo < 1.12:
		indice = int(_tempo / 0.18) % 2
	elif _tempo < 1.42:
		indice = 2
	elif _tempo < 1.82:
		indice = 3
		elevacao = 90 * sin((_tempo - 1.42) / 0.4 * PI / 2)
	elif _tempo < 2.03:
		indice = 4
		elevacao = 90 * (1 - (_tempo - 1.82) / 0.21)
	else:
		indice = 5
	var f: Dictionary = _quadros[indice]
	var escala: float = 750.0 / float(_quadros[0].h)
	var base: float = 842 - elevacao
	var pos := Vector2(1148 - (float(f.anchor) - float(f.x)) * escala, base - float(f.h) * escala)
	draw_texture_rect_region(QUADROS, Rect2(pos, Vector2(f.w, f.h) * escala), Rect2(f.x, f.y, f.w, f.h), Color(1, 1, 1, mistura))
	if _tempo > 0.42 and _tempo < 1.03:
		var boca: float = 203 if indice == 0 else 598
		var ponto := Vector2(1148 + (boca - float(f.anchor)) * escala, base - (float(f.y) + float(f.h) - 84) * escala)
		var raio: float = sin((_tempo - 0.42) / 0.61 * PI) * 15
		draw_colored_polygon(PackedVector2Array([ponto + Vector2(0, -raio), ponto + Vector2(3, -3), ponto + Vector2(raio, 0), ponto + Vector2(3, 3), ponto + Vector2(0, raio), ponto + Vector2(-3, 3), ponto + Vector2(-raio, 0), ponto + Vector2(-3, -3)]), Color("fff5ce"))
	if _tempo >= 2.03 and _tempo < 2.55:
		var progresso: float = (_tempo - 2.03) / 0.52
		draw_arc(Vector2(1148, 851), 60 + progresso * 210, 0, TAU, 48, Color(0.92, 0.77, 0.40, 1 - progresso), 4)
		var fonte := ThemeDB.fallback_font
		draw_string_outline(fonte, Vector2(1000, 300), "SIUUU!", HORIZONTAL_ALIGNMENT_LEFT, -1, 80, 8, Color("101b2e"))
		draw_string(fonte, Vector2(1000, 300), "SIUUU!", HORIZONTAL_ALIGNMENT_LEFT, -1, 80, Color("f5ce72"))
	if _tempo > 2.7:
		var limite: float = minf(1, (_tempo - 2.7) / 0.45) * 2100
		draw_colored_polygon(PackedVector2Array([Vector2(-400, 0), Vector2(limite, 0), Vector2(limite - 240, 941), Vector2(-400, 941)]), Color("e4bb65"))
