extends "res://script_inimigo2.gd"
## Variante terrestre do perseguidor: mantém corpo, gravidade e dano existentes.

enum Estado { PERSEGUINDO, AVISANDO, ARRANCANDO, RECUPERANDO }

const CORRIDA = preload("res://arte/animacoes/mbappe/corrida-v1-alinhada.png")
const PARADO = preload("res://arte/animacoes/mbappe/parado-v1.png")
const TEMPOS = [0.075, 0.065, 0.060, 0.065, 0.075, 0.065, 0.060, 0.065]

@export var velocidade_perseguicao: float = 380.0
@export var velocidade_arrancada: float = 720.0
@export var velocidade_recuperacao: float = 90.0
@export var alcance_perseguicao: float = 560.0
@export var tempo_perseguicao: float = 1.2
@export var tempo_aviso: float = 0.24
@export var tempo_arrancada: float = 0.35
@export var tempo_recuperacao: float = 0.8

var _ativo: bool = false
var _estado: Estado = Estado.PERSEGUINDO
var _tempo_estado: float = 0.0
var _direcao_arrancada: int = -1
var _quadro: int = 0
var _tempo_quadro: float = 0.0

func _ready() -> void:
	var sinal := Node2D.new()
	sinal.name = "SinalAtaque"
	sinal.set_script(preload("res://script_sinal_ataque.gd"))
	sinal.tipo = sinal.Tipo.MBAPPE
	add_child(sinal)
	direcao_inimigo2 = -1
	velocidade = 0
	forcao_pulo = 0
	$AnimationPlayer.stop()
	$Area2D.monitoring = false
	move_child($EfeitoArrancada, 0)
	_atualizar_visual(0.0)

func _process(delta: float) -> void:
	velocity.y += gravidade
	velocity.x = 0.0
	var personagem = ScriptGlobal.personagem
	var pode_perseguir: bool = (
		_ativo and is_instance_valid(personagem) and ScriptGlobal.qtd_vidas > 0
		and not $Resistencia.derrotado
	)
	if pode_perseguir:
		pode_perseguir = absf(personagem.global_position.x - global_position.x) <= alcance_perseguicao
	if pode_perseguir and is_on_floor():
		_atualizar_perseguicao(delta, personagem.global_position.x)
	else:
		velocidade = 0
		_mudar_estado(Estado.PERSEGUINDO)
		_tempo_estado = 0.0
	var pode_atingir: bool = pode_perseguir and is_on_floor() and _estado in [Estado.PERSEGUINDO, Estado.ARRANCANDO]
	if $Area2D.monitoring != pode_atingir:
		$Area2D.set_deferred("monitoring", pode_atingir)
	move_and_slide()
	_atualizar_visual(delta)

func _atualizar_perseguicao(delta: float, alvo_x: float) -> void:
	_tempo_estado += delta
	match _estado:
		Estado.PERSEGUINDO:
			_apontar_para(alvo_x)
			if _tempo_estado >= tempo_perseguicao:
				_direcao_arrancada = direcao_inimigo2
				_mudar_estado(Estado.AVISANDO)
		Estado.AVISANDO:
			direcao_inimigo2 = _direcao_arrancada
			if _tempo_estado >= tempo_aviso:
				_mudar_estado(Estado.ARRANCANDO)
		Estado.ARRANCANDO:
			direcao_inimigo2 = _direcao_arrancada
			if _tempo_estado >= tempo_arrancada or is_on_wall():
				_mudar_estado(Estado.RECUPERANDO)
		Estado.RECUPERANDO:
			_apontar_para(alvo_x)
			if _tempo_estado >= tempo_recuperacao:
				_mudar_estado(Estado.PERSEGUINDO)
	match _estado:
		Estado.PERSEGUINDO:
			velocidade = velocidade_perseguicao
		Estado.AVISANDO:
			velocidade = 0
		Estado.ARRANCANDO:
			velocidade = velocidade_arrancada
		Estado.RECUPERANDO:
			velocidade = velocidade_recuperacao if absf(alvo_x - global_position.x) > 55.0 else 0.0
	velocity.x = velocidade * direcao_inimigo2

func _apontar_para(alvo_x: float) -> void:
	if absf(alvo_x - global_position.x) > 4.0:
		direcao_inimigo2 = 1 if alvo_x > global_position.x else -1

func _mudar_estado(novo: Estado) -> void:
	if novo == _estado:
		return
	_estado = novo
	if novo == Estado.ARRANCANDO and not has_node("SomAtaque"):
		preload("res://script_sons_identidade.gd").tocar(self, preload("res://script_sons_identidade.gd").ARRANCADA, -12)
	_tempo_estado = 0.0
	_quadro = 0
	_tempo_quadro = 0.0

func _atualizar_visual(delta: float) -> void:
	var correndo: bool = not is_zero_approx(velocity.x)
	var cadencia: float = 1.65 if _estado == Estado.ARRANCANDO else 0.55 if _estado == Estado.RECUPERANDO else 1.0
	if correndo:
		_tempo_quadro += delta * cadencia
		while _tempo_quadro >= TEMPOS[_quadro]:
			_tempo_quadro -= TEMPOS[_quadro]
			_quadro = (_quadro + 1) % TEMPOS.size()
	else:
		_quadro = 0
		_tempo_quadro = 0.0
	$Sprite2D.texture = CORRIDA if correndo else PARADO
	$Sprite2D.region_rect = Rect2(_quadro * 256 if correndo else 0, 0, 256, 256)
	# A folha é voltada para a esquerda; espelhar em torno da âncora dos pés.
	$Sprite2D.flip_h = false
	$Sprite2D.scale = Vector2(-0.5 * direcao_inimigo2, 0.5)
	$EfeitoArrancada.atualizar(_estado == Estado.ARRANCANDO and correndo, _estado == Estado.AVISANDO, direcao_inimigo2, _tempo_estado)

func perseguir() -> void:
	_ativo = true

func encerrar_perseguicao() -> void:
	_ativo = false
	velocidade = 0
	_tempo_estado = 0.0
	_mudar_estado(Estado.PERSEGUINDO)

func receber_dano(quantidade: int = 1) -> void:
	super.receber_dano(quantidade)
	if quantidade > 0 and not $Resistencia.derrotado:
		_mudar_estado(Estado.RECUPERANDO)

func causar_dano_personagem(body: Node2D) -> void:
	if _ativo and _estado in [Estado.PERSEGUINDO, Estado.ARRANCANDO] and not $Resistencia.derrotado:
		if body == ScriptGlobal.personagem and ScriptGlobal.qtd_vidas > 0:
			super.causar_dano_personagem(body)
