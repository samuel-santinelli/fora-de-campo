extends "res://script_inimigo2.gd"
## Tanque terrestre: reutiliza corpo, gravidade, contato e resistência da base.

const AVANCO = preload("res://arte/animacoes/haaland/avanco-v1-alinhado.png")
const PARADO = preload("res://arte/animacoes/haaland/parado-v1.png")
const OMBRADA = preload("res://arte/animacoes/haaland/ataque-ombrada-v1.png")
const DURACAO_TRANCO: float = 0.72
const TEMPOS = [0.13, 0.12, 0.11, 0.12, 0.13, 0.12, 0.11, 0.12]

@export var velocidade_avanco: float = 180.0
@export var alcance_perseguicao: float = 560.0
@export var tempo_reacao_dano: float = 0.25

var _ativo: bool = false
var _reacao_restante: float = 0.0
var _quadro: int = 0
var _tempo_quadro: float = 0.0
var _tempo_passo: float = 0.0
var _tempo_tranco: float = 0.0
var _direcao_tranco: int = -1

func _ready() -> void:
	floor_snap_length = 10.0
	floor_constant_speed = true
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
	_tempo_passo = maxf(0, _tempo_passo - delta)
	_tempo_tranco = maxf(0, _tempo_tranco - delta)
	_reacao_restante = maxf(0.0, _reacao_restante - delta)
	velocity.y += gravidade
	velocity.x = 0.0
	velocidade = 0
	var pode_avancar: bool = _pode_perseguir() and is_on_floor() and _reacao_restante <= 0.0 and _tempo_tranco <= 0
	if pode_avancar:
		var distancia: float = ScriptGlobal.personagem.global_position.x - global_position.x
		if absf(distancia) > 4.0:
			direcao_inimigo2 = 1 if distancia > 0 else -1
			velocidade = velocidade_avanco
			velocity.x = velocidade * direcao_inimigo2
			if _tempo_passo <= 0:
				preload("res://script_sons_identidade.gd").tocar(self, preload("res://script_sons_identidade.gd").PASSO, -14)
				_tempo_passo = 0.6
	if $Area2D.monitoring != pode_avancar:
		$Area2D.set_deferred("monitoring", pode_avancar)
	move_and_slide()
	_atualizar_visual(delta)
	queue_redraw()
	# Contato persistente também deve voltar a atacar após a recuperação.
	if _tempo_tranco <= 0 and _pode_perseguir() and $Area2D.monitoring:
		for corpo in $Area2D.get_overlapping_bodies():
			causar_dano_personagem(corpo)

func _atualizar_visual(delta: float) -> void:
	var avancando: bool = not is_zero_approx(velocity.x)
	if avancando:
		_tempo_quadro += delta
		while _tempo_quadro >= TEMPOS[_quadro]:
			_tempo_quadro -= TEMPOS[_quadro]
			_quadro = (_quadro + 1) % TEMPOS.size()
	else:
		_quadro = 0
		_tempo_quadro = 0.0
	$Sprite2D.texture = AVANCO if avancando else PARADO
	$Sprite2D.region_rect = Rect2(_quadro * 320 if avancando else 0, 0, 320, 320)
	$Sprite2D.flip_h = false
	# A folha já foi exportada 20% maior; não multiplicar outra vez por 1,2.
	$Sprite2D.scale = Vector2(-0.5 * direcao_inimigo2, 0.5)
	$Sprite2D.rotation = 0
	$Sprite2D.position = Vector2(0, 61)
	$Sprite2D.offset = Vector2(-140, -300)
	if _tempo_tranco > 0:
		var progresso: float = 1 - _tempo_tranco / DURACAO_TRANCO
		var quadro_ataque: int = mini(5, int(progresso * 6))
		var celula := Vector2(OMBRADA.get_width() / 3.0, OMBRADA.get_height() / 2.0)
		$Sprite2D.texture = OMBRADA
		$Sprite2D.region_rect = Rect2(Vector2((quadro_ataque % 3) * celula.x, floori(quadro_ataque / 3.0) * celula.y), celula)
		$Sprite2D.offset = Vector2(-celula.x / 2, celula.y * -0.9375)
		$Sprite2D.scale = Vector2(-_direcao_tranco, 1) * (160.0 / celula.x)
		$Sprite2D.rotation = sin(progresso * PI) * 0.13 * _direcao_tranco
		$Sprite2D.position.x = sin(progresso * PI) * 15 * _direcao_tranco

func perseguir() -> void:
	_ativo = true

func encerrar_perseguicao() -> void:
	_ativo = false
	velocidade = 0
	velocity.x = 0.0

func receber_dano(quantidade: int = 1) -> void:
	if quantidade > 0:
		_tempo_tranco = 0
	super.receber_dano(quantidade)
	if quantidade > 0 and not $Resistencia.derrotado:
		_reacao_restante = tempo_reacao_dano
		velocidade = 0
		velocity.x = 0.0
		$Area2D.set_deferred("monitoring", false)
		_atualizar_visual(0.0)

func causar_dano_personagem(body: Node2D) -> void:
	if body == ScriptGlobal.personagem and _pode_perseguir() and is_on_floor() and _reacao_restante <= 0.0:
		if _tempo_tranco > 0:
			return
		_tempo_tranco = DURACAO_TRANCO
		_direcao_tranco = direcao_inimigo2
		_atualizar_visual(0)
		super.causar_dano_personagem(body)

func _draw() -> void:
	if _tempo_tranco > 0.28 and _tempo_tranco < 0.55:
		var ponto := Vector2(40 * _direcao_tranco, -8)
		for i in range(5):
			var raio := Vector2.from_angle(-PI / 2 + i * PI / 4) * Vector2(_direcao_tranco, 1)
			draw_line(ponto + raio * 8, ponto + raio * 22, Color("f2d38c"), 3)
