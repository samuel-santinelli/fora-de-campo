extends CanvasLayer
## Sobreposição abaixo do HUD; o centro da imagem permanece livre.
class BordasCriticas:
	extends Control
	var forca: float = 0.0
	func _draw() -> void:
		var largura: float = minf(72, minf(size.x, size.y) * 0.12)
		var passo: float = largura / 24.0
		for i in range(24):
			var margem: float = i * passo
			var cor := Color(0.65, 0.025, 0.055, forca * pow(1.0 - i / 24.0, 2))
			draw_rect(Rect2(Vector2.ONE * margem, size - Vector2.ONE * margem * 2), cor, false, passo + 0.5)

var _borda: BordasCriticas
var _aviso: Label
var _tempo: float = 0.0
var _tempo_redesenho: float = 0.0
var intensidade: float = 0.0

func _ready() -> void:
	layer = 0
	_borda = BordasCriticas.new()
	_borda.name = "BordasCriticas"
	_borda.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_borda.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_borda)
	_aviso = Label.new()
	_aviso.name = "AvisoVidaCritica"
	_aviso.text = "VIDA CRÍTICA · PROCURE CURA"
	_aviso.position = Vector2(32, 130)
	_aviso.add_theme_font_size_override("font_size", 14)
	_aviso.add_theme_color_override("font_color", Color("ffaaa0"))
	_aviso.add_theme_color_override("font_shadow_color", Color("101824"))
	_aviso.add_theme_constant_override("shadow_offset_x", 2)
	_aviso.add_theme_constant_override("shadow_offset_y", 2)
	_aviso.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_aviso)
	_process(0)

func _process(delta: float) -> void:
	var vida: int = ScriptGlobal.qtd_vidas
	var critica: bool = vida > 0 and vida <= 3
	var alvo: float = (0.55 + (3 - vida) * 0.225) if critica else 0.0
	intensidade = move_toward(intensidade, alvo, delta * 3.0)
	_tempo += delta * (1.15 if vida > 1 else 1.6) * TAU
	var pulso: float = 0.5 + 0.5 * sin(_tempo)
	_borda.visible = intensidade > 0.001
	_borda.forca = intensidade * (0.24 + pulso * 0.20)
	_tempo_redesenho += delta
	if _borda.visible and _tempo_redesenho >= 1.0 / 30.0:
		_borda.queue_redraw()
		_tempo_redesenho = 0.0
	_aviso.visible = critica
	_aviso.modulate.a = 0.75 + pulso * 0.25
