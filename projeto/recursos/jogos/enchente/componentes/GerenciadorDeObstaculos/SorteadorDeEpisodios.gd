class_name SorteadorDeEpisodios
extends Node


export var nome_arquivo_json: String = 'res://elementos/modulos.json'


func resetar():
	historico_de_modulos = []
	_modulos_selecionaveis = _lista_de_modulos.duplicate()


# recebe quantos segundos se passaram desde o inicio
func sortear_modulo(segundos: int) -> Array:
	var lista_modulos = []
	for modulo in _modulos_selecionaveis:
		if modulo['tempo'] <= segundos:
			lista_modulos.append(modulo)
	var modulo_sorteado = _modulo_aleatorio(lista_modulos)
	_remover_grupo(modulo_sorteado['grupo'])
	historico_de_modulos.append(modulo_sorteado)
	return modulo_sorteado['obstaculos']
	
func proximo_modulo(modulos_criados: int) -> Array:
	return _lista_de_modulos[_lista_de_modulos.size() - modulos_criados - 1]['obstaculos']

var historico_de_modulos = []

var _lista_de_modulos: Array
var _modulos_selecionaveis: Array = []
var _gna = RandomNumberGenerator.new()


func _ready():
	_lista_de_modulos = _ler_arquivo_json(nome_arquivo_json)['modulos']
	_modulos_selecionaveis = _lista_de_modulos.duplicate()


func _ler_arquivo_json(nome: String) -> Dictionary:
	var arquivo = File.new()
	arquivo.open(nome_arquivo_json, File.READ)
	var texto = arquivo.get_as_text()
	var conteudo = JSON.parse(texto)
	return conteudo.result


func _calcular_probabilidade_total(lista_modulos) -> float:
	var prob_total: float = 0
	for modulo in lista_modulos:
		prob_total += modulo['chance']
	return prob_total


func _modulo_aleatorio(lista_modulos):
	var prob_total = _calcular_probabilidade_total(lista_modulos)
	var prob = _gna.randf_range(0, prob_total)
	for modulo in lista_modulos:
		if prob < modulo['chance']:
			return modulo
		prob -= modulo['chance']
	return lista_modulos.pick_random()


func _remover_grupo(grupo: int):
	if grupo == 0:
		return
	var novos_modulos = []
	for i in _modulos_selecionaveis.size():
		var modulo = _modulos_selecionaveis[i]
		if modulo['grupo'] != grupo:
			novos_modulos.append(modulo)
	_modulos_selecionaveis = novos_modulos
