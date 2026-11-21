extends Node
signal vida_alterada(atual: int, maxima: int)
## Vida configurável compartilhada, sem alterar a IA dos inimigos.

@export_range(1, 99) var vida_maxima: int = 1
@export var abre_portao: bool = false
@export var som_dano: AudioStream

var vida_atual: int = 1
var derrotado: bool = false
var _sprite: Sprite2D
var _cor_original: Color = Color.WHITE
var _clarao: Tween

func _ready() -> void:
	vida_atual = vida_maxima
	_sprite = get_parent().get_node_or_null("Sprite2D")
	if is_instance_valid(_sprite):
		_cor_original = _sprite.modulate
	var barra := ProgressBar.new()
	barra.name = "BarraVida"
	barra.set_script(preload("res://script_barra_vida_inimigo.gd"))
	barra.resistencia = self
	get_parent().add_child.call_deferred(barra)

func receber_dano(quantidade: int = 1) -> void:
	if derrotado or quantidade <= 0:
		return
	vida_atual = maxi(0, vida_atual - quantidade)
	vida_alterada.emit(vida_atual, vida_maxima)
	_tocar_som()
	if vida_atual == 0:
		derrotado = true
		var corpo: CharacterBody2D = get_parent()
		var derrota := Node2D.new()
		derrota.set_script(preload("res://script_derrota_inimigo.gd"))
		corpo.get_parent().add_child(derrota)
		derrota.configurar(corpo, abre_portao)
		# Sem colisão, ataques ou IA a partir do golpe fatal.
		corpo.hide()
		corpo.set_process(false)
		corpo.set_physics_process(false)
		get_parent().queue_free()
		return
	if is_instance_valid(_sprite):
		if _clarao != null and _clarao.is_valid():
			_clarao.kill()
		_sprite.modulate = Color(1.7, 0.85, 0.45)
		_clarao = create_tween()
		_clarao.tween_property(_sprite, "modulate", _cor_original, 0.12)

func _tocar_som() -> void:
	if som_dano == null:
		return
	var som := AudioStreamPlayer.new()
	som.stream = som_dano
	som.volume_db = -6.0
	# O áudio sobrevive à remoção do corpo que acabou de ser derrotado.
	get_parent().get_parent().add_child(som)
	som.finished.connect(som.queue_free)
	som.play()
