extends CanvasLayer
signal encerrada
const DURACAO: float = 4.0
var dados: Dictionary
var nome_rival: String
var numero: int = 1
var tempo: float = 0.0
var _terminando: bool = false
var _possui_pausa: bool = false
var painel: Panel
var _retrato: TextureRect
var _nome: Label
var _titulo: Label
var _frase: Label
var _ataque: Label
var _defesa: Label
var _ordem: Label
var _continuar: Button
var _barra: ProgressBar
var _escala: float = 1.0
var _origem: Vector2

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 3
	add_to_group("apresentacao_rival")
	var fundo := ColorRect.new()
	fundo.color = Color(0.018, 0.028, 0.045, 0.78)
	fundo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(fundo)
	painel = Panel.new()
	painel.name = "Card"
	painel.clip_contents = true
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color("101d30")
	estilo.border_color = Color("d0ac65")
	estilo.set_border_width_all(2)
	estilo.border_width_left = 7
	painel.add_theme_stylebox_override("panel", estilo)
	add_child(painel)
	var atlas := AtlasTexture.new()
	atlas.atlas = dados.imagem
	var lado: float = dados.imagem.get_height()
	atlas.region = Rect2(0, 0, lado, lado)
	_retrato = TextureRect.new()
	_retrato.name = "Retrato"
	_retrato.texture = atlas
	_retrato.flip_h = true
	_retrato.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_retrato.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_retrato.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_retrato.mouse_filter = Control.MOUSE_FILTER_IGNORE
	painel.add_child(_retrato)
	_ordem = _linha("ENCONTRO %02d / 07" % numero, 13, Color("aebbd0"))
	_nome = _linha(nome_rival, 36, Color("f2d18c"))
	_titulo = _linha(dados.titulo, 19, Color("c6d7ed"))
	_frase = _linha('"' + dados.frase + '"', 16, Color("d9b979"))
	_ataque = _linha("ATAQUE  /  " + dados.ataque, 15, Color("d9e1ec"))
	_defesa = _linha("SUA CHANCE  /  " + dados.defesa, 18, Color("a9e2cf"))
	_continuar = Button.new()
	_continuar.text = "SEGUIR  [ESPAÇO / ENTER]"
	_continuar.add_theme_font_size_override("font_size", 14)
	_continuar.pressed.connect(concluir)
	painel.add_child(_continuar)
	_barra = ProgressBar.new()
	_barra.show_percentage = false
	_barra.max_value = DURACAO
	_barra.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var cor := StyleBoxFlat.new()
	cor.bg_color = Color("d0ac65")
	_barra.add_theme_stylebox_override("fill", cor)
	painel.add_child(_barra)
	_posicionar(get_viewport().get_visible_rect().size)
	get_viewport().size_changed.connect(_organizar)
	_continuar.grab_focus()
	_possui_pausa = not get_tree().paused
	if _possui_pausa:
		get_tree().paused = true
	painel.modulate.a = 0

func _linha(texto: String, tamanho: int, cor: Color) -> Label:
	var linha := Label.new()
	linha.text = texto
	linha.add_theme_font_size_override("font_size", tamanho)
	linha.add_theme_color_override("font_color", cor)
	linha.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	linha.clip_text = true
	linha.mouse_filter = Control.MOUSE_FILTER_IGNORE
	painel.add_child(linha)
	return linha

func _organizar() -> void:
	_posicionar(get_viewport().get_visible_rect().size)

func _posicionar(tela: Vector2) -> void:
	var compacto: bool = tela.x < 720
	var base := Vector2(600, 460) if compacto else Vector2(900, 380)
	_escala = maxf(0.1, minf(1, minf((tela.x - 32) / base.x, (tela.y - 32) / base.y)))
	painel.size = base
	painel.scale = Vector2.ONE * _escala
	_origem = (tela - base * _escala) / 2
	painel.position = _origem
	var x: float = 220 if compacto else 330
	var largura: float = base.x - x - 30
	_retrato.position = Vector2(8, 60 if compacto else 20)
	_retrato.size = Vector2(x - 20, base.y - 85)
	_enquadrar(_ordem, Vector2(x, 22), Vector2(largura, 22))
	_enquadrar(_nome, Vector2(x, 55), Vector2(largura, 48))
	_nome.add_theme_font_size_override("font_size", 28 if compacto else 36)
	_enquadrar(_titulo, Vector2(x, 107), Vector2(largura, 30))
	_enquadrar(_frase, Vector2(x, 147), Vector2(largura, 57))
	_enquadrar(_ataque, Vector2(x, 216), Vector2(largura, 45))
	_enquadrar(_defesa, Vector2(x, 268 if compacto else 261), Vector2(largura, 79 if compacto else 56))
	_continuar.position = Vector2(x, base.y - 57)
	_continuar.size = Vector2(largura, 38)
	_barra.position = Vector2(8, base.y - 7)
	_barra.size = Vector2(base.x - 16, 5)

func _enquadrar(rotulo: Label, ponto: Vector2, tamanho: Vector2) -> void:
	rotulo.position = ponto
	rotulo.size = tamanho

func _process(delta: float) -> void:
	tempo += delta
	var entrada: float = clampf(tempo / 0.22, 0, 1)
	painel.modulate.a = entrada
	painel.position.x = _origem.x + minf((1 - entrada) * 45 * _escala, maxf(0, _origem.x - 4))
	_barra.value = tempo
	if tempo >= DURACAO:
		concluir()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		get_viewport().set_input_as_handled()
		concluir()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.echo:
		get_viewport().set_input_as_handled()

func concluir() -> void:
	if _terminando or tempo < 0.45:
		return
	_terminando = true
	# O espaço usado para seguir não vira um carrinho no primeiro frame retomado.
	Input.action_release("carrinho")
	if _possui_pausa:
		get_tree().paused = false
		_possui_pausa = false
	encerrada.emit()
	queue_free()

func _exit_tree() -> void:
	if _possui_pausa:
		get_tree().paused = false
