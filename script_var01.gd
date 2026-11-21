extends "res://script_chefao.gd"
## Mantém corpo, gravidade, resistência e abertura do portão do chefe original.
enum Estado { AVANCO, CARGA, LASER, GOLPE, ONDA, RECUPERACAO, ATORDOADO }
const VISUAL_AVANCO = preload("res://arte/animacoes/var-01/avanco-v1-alinhado.png")
const VISUAL_GOLPE = preload("res://arte/animacoes/var-01/golpe-v1-alinhado.png")
const VISUAL_PARADO = preload("res://arte/animacoes/var-01/parado-v1.png")
const TEMPOS_AVANCO = [0.14, 0.12, 0.11, 0.12, 0.14, 0.12, 0.11, 0.12]
const TEMPOS_GOLPE = [0.15, 0.15, 0.15, 0.15, 0.10, 0.12, 0.20, 0.18]
@export var alcance_laser: float = 480.0
@export var tempo_carga: float = 1.1
var _estado: Estado = Estado.AVANCO
var _tempo: float = 0.0
var _direcao_ataque: int = -1
var _proximo_laser: bool = true
var _atingiu: bool = false
var _comprimento: float = 0.0
var _tempo_caminhada: float = 0.0
var _recuperando_golpe: bool = false
const OLHO_FONTE := Vector2(183, 80)
var _mira_laser := Vector2.ZERO
var _fim_laser := Vector2.ZERO

func _ready() -> void:
	var sinal := Node2D.new()
	sinal.name = "SinalAtaque"
	sinal.set_script(preload("res://script_sinal_ataque.gd"))
	sinal.tipo = sinal.Tipo.VAR
	add_child(sinal)
	$Timer.stop()
	$AnimationPlayer.stop()
	velocidade = 100
	direcao = -1
	_visual()

func _alvo_valido() -> bool:
	return esta_na_tela and is_instance_valid(ScriptGlobal.personagem) and ScriptGlobal.qtd_vidas > 0 and not $Resistencia.derrotado

func _mudar(novo: Estado) -> void:
	if novo == Estado.CARGA:
		_capturar_mira()
	if novo != Estado.CARGA:
		$SomCarga.stop()
	elif _estado != Estado.CARGA:
		$SomCarga.play()
	if novo == Estado.ATORDOADO and _estado != Estado.ATORDOADO:
		preload("res://script_sons_identidade.gd").tocar(self, preload("res://script_sons_identidade.gd").PANE, -10)
	_recuperando_golpe = novo == Estado.RECUPERACAO and _estado == Estado.ONDA
	_estado = novo
	_tempo = 0.0
	_atingiu = false
	_tempo_caminhada = 0.0
	if novo == Estado.CARGA or novo == Estado.LASER:
		_atualizar_laser()

func _process(delta: float) -> void:
	velocity.y += gravidade
	velocity.x = 0
	if not _alvo_valido() or not is_on_floor():
		_mudar(Estado.AVANCO)
	else:
		_tempo += delta
		match _estado:
			Estado.AVANCO:
				var distancia: float = ScriptGlobal.personagem.global_position.x - global_position.x
				if absf(distancia) > 4:
					direcao = 1 if distancia > 0 else -1
				if absf(distancia) > 180:
					velocity.x = velocidade * direcao
				if _tempo >= 0.9 and absf(distancia) <= alcance_laser:
					_direcao_ataque = direcao
					_mudar(Estado.CARGA if _proximo_laser else Estado.GOLPE)
					_proximo_laser = not _proximo_laser
			Estado.CARGA:
				if _tempo < tempo_carga * 0.55:
					_capturar_mira()
				_atualizar_laser()
				if _tempo >= tempo_carga:
					_mudar(Estado.LASER)
					$SomAtaque.stream = preload("res://Sons/Identidade/var-laser.wav")
					$SomAtaque.play()
			Estado.LASER:
				_atualizar_laser()
				_tentar_atingir_laser()
				if _tempo >= 0.25:
					_mudar(Estado.RECUPERACAO)
			Estado.GOLPE:
				if _tempo >= 0.6:
					_mudar(Estado.ONDA)
					$SomAtaque.stream = preload("res://Sons/Identidade/var-impacto.wav")
					$SomAtaque.play()
			Estado.ONDA:
				var alcance: float = _alcance_sem_parede(minf(220, 35 + _tempo * 500), 78)
				# Frente da onda, não uma área invisível que cobre a tela inteira.
				var frente := _faixa(alcance, 68, 22)
				frente.size.x = minf(40, alcance)
				if _direcao_ataque > 0:
					frente.position.x += maxf(0, alcance - 40)
				_tentar_atingir(frente)
				if _tempo >= 0.45:
					_mudar(Estado.RECUPERACAO)
			Estado.RECUPERACAO, Estado.ATORDOADO:
				if _tempo >= (1.0 if _estado == Estado.ATORDOADO else 0.9):
					_mudar(Estado.AVANCO)
	move_and_slide()
	_visual(delta)
	if _estado == Estado.CARGA or _estado == Estado.LASER:
		_atualizar_laser()
	queue_redraw()

