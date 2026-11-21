extends RefCounted
const ARRANCADA = preload("res://Sons/Identidade/arrancada.wav")
const PASSO = preload("res://Sons/Identidade/passo-tanque.wav")
const SALTO = preload("res://Sons/Identidade/salto-goleiro.wav")
const PANE = preload("res://Sons/Identidade/var-pane.wav")

static func tocar(corpo: Node, som: AudioStream, volume: float = -10.0) -> void:
	var audio := AudioStreamPlayer.new()
	audio.stream = som
	audio.bus = &"Efeitos"
	audio.volume_db = volume
	audio.add_to_group("sons_identidade")
	audio.finished.connect(audio.queue_free)
	corpo.get_parent().add_child.call_deferred(audio)
	audio.play.call_deferred()
