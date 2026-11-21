extends "res://script_inimigo1.gd"
const FOLHA = preload("res://arte/animacoes/obrigatorios/lancamento-v1-alinhado.png")
const CARTAO = preload("res://cena_cartao_sentenca.tscn")
const TEMPOS = [0.12, 0.12, 0.18, 0.12, 0.09, 0.11, 0.12, 0.14]
var _tempo: float = 0.0
var _disparou: bool = false
var _vermelho: bool = false

func _ready() -> void:
	$AnimationPlayer.stop()
	_visual()

func _process(delta: float) -> void:
	velocity.y += 20
	move_and_slide()
	var personagem = ScriptGlobal.personagem
	var valido: bool = is_instance_valid(personagem) and ScriptGlobal.qtd_vidas > 0
	if valido:
		direcao_inimigo = 1 if personagem.global_position.x > global_position.x else -1
	$RayCast2D.force_raycast_update()
	var pode_atirar: bool = valido and is_on_floor() and $RayCast2D.get_collider() == personagem
	if pode_atirar:
		_tempo += delta
		if _tempo >= 0.54 and not _disparou:
			_disparou = true
			atirar_cartao()
		if _tempo >= 1.5:
			_tempo = 0
			_disparou = false
	else:
		_tempo = 0
		_disparou = false
	_visual()

func atirar_cartao() -> void:
	var cartao = CARTAO.instantiate()
	var corpo = cartao.get_node("CharacterBody2D")
	corpo.direcao = direcao_inimigo
	corpo.vermelho = _vermelho
	_vermelho = not _vermelho
	$Marker2D.position.x = absf($Marker2D.position.x) * direcao_inimigo
	get_parent().add_child(cartao)
	cartao.global_position = $Marker2D.global_position
	$SomCartao.play()

func _visual() -> void:
	var restante: float = minf(_tempo, 1.0)
	var quadro: int = 0
	while quadro < 7 and restante + 0.000001 >= TEMPOS[quadro]:
		restante -= TEMPOS[quadro]
		quadro += 1
	$Sprite2D.texture = FOLHA
	$Sprite2D.region_enabled = true
	$Sprite2D.region_rect = Rect2(quadro * 384, 0, 384, 384)
	$Sprite2D.centered = false
	$Sprite2D.offset = Vector2(-192, -360)
	$Sprite2D.position = Vector2(-1, 63)
	$Sprite2D.flip_h = false
	$Sprite2D.scale = Vector2(-0.53 * direcao_inimigo, 0.53)
