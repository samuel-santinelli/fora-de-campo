extends SceneTree
var falhas: int = 0
func _initialize() -> void:
	call_deferred("_executar")
func _exigir(valor: bool, mensagem: String) -> void:
	if not valor:
		falhas += 1
		push_error(mensagem)
func _executar() -> void:
	var cena = load("res://cena_chefao.tscn").instantiate()
	var chefe = cena.get_node("Chefao")
	chefe.set_process(false)
	root.add_child(cena)
	var sprite = chefe.get_node("Sprite2D")
	var corpo = chefe.get_node("CollisionShape2D")
	var tamanho: Vector2 = corpo.shape.size
	_exigir(sprite.texture == chefe.VISUAL_PARADO and sprite.offset == Vector2(-192, -360), "Repouso deve usar célula nova com âncora dos pés.")
	chefe.velocity.x = -100
	chefe._visual(0.3)
	_exigir(sprite.texture == chefe.VISUAL_AVANCO and sprite.region_rect.position.x > 0, "Movimento deve avançar quadros de caminhada.")
	chefe.direcao = 1
	chefe._visual()
	_exigir(sprite.scale == Vector2(-0.6, 0.6), "Espelhar pela âncora sem alterar colisão.")
	chefe.velocity.x = 0
	chefe._mudar(chefe.Estado.GOLPE)
	chefe._tempo = 0.59
	chefe._visual()
	_exigir(sprite.texture == chefe.VISUAL_GOLPE and sprite.region_rect.position.x == 3 * 384, "Antes de 600 ms deve manter punho erguido.")
	chefe._mudar(chefe.Estado.ONDA)
	chefe._visual()
	_exigir(sprite.region_rect.position.x == 4 * 384, "Onda deve começar no quadro de impacto, sem reiniciar preparação.")
	chefe._tempo = 0.15
	chefe._visual()
	_exigir(sprite.region_rect.position.x == 5 * 384, "Impacto deve sustentar punho no chão.")
	chefe._mudar(chefe.Estado.RECUPERACAO)
	chefe._visual()
	_exigir(sprite.texture == chefe.VISUAL_GOLPE and sprite.region_rect.position.x == 7 * 384, "Recuperação deve continuar o retorno do golpe.")
	chefe._tempo = 0.8
	chefe._visual()
	_exigir(sprite.region_rect.position.x == 7 * 384, "Golpe não deve repetir após terminar durante recuperação.")
	chefe._mudar(chefe.Estado.CARGA)
	chefe._visual()
	_exigir(sprite.texture == chefe.VISUAL_PARADO, "Carga do laser deve manter pose base com efeitos existentes.")
	chefe._mudar(chefe.Estado.ATORDOADO)
	chefe._visual()
	_exigir(sprite.texture == chefe.VISUAL_PARADO and not chefe._recuperando_golpe, "Contra-ataque deve abandonar sequência do golpe.")
	_exigir(corpo.shape.size == tamanho and chefe.scale == Vector2.ONE, "Troca de sprites deve preservar corpo e escala raiz.")
	chefe.set_process(true)
	paused = true
	var retangulo: Rect2 = sprite.region_rect
	var relogio: float = chefe._tempo_caminhada
	for i in range(10):
		await process_frame
	_exigir(sprite.region_rect == retangulo and chefe._tempo_caminhada == relogio, "Pausa deve congelar animações.")
	paused = false
	cena.queue_free()
	await process_frame
	print("Verificação de animações VAR-01: %d falhas." % falhas)
	call_deferred("quit", 0 if falhas == 0 else 1)
