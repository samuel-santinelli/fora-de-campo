extends Node2D
## Painéis dos primeiros ambientes. A faixa de chão é desenhada pelo terreno.
const QUADRA = preload("res://arte/cenarios/percurso-v2/01-treino.png")
const RUA = preload("res://arte/cenarios/percurso-v2/02-arbitragem.png")
const PRACA = preload("res://arte/cenarios/percurso-v2/03-praca.png")
const CORREDOR = preload("res://arte/cenarios/percurso-v2/04-orla.png")
const SERVICO = preload("res://arte/cenarios/percurso-v2/05-navio-viking.png")
const FISCALIZACAO = preload("res://arte/cenarios/percurso-v2/06-fiscalizacao.png")
const ENTRADA = preload("res://arte/cenarios/percurso-v2/07-estadio.png")
const ALTURA_FUNDO: float = 607.0
const CORTE_CHAO: float = 562.0
const ESCALA: float = ALTURA_FUNDO / CORTE_CHAO
const INICIO_RUA: float = 1800.0
const TRANSICAO: float = 320.0

func paineis() -> Array[Dictionary]:
	return [
		{"textura": QUADRA, "inicio": 0.0, "corte": CORTE_CHAO},
		{"textura": RUA, "inicio": INICIO_RUA, "corte": CORTE_CHAO},
		{"textura": PRACA, "inicio": 3600.0, "corte": 562.0},
		{"textura": CORREDOR, "inicio": 5400.0, "corte": 562.0},
		{"textura": SERVICO, "inicio": 7200.0, "corte": 562.0},
		{"textura": FISCALIZACAO, "inicio": 9000.0, "corte": 562.0},
		{"textura": ENTRADA, "inicio": 10800.0, "corte": 562.0, "fim": 13000.0},
	]

func _faixa(textura: Texture2D, inicio: float, x: float, largura: float, corte: float, opacidade: float) -> void:
	var escala: float = ALTURA_FUNDO / corte
	draw_texture_rect_region(textura, Rect2(x, 0, largura, ALTURA_FUNDO), Rect2((x - inicio) / escala, 0, largura / escala, corte), Color(1, 1, 1, opacidade))

func _painel(dados: Dictionary, primeiro: bool) -> void:
	var textura: Texture2D = dados.textura
	var inicio: float = dados.inicio
	var corte: float = dados.corte
	var fim: float = inicio + textura.get_width() * ALTURA_FUNDO / corte
	var opaco_inicio: float = inicio if primeiro else inicio + TRANSICAO
	if not primeiro:
		var x: float = inicio
		while x < opaco_inicio:
			var passo: float = minf(12, opaco_inicio - x)
			_faixa(textura, inicio, x, passo, corte, (x - inicio + passo / 2) / TRANSICAO)
			x += passo
	_faixa(textura, inicio, opaco_inicio, fim - opaco_inicio, corte, 1)
	# Completar a margem final com a coluna externa do muro, sem esticar o túnel.
	var limite: float = dados.get("fim", fim)
	if limite > fim:
		draw_texture_rect_region(textura, Rect2(fim, 0, limite - fim, ALTURA_FUNDO), Rect2(textura.get_width() - 1, 0, 1, corte))

func _draw() -> void:
	# Base atrás das bordas superiores dos painéis.
	draw_rect(Rect2(-4, -100, 13100, 850), Color("243c59"))
	var lista := paineis()
	for i in range(lista.size()):
		_painel(lista[i], i == 0)
