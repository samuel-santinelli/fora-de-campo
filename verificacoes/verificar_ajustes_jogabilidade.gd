extends SceneTree
class Alvo:
	extends StaticBody2D
	var vida: int = 3
	func receber_dano(dano: int) -> void:
		vida -= dano
var falhas: int = 0
func _initialize() -> void:
	call_deferred("_executar")
func _exigir(valor: bool, mensagem: String) -> void:
	if not valor:
		falhas += 1
		push_error(mensagem)
func _aguardar(n: int) -> void:
	for i in range(n):
		await process_frame
func _executar() -> void:
	var global = root.get_node("ScriptGlobal")
	global.resetar_variaveis()
	var fase = load("res://cena_fase.tscn").instantiate()
	fase.get_node("HUD").apresentar_rivais = false
	root.add_child(fase)
	await _aguardar(30)
	var jogador = global.personagem
	_exigir(jogador.is_on_floor() and jogador.global_position.y > 500, "Nascer no piso, sem pedestal.")
	for nome in ["Inimigo1", "Inimigo2", "Neymar", "Mbappe", "Impedimento", "Chefao"]:
		fase.get_node(nome).queue_free()
	var haaland = fase.get_node("Haaland/CharacterBody2D")
	haaland.set_process(false)
	Input.action_press("ir_para_esquerda")
	await _aguardar(120)
	Input.action_release("ir_para_esquerda")
	_exigir(jogador.global_position.x >= 0 and jogador.is_on_floor(), "Parede deve impedir limbo pela esquerda: %s, piso %s." % [jogador.global_position, jogador.is_on_floor()])
	fase.get_node("HUD/ParallaxBackground/BotaoPausa").pressed.emit()
	_exigir(paused, "Botão visível deve pausar.")
	fase.get_node("HUD/ParallaxBackground/pausa/Painel/Margem/Conteudo/Continuar").pressed.emit()
	_exigir(not paused, "Continuar deve retomar.")
	var parede := StaticBody2D.new()
	parede.position = Vector2(2080, 577)
	var forma_parede := RectangleShape2D.new()
	forma_parede.size = Vector2(30, 100)
	var colisao_parede := CollisionShape2D.new()
	colisao_parede.shape = forma_parede
	parede.add_child(colisao_parede)
	fase.add_child(parede)
	var bola = load("res://cena_bola.tscn").instantiate()
	bola.position = Vector2(2020, 577)
	fase.add_child(bola)
	await _aguardar(24)
	_exigir(not is_instance_valid(bola) and is_instance_valid(parede), "Caixa sólida deve bloquear bola sem ser destruída.")
	var alvo := Alvo.new()
	alvo.collision_layer = 4
	alvo.collision_mask = 0
	alvo.position = Vector2(1920, 565)
	var forma := RectangleShape2D.new()
	forma.size = Vector2(22, 100)
	var colisao := CollisionShape2D.new()
	colisao.shape = forma
	alvo.add_child(colisao)
	fase.add_child(alvo)
	jogador.global_position = Vector2(1700, 553)
	jogador.direcao = 1
	await _aguardar(5)
	var estoque: int = global.qtd_bolas
	Input.action_press("chutar")
	await _aguardar(70)
	_exigir(jogador.carregando_chute and jogador.carga_chute == 1.0 and global.qtd_bolas == estoque, "Segurar deve carregar sem gastar munição.")
	Input.action_release("chutar")
	await _aguardar(25)
	var forte: bool = false
	for filho in fase.get_node("Jogador").get_children():
		if filho.has_node("CharacterBody2D"):
			forte = filho.get_node("CharacterBody2D").dano == 2
	_exigir(forte and global.qtd_bolas == estoque - 1, "Soltar carga completa deve gerar dano dobrado e gastar uma bola.")
	await _aguardar(35)
	_exigir(alvo.vida == 1, "Superchute deve tirar dois pontos reais do alvo.")
	jogador.global_position = haaland.global_position + Vector2(-50, 0)
	await _aguardar(4)
	haaland.perseguir()
	haaland.causar_dano_personagem(jogador)
	haaland._process(0.1)
	_exigir(haaland._tempo_tranco > 0 and not is_zero_approx(haaland.get_node("Sprite2D").rotation), "Haaland deve animar tranco ao atacar.")
	jogador.global_position = Vector2(200, 1200)
	await _aguardar(1)
	_exigir(jogador._em_derrota and global.qtd_vidas == 0, "Queda externa deve levar à derrota, não controle do limbo.")
	global.personagem = null
	global.portao = null
	fase.queue_free()
	await process_frame
	global.resetar_variaveis()
	print("Verificação dos ajustes de jogabilidade: %d falhas." % falhas)
	quit(0 if falhas == 0 else 1)
