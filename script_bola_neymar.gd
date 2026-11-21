extends "res://script_cartao.gd"
## Reutiliza deslocamento e dano do cartão; não altera a arbitragem.

var _tempo_vida: float = 0.0
var _consumida: bool = false

func _ready() -> void:
	velocidade = 360
	$AnimationPlayer.stop()

func _process(delta: float) -> void:
	_tempo_vida += delta
	if _consumida:
		return
	if _tempo_vida >= 3.0 or ScriptGlobal.qtd_vidas <= 0 or not is_instance_valid(ScriptGlobal.personagem):
		_consumir()
		return
	$RayCast2D.target_position = Vector2(direcao * (velocidade * delta + 9.0), 0)
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		_consumir()
		return
	$Sprite2D.rotation += delta * 12.0 * direcao
	super._process(delta)

func _consumir() -> void:
	_consumida = true
	get_parent().queue_free()

func causar_dano_personagem(body: Node2D) -> void:
	if not _consumida and body == ScriptGlobal.personagem and ScriptGlobal.qtd_vidas > 0:
		_consumida = true
		# A reação do jogador pode encerrar animações que alteram colisões.
		# Aplicar fora do sinal físico para não modificar formas durante queries.
		call_deferred("_aplicar_dano", body)

func _aplicar_dano(body: Node2D) -> void:
	if is_instance_valid(body) and body == ScriptGlobal.personagem and ScriptGlobal.qtd_vidas > 0:
		super.causar_dano_personagem(body)
	else:
		_consumir()