func _olho_global() -> Vector2:
	return $Sprite2D.to_global($Sprite2D.offset + OLHO_FONTE)

func _capturar_mira() -> void:
	var olho := _olho_global()
	if is_instance_valid(ScriptGlobal.personagem):
		var alvo: Vector2 = ScriptGlobal.personagem.get_node("CollisionShape2D").global_position
		if (alvo.x - olho.x) * _direcao_ataque > 20:
			_mira_laser = alvo
			return
	_mira_laser = olho + Vector2(alcance_laser * _direcao_ataque, 95)

func _atualizar_laser() -> void:
	var inicio := _olho_global()
	var rumo := (_mira_laser - inicio).normalized()
	if rumo.is_zero_approx():
		rumo = Vector2(_direcao_ataque, 0)
	var destino := inicio + rumo * alcance_laser
	var consulta := PhysicsRayQueryParameters2D.create(inicio, destino, 1)
	var resultado := get_world_2d().direct_space_state.intersect_ray(consulta)
	_fim_laser = resultado.position if not resultado.is_empty() else destino
	_comprimento = inicio.distance_to(_fim_laser)

func segmento_laser() -> PackedVector2Array:
	return PackedVector2Array([_olho_global(), _fim_laser])

func _tentar_atingir_laser() -> void:
	if _atingiu or not _alvo_valido():
		return
	var colisao = ScriptGlobal.personagem.get_node("CollisionShape2D")
	var tamanho: Vector2 = colisao.shape.size * colisao.global_scale.abs()
	var caixa := Rect2(colisao.global_position - tamanho / 2, tamanho).grow(7)
	var inicio := _olho_global()
	var acerto: bool = caixa.has_point(inicio) or caixa.has_point(_fim_laser)
	var cantos := [caixa.position, Vector2(caixa.end.x, caixa.position.y), caixa.end, Vector2(caixa.position.x, caixa.end.y)]
	for i in range(4):
		if Geometry2D.segment_intersects_segment(inicio, _fim_laser, cantos[i], cantos[(i + 1) % 4]) != null:
			acerto = true
	if acerto:
		_atingiu = true
		ScriptGlobal.personagem.receber_dano()

func _faixa(comprimento: float, y: float, altura: float) -> Rect2:
	var inicio: float = 40 if _direcao_ataque > 0 else -40 - comprimento
	return Rect2(global_position + Vector2(inicio, y), Vector2(comprimento, altura))

func _alcance_sem_parede(limite: float, y: float) -> float:
	var inicio := global_position + Vector2(40 * _direcao_ataque, y)
	var consulta := PhysicsRayQueryParameters2D.create(inicio, inicio + Vector2(limite * _direcao_ataque, 0), 1)
	var resultado := get_world_2d().direct_space_state.intersect_ray(consulta)
	return inicio.distance_to(resultado.position) if not resultado.is_empty() else limite

func _tentar_atingir(faixa: Rect2) -> void:
	if _atingiu or not _alvo_valido():
		return
	var colisao = ScriptGlobal.personagem.get_node("CollisionShape2D")
	var tamanho: Vector2 = colisao.shape.size * colisao.global_scale.abs()
	var corpo := Rect2(colisao.global_position - tamanho / 2, tamanho)
	if faixa.intersects(corpo):
		_atingiu = true
		ScriptGlobal.personagem.receber_dano()

