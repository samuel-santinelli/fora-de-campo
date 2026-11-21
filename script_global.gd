extends Node

const VIDAS_MAXIMAS: int = 10
const BOLAS_MAXIMAS: int = 20
const BOLAS_INICIAIS: int = 10
var qtd_bolas: int = BOLAS_INICIAIS

var qtd_vidas     = 0
var fase_atual    = 0
var pontuacao     = 0
var musica_ligada = true
var valor_dano    = 0
var personagem    = null
var portao        = null

func resetar_variaveis():
	qtd_vidas  = VIDAS_MAXIMAS
	qtd_bolas = BOLAS_INICIAIS
	fase_atual = 1
	pontuacao  = 0
	valor_dano = 1

func _ready() -> void:	
	resetar_variaveis()

func gastar_bola() -> bool:
	if qtd_vidas <= 0 or qtd_bolas <= 0:
		return false
	qtd_bolas -= 1
	return true

func recuperar_vida(quantidade: int) -> int:
	if qtd_vidas <= 0 or quantidade <= 0:
		return 0
	var antes: int = qtd_vidas
	qtd_vidas = mini(VIDAS_MAXIMAS, qtd_vidas + quantidade)
	return qtd_vidas - antes

func repor_bolas(quantidade: int) -> int:
	if qtd_vidas <= 0 or quantidade <= 0:
		return 0
	var antes: int = qtd_bolas
	qtd_bolas = mini(BOLAS_MAXIMAS, qtd_bolas + quantidade)
	return qtd_bolas - antes
