extends CharacterBody2D
signal acao_realizada(acao: StringName)

var velocidade  = 500
var gravidade   = 30
var forca_pulo  = 800
var direcao     = 1 # 1 para direita, -1 para esquerda
var animando    = false
var _direcao_carrinho: int = 1
var _direcao_chute: int = 1
var _bola_disparada: bool = false
var _alvos_carrinho: Dictionary = {}
var _em_derrota: bool = false
var _game_over_agendado: bool = false
const TEMPO_SUPERCHUTE: float = 1.0
var carregando_chute: bool = false
var carga_chute: float = 0.0
var _dano_chute: int = 1

func _ready() -> void:
	ScriptGlobal.personagem = self
	var impacto := Node.new()
	impacto.name = "ImpactoCamera"
	impacto.set_script(preload("res://script_camera_impacto.gd"))
	add_child(impacto)
	
func _process(delta: float) -> void:
	
	if ScriptGlobal.qtd_vidas <= 0 and not _em_derrota:
		_iniciar_derrota()
	if _em_derrota:
		_processar_derrota(delta)
		return
	if global_position.y > 1100:
		_iniciar_derrota()
		return
	
	velocity.x = 0
	velocity.y += gravidade
	
	if (Input.is_action_pressed("ir_para_esquerda")):
		velocity.x = -velocidade
		direcao = -1
		$Sprite2D.flip_h = true
	
	if (Input.is_action_pressed("ir_para_direita")):
		velocity.x = velocidade
		direcao = 1
		$Sprite2D.flip_h = false
		
	
	if (Input.is_action_just_pressed("pular") and is_on_floor()):
		_cancelar_carrinho()
		_cancelar_chute()
		velocity.y = -forca_pulo
		$AudioStreamPlayerPulando.play()
		acao_realizada.emit(&"pular")
				
	
	if (is_on_floor()):
		if (not $AnimationPlayer.is_playing()):
			animando = false
			
		if (not animando):
			if (velocity.x == 0):
				$AnimationPlayer.play("parado")
			else:
				$AnimationPlayer.play("correndo")
		
		if (Input.is_action_just_pressed("carrinho") and not animando and not $ReacoesCristiano.esta_ativa()):
			carregando_chute = false
			_direcao_carrinho = direcao
			_alvos_carrinho.clear()
			$AnimationPlayer.play("carrinho")
			$AudioStreamPlayerCarrinho.play()
			animando = true
			acao_realizada.emit(&"carrinho")
		elif (Input.is_action_just_pressed("chutar") and ScriptGlobal.qtd_bolas > 0 and not animando and velocity.y >= 0.0 and not $ReacoesCristiano.esta_ativa()):
			_direcao_chute = direcao
			carregando_chute = true
			carga_chute = 0.0
		if carregando_chute:
			velocity.x = 0
			carga_chute = minf(TEMPO_SUPERCHUTE, carga_chute + delta)
			if not Input.is_action_pressed("chutar"):
				_dano_chute = 2 if carga_chute >= TEMPO_SUPERCHUTE else 1
				carregando_chute = false
				_bola_disparada = false
				$AnimationPlayer.play("chutando")
				animando = true
			
	else:
		_cancelar_carrinho()
		_cancelar_chute()
		$AnimationPlayer.play("pulando")
		

	_aplicar_deslizamento()
	move_and_slide()
	_atualizar_visual(delta)
	queue_redraw()

func _carrinho_em_andamento() -> bool:
	return $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "carrinho"

func _chute_em_andamento() -> bool:
	return $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "chutando"

func _cancelar_chute() -> void:
	carregando_chute = false
	carga_chute = 0
	if _chute_em_andamento():
		$AnimationPlayer.stop()
		animando = false
		$ChuteCristiano.interromper()

func _aplicar_deslizamento() -> void:
	if _carrinho_em_andamento() and is_on_floor():
		$Area2D.position = Vector2(30.0 * _direcao_carrinho, 10.0)
		$Area2D.scale.x = _direcao_carrinho
		var tempo: float = $AnimationPlayer.current_animation_position
		if tempo >= 0.10 and tempo < 0.32:
			velocity.x = 650.0 * _direcao_carrinho
	else:
		$Area2D.position = Vector2.ZERO
		$Area2D.scale.x = 1.0

func _cancelar_carrinho() -> void:
	if _carrinho_em_andamento():
		$AnimationPlayer.stop()
		animando = false
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		$CarrinhoCristiano.interromper()