func receber_bola(quantidade: int, _ponto: Vector2) -> void:
	if process_mode == Node.PROCESS_MODE_DISABLED or not can_process():
		return
	var interromper: bool = _estado == Estado.CARGA and quantidade > 0
	super.receber_dano(quantidade)
	if interromper and not $Resistencia.derrotado:
		_mudar(Estado.ATORDOADO)
		_visual()
		queue_redraw()

func _quadro_no_tempo(tempo: float, duracoes: Array) -> int:
	var quadro: int = 0
	while quadro < duracoes.size() - 1 and tempo + 0.000001 >= duracoes[quadro]:
		tempo -= duracoes[quadro]
		quadro += 1
	return quadro

func _visual(delta: float = 0.0) -> void:
	var textura: Texture2D = VISUAL_PARADO
	var quadro: int = 0
	if _estado == Estado.GOLPE or _estado == Estado.ONDA or _recuperando_golpe:
		textura = VISUAL_GOLPE
		var tempo_golpe: float = _tempo
		if _estado == Estado.ONDA:
			tempo_golpe += 0.6
		elif _recuperando_golpe:
			tempo_golpe += 1.05
		# Não repetir a preparação ao trocar de estado nem repetir o impacto.
		quadro = _quadro_no_tempo(tempo_golpe, TEMPOS_GOLPE)
	elif _estado == Estado.AVANCO and not is_zero_approx(velocity.x):
		textura = VISUAL_AVANCO
		_tempo_caminhada = fmod(_tempo_caminhada + delta, 0.98)
		quadro = _quadro_no_tempo(_tempo_caminhada, TEMPOS_AVANCO)
	else:
		_tempo_caminhada = 0.0
	$Sprite2D.texture = textura
	$Sprite2D.region_enabled = true
	$Sprite2D.region_rect = Rect2(quadro * 384, 0, 384, 384)
	$Sprite2D.offset = Vector2(-192, -360)
	$Sprite2D.flip_h = false
	$Sprite2D.scale = Vector2(-0.6 * direcao, 0.6)
	$Sprite2D.position.y = 90
	$Sprite2D.position.x = -7
	if _estado == Estado.LASER:
		$Sprite2D.position.x -= _direcao_ataque * sin(clampf(_tempo / 0.25, 0, 1) * PI) * 4

func _draw() -> void:
	var sinal := _direcao_ataque
	if _estado == Estado.CARGA or _estado == Estado.LASER:
		var inicio := to_local(_olho_global())
		var fim := to_local(_fim_laser)
		draw_line(inicio, fim, Color("ff3030"), 14 if _estado == Estado.LASER else 1)
		if _estado == Estado.LASER:
			draw_line(inicio, fim, Color("ffe0ce"), 4)
			draw_circle(inicio, 11, Color(1, 0.15, 0.05, 0.5))
			draw_circle(inicio, 5, Color("fff1ca"))
			for i in range(6):
				var raio := Vector2.from_angle(i * TAU / 6)
				draw_line(inicio + raio * 12, inicio + raio * 22, Color("ffba70"), 2)
		else:
			var progresso: float = clampf(_tempo / tempo_carga, 0, 1)
			draw_arc(inicio, 24 - progresso * 16, 0, TAU, 16, Color("ffd34d"), 2)
			draw_circle(inicio, 2 + progresso * 4, Color(1, 0.3, 0.15, 0.8))
	elif _estado == Estado.GOLPE:
		draw_line(Vector2(40 * sinal, 88), Vector2(260 * sinal, 88), Color("ff6d44"), 2)
	elif _estado == Estado.ONDA:
		var alcance: float = _alcance_sem_parede(minf(220, 35 + _tempo * 500), 78)
		draw_arc(Vector2((40 + alcance) * sinal, 90), 22, PI, TAU, 16, Color("ff9c52"), 4)
	elif _estado == Estado.ATORDOADO:
		for i in range(4):
			draw_line(Vector2(-20, -77 + i * 6), Vector2(20, -77 + i * 6), Color("bce6ed"), 2)
	else:
		# Proteção parcial do monitor; o cartão continua sempre vulnerável.
		draw_rect(Rect2(-23, -81, 46, 8), Color("53555d"))

func parado() -> void:
	pass

func atacar() -> void:
	pass

func voltar_andar() -> void:
	pass

func causar_dano_personagem() -> void:
	# O dano agora é aplicado apenas pela geometria visível de cada ataque.
	pass
