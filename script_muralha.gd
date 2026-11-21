extends "res://script_inimigo2.gd"
const CORRIDA = preload("res://arte/animacoes/obrigatorios/corrida-v1-alinhado.png")
const SALTO = preload("res://arte/animacoes/obrigatorios/salto-v1-alinhado.png")
var _tempo_visual: float = 0.0
var _pouso: float = 0.0
var _estava_no_ar: bool = false
var _contato_agendado: bool = false
var _intervalo_contato: float = 0.0

func _ready() -> void:
	var sinal := Node2D.new()
	sinal.name = "SinalAtaque"
	sinal.set_script(preload("res://script_sinal_ataque.gd"))
	sinal.tipo = sinal.Tipo.GOLEIRO
	add_child(sinal)
	velocidade = 0
	$AnimationPlayer.stop()
	# Área própria: não herdar as chaves de colisão das animações antigas.
	var forma := RectangleShape2D.new()
	forma.size = Vector2(80, 110)
	$Area2D/CollisionShape2D.shape = forma
	$Area2D/CollisionShape2D.position = Vector2(-2.5, -4)
	$Area2D/CollisionShape2D.disabled = false
	_visual(0)

func _process(delta: float) -> void:
	_intervalo_contato = maxf(0.0, _intervalo_contato - delta)
	if not is_instance_valid(ScriptGlobal.personagem) or ScriptGlobal.qtd_vidas <= 0:
		velocidade = 0
		velocity.x = 0
		velocity.y += gravidade
		move_and_slide()
	else:
		# Mantém a perseguição e o salto existentes, sem tocar nas animações legadas.
		velocity.y += gravidade
		if is_on_floor() and velocidade > 0:
			direcao_inimigo2 = 1 if global_position.x < ScriptGlobal.personagem.global_position.x else -1
			$RayCast2D.target_position.x = absf($RayCast2D.target_position.x) * direcao_inimigo2
			$RayCast2D.force_raycast_update()
			if $RayCast2D.get_collider() == ScriptGlobal.personagem:
				velocity.y = -forcao_pulo
		velocity.x = velocidade * direcao_inimigo2
		move_and_slide()
	$AnimationPlayer.stop()
	_visual(delta)
	for corpo in $Area2D.get_overlapping_bodies():
		causar_dano_personagem(corpo)

func _visual(delta: float) -> void:
	_tempo_visual += delta
	var no_ar: bool = not is_on_floor()
	if not _estava_no_ar and no_ar and velocity.y < 0:
		preload("res://script_sons_identidade.gd").tocar(self, preload("res://script_sons_identidade.gd").SALTO, -13)
	if _estava_no_ar and not no_ar:
		_pouso = 0.24
	_estava_no_ar = no_ar
	var quadro: int = 0
	var textura: Texture2D = SALTO
	if no_ar:
		quadro = 3 if velocity.y < -70 else 4 if velocity.y < 60 else 5
	elif _pouso > 0:
		_pouso = maxf(0, _pouso - delta)
		quadro = 6 if _pouso > 0.12 else 7
	elif not is_zero_approx(velocity.x):
		textura = CORRIDA
		quadro = int(_tempo_visual / 0.09) % 8
	$Sprite2D.texture = textura
	$Sprite2D.region_enabled = true
	$Sprite2D.region_rect = Rect2(quadro * 384, 0, 384, 384)
	$Sprite2D.centered = false
	$Sprite2D.offset = Vector2(-192, -360)
	$Sprite2D.position = Vector2(-2.5, 61)
	$Sprite2D.flip_h = false
	$Sprite2D.scale = Vector2(-0.48 * direcao_inimigo2, 0.48)

func causar_dano_personagem(body: Node2D) -> void:
	if not _contato_agendado and _intervalo_contato <= 0 and not $Resistencia.derrotado and body == ScriptGlobal.personagem and ScriptGlobal.qtd_vidas > 0 and velocidade > 0:
		_contato_agendado = true
		call_deferred("_aplicar_contato", body)

func _aplicar_contato(body: Node2D) -> void:
	_contato_agendado = false
	if is_instance_valid(body) and body == ScriptGlobal.personagem and ScriptGlobal.qtd_vidas > 0 and velocidade > 0 and not $Resistencia.derrotado and $Area2D.overlaps_body(body):
		_intervalo_contato = 0.9
		super.causar_dano_personagem(body)
