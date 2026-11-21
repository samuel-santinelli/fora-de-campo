extends Node2D
## Somente leitura dos estados existentes: nenhum atraso ou dano adicional.
enum Tipo { GOLEIRO, MBAPPE, VAR }
var tipo: Tipo = Tipo.GOLEIRO
var aviso: String = ""
var _rotulo: Label
var _tempo: float = 0.0
var _sentido: int = 1
var _alcance: float = 0
var _modo: StringName = &""
var _inicio_feixe := Vector2.ZERO
var _fim_feixe := Vector2.ZERO

func _ready() -> void:
	z_index = 21
	_rotulo = Label.new()
	_rotulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_rotulo.size = Vector2(260, 24)
	_rotulo.add_theme_font_size_override("font_size", 13)
	_rotulo.add_theme_color_override("font_outline_color", Color("0b1424"))
	_rotulo.add_theme_constant_override("outline_size", 5)
	_rotulo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_rotulo)
	hide()

func _process(delta: float) -> void:
	_tempo += delta
	aviso = ""
	_modo = &""
	var corpo = get_parent()
	var jogador = ScriptGlobal.personagem
	if not is_instance_valid(jogador) or ScriptGlobal.qtd_vidas <= 0 or not corpo.can_process() or corpo.get_node("Resistencia").derrotado:
		hide()
		return
	var cor := Color("ffd778")
	match tipo:
		Tipo.GOLEIRO:
			if corpo.velocidade > 0 and corpo.is_on_floor() and absf(jogador.global_position.x - corpo.global_position.x) <= 190 and absf(jogador.global_position.y - corpo.global_position.y) < 110:
				aviso = "ATENÇÃO AO SALTO!"
				_modo = &"salto"
		Tipo.MBAPPE:
			if corpo._estado == corpo.Estado.AVISANDO:
				aviso = "ARRANCADA!"
				_sentido = corpo._direcao_arrancada
				_alcance = corpo.velocidade_arrancada * corpo.tempo_arrancada
				_modo = &"arrancada"
				cor = Color("8ce5ff")
		Tipo.VAR:
			_sentido = corpo._direcao_ataque
			if corpo._estado == corpo.Estado.CARGA:
				aviso = "LASER · PULE OU CHUTE"
				var segmento: PackedVector2Array = corpo.segmento_laser()
				_inicio_feixe = to_local(segmento[0])
				_fim_feixe = to_local(segmento[1])
				_modo = &"laser"
				cor = Color("ff9a88")
			elif corpo._estado == corpo.Estado.GOLPE:
				aviso = "ONDA DE CHOQUE · PULE"
				_alcance = corpo._alcance_sem_parede(220, 78)
				_modo = &"onda"
	visible = not aviso.is_empty()
	_rotulo.text = aviso
	_rotulo.add_theme_color_override("font_color", cor)
	var barra = corpo.get_node_or_null("BarraVida")
	_rotulo.position = Vector2(-130, barra.position.y - 29 if is_instance_valid(barra) else -145)
	queue_redraw()

func _draw() -> void:
	var pulso: float = 0.65 + sin(_tempo * TAU * 2) * 0.15
	if _modo == &"salto":
		draw_arc(Vector2(0, 57), 25, PI, TAU, 12, Color("ffd778"), 3)
		draw_polyline(PackedVector2Array([Vector2(-8, -85), Vector2(0, -94), Vector2(8, -85)]), Color("ffd778"), 3)
	elif _modo == &"arrancada":
		var origem: Vector2 = global_position + Vector2(0, 57)
		var consulta := PhysicsRayQueryParameters2D.create(origem, origem + Vector2(_alcance * _sentido, 0), 1)
		var resultado := get_world_2d().direct_space_state.intersect_ray(consulta)
		var limite: float = origem.distance_to(resultado.position) if not resultado.is_empty() else _alcance
		for x in range(22, int(limite) - 10, 28):
			var centro := Vector2(x * _sentido, 57)
			draw_polyline(PackedVector2Array([centro + Vector2(-8 * _sentido, -5), centro, centro + Vector2(-8 * _sentido, 5)]), Color(0.55, 0.9, 1.0, pulso), 3)
	elif _modo == &"laser":
		draw_line(_inicio_feixe, _fim_feixe, Color(1, 0.23, 0.13, 0.18), 14)
		var comprimento: float = _inicio_feixe.distance_to(_fim_feixe)
		var rumo := (_fim_feixe - _inicio_feixe).normalized()
		for x in range(0, int(comprimento), 24):
			draw_line(_inicio_feixe + rumo * x, _inicio_feixe + rumo * minf(x + 13, comprimento), Color(1, 0.35, 0.2, pulso), 2)
	elif _modo == &"onda":
		var inicio: float = 40 if _sentido > 0 else -40 - _alcance
		var y: float = 58 if _modo == &"laser" else 68
		var altura: float = 14 if _modo == &"laser" else 22
		var cor := Color(1.0, 0.23, 0.13, 0.18) if _modo == &"laser" else Color(1.0, 0.58, 0.2, 0.18)
		draw_rect(Rect2(inicio, y, _alcance, altura), cor)
		cor.a = pulso
		for x in range(0, int(_alcance), 24):
			draw_line(Vector2(inicio + x, y + altura), Vector2(inicio + minf(x + 13, _alcance), y + altura), cor, 2)
