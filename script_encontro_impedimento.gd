extends Node2D
## Sequencia os dois encontros sem nova arena nem mudança no combate do chefe.

var _guardiao: CharacterBody2D
var _chefe: CharacterBody2D
var _modo_original: ProcessMode
var _camada_original: int

func _ready() -> void:
	$Jogador/Personagem/Camera2D.limit_right = preload("res://script_layout_percurso.gd").COMPRIMENTO
	$Jogador/Personagem/Camera2D.limit_left = 0
	_guardiao = $Impedimento/CharacterBody2D
	_chefe = $Chefao/Chefao
	_modo_original = $Chefao.process_mode
	_camada_original = _chefe.collision_layer
	$Chefao.process_mode = Node.PROCESS_MODE_DISABLED
	_chefe.collision_layer = 0
	_guardiao.tree_exiting.connect(_ao_sair_guardiao)

func _ao_sair_guardiao() -> void:
	if is_queued_for_deletion() or not is_instance_valid(_chefe):
		return
	if not _guardiao.get_node("Resistencia").derrotado:
		return
	$Chefao.process_mode = _modo_original
	_chefe.collision_layer = _camada_original
	# Reconciliar sinais ocorridos durante a espera sem ativar chefe fora da tela.
	_chefe.esta_na_tela = _chefe.get_node("VisibleOnScreenNotifier2D").is_on_screen()
