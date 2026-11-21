extends "res://script_inimigo2.gd"
## Variante terrestre: finta legível e disparo com o projétil inimigo existente.

enum Estado { AVANCANDO, FINTANDO, RECUPERANDO }
const CORRIDA = preload("res://arte/animacoes/neymar/corrida-v1-alinhada.png")
const FINTA = preload("res://arte/animacoes/neymar/finta-v1-alinhada.png")
const PARADO = preload("res://arte/animacoes/neymar/parado-v1.png")
const BOLA = preload("res://cena_bola_neymar.tscn")
const TEMPOS_CORRIDA = [0.085, 0.075, 0.065, 0.075, 0.085, 0.075, 0.065, 0.075]
const TEMPOS_FINTA = [0.09, 0.10, 0.11, 0.16, 0.09, 0.08, 0.11, 0.14]

@export var velocidade_avanco: float = 260.0
@export var alcance_perseguicao: float = 560.0
@export var tempo_avanco: float = 0.9
@export var tempo_recuperacao: float = 0.6

var _ativo: bool = false
var _estado: Estado = Estado.AVANCANDO
var _tempo_estado: float = 0.0
var _direcao_finta: int = -1
var _disparou: bool = false
var _quadro: int = 0
var _tempo_quadro: float = 0.0
var _contato_agendado: bool = false

func _ready() -> void:
	direcao_inimigo2 = -1
	velocidade = 0
	forcao_pulo = 0
	$AnimationPlayer.stop()
	$Area2D.monitoring = false
	_atualizar_visual(0.0)

func _pode_perseguir() -> bool:
	return (
		_ativo and is_instance_valid(ScriptGlobal.personagem)
		and ScriptGlobal.qtd_vidas > 0 and not $Resistencia.derrotado
		and absf(ScriptGlobal.personagem.global_position.x - global_position.x) <= alcance_perseguicao
	)

func _process(delta: float) -> void:
	velocity.y += gravidade
	velocity.x = 0.0
	velocidade = 0
	var ativo_no_chao: bool = _pode_perseguir() and is_on_floor()
	if ativo_no_chao:
		_atualizar_ciclo(delta)
	else:
		_mudar_estado(Estado.AVANCANDO)
		_tempo_estado = 0.0
	var pode_atingir: bool = ativo_no_chao and _estado == Estado.AVANCANDO
	if $Area2D.monitoring != pode_atingir:
		$Area2D.set_deferred("monitoring", pode_atingir)
	move_and_slide()
	_atualizar_visual(delta)

func _atualizar_ciclo(delta: float) -> void:
	_tempo_estado += delta
	match _estado:
		Estado.AVANCANDO:
			var distancia: float = ScriptGlobal.personagem.global_position.x - global_position.x
			if absf(distancia) > 4.0:
				direcao_inimigo2 = 1 if distancia > 0 else -1
			if _tempo_estado >= tempo_avanco:
				_direcao_finta = direcao_inimigo2
				_mudar_estado(Estado.FINTANDO)
			elif absf(distancia) > 95.0:
				velocity.x = velocidade_avanco * direcao_inimigo2
		Estado.FINTANDO:
			direcao_inimigo2 = _direcao_finta
			# A pose avança para enganar e recua; não lê o ataque do jogador.
			if _tempo_estado < 0.30:
				velocity.x = 80.0 * _direcao_finta
			elif _tempo_estado >= 0.46 and _tempo_estado < 0.68:
				velocity.x = -160.0 * _direcao_finta
			if _tempo_estado >= 0.74 and not _disparou:
				_disparar_bola()
			if _tempo_estado >= 0.88:
				_mudar_estado(Estado.RECUPERANDO)
		Estado.RECUPERANDO:
			if _tempo_estado >= tempo_recuperacao:
				_mudar_estado(Estado.AVANCANDO)
	velocidade = absf(velocity.x)

func _mudar_estado(novo: Estado) -> void:
	if novo == _estado:
		return
	_estado = novo
	_tempo_estado = 0.0
	_quadro = 0
	_tempo_quadro = 0.0
	_disparou = false

func _disparar_bola() -> void:
	if not _pode_perseguir() or not is_on_floor():
		return
	_disparou = true
	var bola = BOLA.instantiate()
	bola.get_node("CharacterBody2D").direcao = _direcao_finta
	$Marker2D.position.x = absf($Marker2D.position.x) * _direcao_finta
	get_parent().add_child(bola)
	bola.global_position = $Marker2D.global_position
	$SomChute.play()

func _atualizar_visual(delta: float) -> void:
	var textura: Texture2D = PARADO
	if _estado == Estado.FINTANDO:
		textura = FINTA
		var restante: float = _tempo_estado
		_quadro = 0
		while _quadro < 7 and restante >= TEMPOS_FINTA[_quadro]:
			restante -= TEMPOS_FINTA[_quadro]
			_quadro += 1
	elif not is_zero_approx(velocity.x):
		textura = CORRIDA
		_tempo_quadro += delta
		while _tempo_quadro >= TEMPOS_CORRIDA[_quadro]:
			_tempo_quadro -= TEMPOS_CORRIDA[_quadro]
			_quadro = (_quadro + 1) % 8
	else:
		_quadro = 0
		_tempo_quadro = 0.0
	$Sprite2D.texture = textura
	$Sprite2D.region_rect = Rect2(_quadro * 256 if textura != PARADO else 0, 0, 256, 256)
	$Sprite2D.flip_h = false
	$Sprite2D.scale = Vector2(-0.5 * direcao_inimigo2, 0.5)
	queue_redraw()

func _draw() -> void:
	# Aviso perto da chuteira, separado do clarão de dano da Resistencia.
	if _estado == Estado.FINTANDO and _tempo_estado >= 0.46 and not _disparou:
		var ponto := Vector2(40 * _direcao_finta, 43)
		draw_arc(ponto, 12.0, 0, TAU, 16, Color(0.3, 1.0, 0.45), 2.0)
		draw_line(ponto + Vector2(0, -23), ponto + Vector2(0, -17), Color.WHITE, 2.0)

func perseguir() -> void:
	_ativo = true

func encerrar_perseguicao() -> void:
	_ativo = false
	velocity.x = 0.0
	velocidade = 0
	_mudar_estado(Estado.AVANCANDO)
	_tempo_estado = 0.0
	queue_redraw()

func receber_dano(quantidade: int = 1) -> void:
	super.receber_dano(quantidade)
	if quantidade > 0 and not $Resistencia.derrotado:
		_mudar_estado(Estado.RECUPERANDO)
		_tempo_estado = 0.0
		velocity.x = 0.0
		$Area2D.set_deferred("monitoring", false)
		_atualizar_visual(0.0)

func causar_dano_personagem(body: Node2D) -> void:
	if not _contato_agendado and body == ScriptGlobal.personagem and _pode_perseguir() and is_on_floor() and _estado == Estado.AVANCANDO:
		_contato_agendado = true
		call_deferred("_aplicar_contato", body)

func _aplicar_contato(body: Node2D) -> void:
	_contato_agendado = false
	if is_instance_valid(body) and body == ScriptGlobal.personagem and _pode_perseguir() and is_on_floor() and _estado == Estado.AVANCANDO:
		super.causar_dano_personagem(body)
