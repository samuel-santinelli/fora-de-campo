extends "res://script_mbappe.gd"
## Reutiliza o ciclo de perseguição/aviso/investida/recuperação do Mbappé.

const AVANCO_GUARDIAO = preload("res://arte/animacoes/impedimento/avanco-v1-alinhado.png")
const AVISO_GUARDIAO = preload("res://arte/animacoes/impedimento/aviso-v1-alinhado.png")
const PARADO_GUARDIAO = preload("res://arte/animacoes/impedimento/parado-v1.png")
const SINALIZADOR = preload("res://cena_sinalizador_impedimento.tscn")
const TEMPOS_AVANCO = [0.11, 0.095, 0.09, 0.095, 0.11, 0.095, 0.09, 0.095]
const TEMPOS_AVISO = [0.07, 0.07, 0.08, 0.11, 0.18, 0.11, 0.10, 0.08]

var _ataque_sinalizador: bool = true
var _contato_agendado: bool = false

func _mudar_estado(novo: Estado) -> void:
	if novo == Estado.AVISANDO and novo != _estado:
		_ataque_sinalizador = not _ataque_sinalizador
	super._mudar_estado(novo)

func _atualizar_perseguicao(delta: float, alvo_x: float) -> void:
	var anterior: Estado = _estado
	super._atualizar_perseguicao(delta, alvo_x)
	if anterior == Estado.AVISANDO and _estado == Estado.ARRANCANDO and _ataque_sinalizador:
		var sinal = SINALIZADOR.instantiate()
		sinal.get_node("CharacterBody2D").direcao = _direcao_arrancada
		$Marker2D.position.x = absf($Marker2D.position.x) * _direcao_arrancada
		get_parent().add_child(sinal)
		sinal.global_position = $Marker2D.global_position
		$SomAtaque.play()
		_mudar_estado(Estado.RECUPERANDO)
		velocidade = 0
		velocity.x = 0.0
	elif anterior == Estado.AVISANDO and _estado == Estado.ARRANCANDO:
		$SomAtaque.play()

func _atualizar_visual(delta: float) -> void:
	var textura: Texture2D = PARADO_GUARDIAO
	if _estado == Estado.AVISANDO:
		textura = AVISO_GUARDIAO
		var restante: float = _tempo_estado
		_quadro = 0
		while _quadro < 7 and restante >= TEMPOS_AVISO[_quadro]:
			restante -= TEMPOS_AVISO[_quadro]
			_quadro += 1
	elif not is_zero_approx(velocity.x):
		textura = AVANCO_GUARDIAO
		_tempo_quadro += delta * (2.3 if _estado == Estado.ARRANCANDO else 1.0)
		while _tempo_quadro >= TEMPOS_AVANCO[_quadro]:
			_tempo_quadro -= TEMPOS_AVANCO[_quadro]
			_quadro = (_quadro + 1) % 8
	else:
		_quadro = 0
		_tempo_quadro = 0.0
	$Sprite2D.texture = textura
	$Sprite2D.region_rect = Rect2(_quadro * 384 if textura != PARADO_GUARDIAO else 0, 0, 384, 384)
	$Sprite2D.flip_h = false
	$Sprite2D.scale = Vector2(-0.5 * direcao_inimigo2, 0.5)
	$EfeitoArrancada.hide()
	queue_redraw()

func _draw() -> void:
	if _estado == Estado.AVISANDO:
		# Distinguir aviso de tiro do aviso de investida, além da mesma bandeira.
		var cor := Color("ffbf26")
		if _ataque_sinalizador:
			draw_circle(Vector2(0, -87), 5.0, cor)
		else:
			draw_line(Vector2(-7, -87), Vector2(7, -87), cor, 3.0)
	if _estado == Estado.ARRANCANDO:
		for i in range(4):
			var ponto := Vector2(-(35 + 12 * i) * direcao_inimigo2, 43 + (i % 2) * 5)
			draw_line(ponto, ponto - Vector2(18 * direcao_inimigo2, 0), Color("ffc52b"), 2.0)

func _pode_atingir(body: Node2D) -> bool:
	return (
		is_instance_valid(body) and body == ScriptGlobal.personagem and _ativo
		and ScriptGlobal.qtd_vidas > 0 and not $Resistencia.derrotado and is_on_floor()
		and _estado in [Estado.PERSEGUINDO, Estado.ARRANCANDO]
		and absf(body.global_position.x - global_position.x) <= alcance_perseguicao
	)

func causar_dano_personagem(body: Node2D) -> void:
	if not _contato_agendado and _pode_atingir(body):
		_contato_agendado = true
		call_deferred("_aplicar_contato", body)

func _aplicar_contato(body: Node2D) -> void:
	_contato_agendado = false
	if _pode_atingir(body):
		super.causar_dano_personagem(body)
