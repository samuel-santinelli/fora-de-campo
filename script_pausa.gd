extends Node2D

func _ready() -> void:
	get_tree().paused = false
	visible = false
	get_viewport().size_changed.connect(_organizar)
	_organizar()

func _organizar() -> void:
	var tamanho := get_viewport_rect().size
	$ColorRect.position = Vector2.ZERO
	$ColorRect.size = tamanho
	var escala: float = minf(1.15, minf((tamanho.x - 32) / 500.0, (tamanho.y - 32) / 440.0))
	escala = maxf(0.25, escala)
	$Painel.scale = Vector2.ONE * escala
	$Painel.size = Vector2(500, 440)
	$Painel.position = (tamanho - $Painel.size * escala) / 2

func _process(_delta: float) -> void:
	if get_tree().get_first_node_in_group("apresentacao_rival") != null:
		return
	if Input.is_action_just_pressed("pausa"):
		_definir_pausa(not get_tree().paused)

func _definir_pausa(ativa: bool) -> void:
	if get_tree().get_first_node_in_group("apresentacao_rival") != null:
		return
	get_tree().paused = ativa
	visible = ativa
	if ativa:
		$Painel/Margem/Conteudo/Continuar.grab_focus()
	else:
		$Painel/Margem/Conteudo/Continuar.release_focus()

func continuar() -> void:
	_definir_pausa(false)
