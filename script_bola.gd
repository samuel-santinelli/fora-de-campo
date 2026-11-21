extends CharacterBody2D

var direcao    = 1 #  1 => Direita, -1 => Esquerda
var velocidade = 350
var dano: int = 1
var _tempo_vida: float = 0.0
const EFEITO = preload("res://script_energia_bola.gd")

func _process(delta: float) -> void:
	_tempo_vida += delta
	if _tempo_vida >= 6.0:
		get_parent().queue_free()
		return
	velocity.x = velocidade * direcao
	velocity.y = 0
	$Energia.direcao = direcao
	$Energia.fogo = dano > 1
	$Sprite2D.rotation += delta * 12.0 * direcao
	# O mesmo RayCast agora acompanha a direção e o próximo deslocamento.
	$RayCast2D.target_position = Vector2(direcao * maxf(10.0, velocidade * delta + 9.0), 0)
	$RayCast2D.force_raycast_update()
	
	if ($RayCast2D.is_colliding()):
		var alvo = $RayCast2D.get_collider()
		var efeito = EFEITO.new()
		efeito.impacto = true
		efeito.fogo = dano > 1
		get_parent().get_parent().add_child(efeito)
		efeito.global_position = $RayCast2D.get_collision_point()
		if alvo is StaticBody2D and (alvo.collision_layer & 1) != 0:
			# Cenário sólido bloqueia o chute e nunca pode ser destruído.
			pass
		elif alvo.has_method("receber_bola"):
			alvo.receber_bola(dano, $RayCast2D.get_collision_point())
		elif alvo.has_method("receber_dano"):
			alvo.receber_dano(dano)
		else:
			if alvo.name == "Chefao" and is_instance_valid(ScriptGlobal.portao):
				ScriptGlobal.portao.get_node("AnimationPlayer").play("abrir")
			alvo.queue_free()
		get_parent().queue_free()
		return
	
	move_and_slide()
	