func _atualizar_visual(delta: float) -> void:
	var mostrando_reacao: bool = $ReacoesCristiano.atualizar(delta)
	var tempo_animacao: float = $AnimationPlayer.current_animation_position if $AnimationPlayer.is_playing() else 0.0
	var mostrando_carrinho: bool = $CarrinhoCristiano.atualizar(delta, _direcao_carrinho, _carrinho_em_andamento() and not mostrando_reacao, tempo_animacao)
	var mostrando_chute: bool = $ChuteCristiano.atualizar(_direcao_chute, (_chute_em_andamento() or carregando_chute) and not mostrando_reacao, 0.1 if carregando_chute else tempo_animacao)
	var ataque_em_andamento: bool = $AnimationPlayer.is_playing() and (
		$AnimationPlayer.current_animation == "chutando"
		or $AnimationPlayer.current_animation == "carrinho"
	)
	var sem_ataque: bool = not ataque_em_andamento and not mostrando_reacao and not carregando_chute
	var parado: bool = is_zero_approx(velocity.x)
	var mostrando_salto: bool = $SaltoCristiano.atualizar(delta, direcao, is_on_floor(), velocity.y, sem_ataque, parado)
	var pode_usar_visual_novo: bool = is_on_floor() and velocity.y >= 0.0 and sem_ataque and not mostrando_salto
	var mostrando_espera: bool = $EsperaCristiano.atualizar(delta, direcao, pode_usar_visual_novo and parado)
	var mostrando_corrida: bool = $CorridaCristiano.atualizar(delta, direcao, pode_usar_visual_novo and not parado)
	$Sprite2D.visible = not (mostrando_espera or mostrando_corrida or mostrando_salto or mostrando_carrinho or mostrando_chute or mostrando_reacao)
	
func spawnar_bolar():
	if _em_derrota or ScriptGlobal.qtd_vidas <= 0 or _bola_disparada or not _chute_em_andamento() or not is_on_floor():
		return
	if not ScriptGlobal.gastar_bola():
		return
	_bola_disparada = true
	var cena_bola = preload("res://cena_bola.tscn")
	var obj_bola  = cena_bola.instantiate()
	obj_bola.get_node("CharacterBody2D").direcao = _direcao_chute
	obj_bola.get_node("CharacterBody2D").dano = _dano_chute
	if _dano_chute > 1:
		obj_bola.get_node("CharacterBody2D").velocidade = 720
	$Marker2D.position.x = abs($Marker2D.position.x) * _direcao_chute
	obj_bola.position = get_parent().to_local($Marker2D.global_position)
	get_parent().add_child(obj_bola)
	$AudioStreamPlayerChutandoBola.play()
	acao_realizada.emit(&"superchute" if _dano_chute > 1 else &"chutar")
	if _dano_chute > 1:
		$ImpactoCamera.superchute(_direcao_chute)
		
func eliminar_inimigo(body: Node2D) -> void:
	if _em_derrota or not _carrinho_em_andamento():
		return
	var identificador: int = body.get_instance_id()
	if _alvos_carrinho.has(identificador):
		return
	_alvos_carrinho[identificador] = true
	$CarrinhoCristiano.mostrar_impacto()
	if body.has_method("receber_dano"):
		body.receber_dano(1)
	else:
		# Mantém compatibilidade com alvos simples do projeto original.
		body.queue_free()
		if body.name == "Chefao" and is_instance_valid(ScriptGlobal.portao):
			ScriptGlobal.portao.get_node("AnimationPlayer").play("abrir")
		
	
func receber_dano():
	if _em_derrota:
		return
	if ScriptGlobal.qtd_vidas <= 0:
		_iniciar_derrota()
		return
	_interromper_ataques()
	$AudioStreamPlayerDano.play()
	ScriptGlobal.qtd_vidas = maxi(0, ScriptGlobal.qtd_vidas - ScriptGlobal.valor_dano)
	if ScriptGlobal.qtd_vidas == 0:
		_iniciar_derrota()
	else:
		$ReacoesCristiano.receber_dano(direcao)
		$Sprite2D.visible = false

func _interromper_ataques() -> void:
	_cancelar_carrinho()
	_cancelar_chute()
	$AnimationPlayer.stop()
	animando = false
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$EsperaCristiano.interromper()
	$CorridaCristiano.interromper()
	$SaltoCristiano.interromper()

func _iniciar_derrota() -> void:
	if _em_derrota:
		return
	_em_derrota = true
	ScriptGlobal.qtd_vidas = 0
	_interromper_ataques()
	velocity.x = 0.0
	$ReacoesCristiano.iniciar_derrota(direcao)
	$Sprite2D.visible = false

func _processar_derrota(delta: float) -> void:
	# Mantém a queda e a colisão existentes, mas ignora os comandos de ação.
	velocity.x = 0.0
	velocity.y += gravidade
	move_and_slide()
	_atualizar_visual(delta)
	if $ReacoesCristiano.derrota_concluida() and not _game_over_agendado:
		_game_over_agendado = true
		get_tree().call_deferred("change_scene_to_file", "res://cena_game_over.tscn")

func _exit_tree() -> void:
	if ScriptGlobal.personagem == self:
		ScriptGlobal.personagem = null

func _draw() -> void:
	if carregando_chute:
		var cor := Color("fff2ad") if carga_chute >= TEMPO_SUPERCHUTE else Color("d8ae57")
		draw_arc(Vector2(30 * _direcao_chute, 45), 14 + carga_chute * 8, -PI / 2, -PI / 2 + TAU * maxf(0.02, carga_chute / TEMPO_SUPERCHUTE), 24, cor, 3)
	
	
	
	
	
	
	
	
	
