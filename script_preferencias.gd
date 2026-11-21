extends Node
## Preferências mantidas durante a sessão; independentes do reset da partida.
var entrada_web_confirmada: bool = false

func _ready() -> void:
	for nome in ["Musica", "Efeitos"]:
		if AudioServer.get_bus_index(nome) < 0:
			# add_bus(-1) desordena os canais JS no Godot Web 4.7.2.
			# Aumentar a contagem usa o caminho correto de criação em ordem.
			AudioServer.bus_count = AudioServer.bus_count + 1
			var indice: int = AudioServer.bus_count - 1
			AudioServer.set_bus_name(indice, nome)
			AudioServer.set_bus_send(indice, "Master")
	get_tree().node_added.connect(_rotear_audio)

func _rotear_audio(no: Node) -> void:
	if no is AudioStreamPlayer or no is AudioStreamPlayer2D or no is AudioStreamPlayer3D:
		if no.stream != null and no.bus == &"Master":
			var arquivo: String = no.stream.resource_path.get_file().to_lower()
			no.bus = &"Musica" if arquivo.begins_with("música") or arquivo.begins_with("musica") else &"Efeitos"

func definir_volume(canal: String, percentual: float) -> void:
	var indice: int = AudioServer.get_bus_index(canal)
	if indice >= 0:
		AudioServer.set_bus_volume_linear(indice, clampf(percentual / 100.0, 0, 1))

func volume(canal: String) -> float:
	return AudioServer.get_bus_volume_linear(AudioServer.get_bus_index(canal)) * 100.0

