class_name ControladorDeObstaculos
extends Position3D

export var intervalo_modulos := 3.0
export var distancia_obstaculos := 10.0
export var altura_objeto_aereo := 1.0
export(NodePath) var faixas

onready var _sorteador = $SorteadorDeEpisodios
onready var _pontos_de_origem := get_node(faixas).get_children()
onready var _intervalo_adicionar_modulos := $Timer

onready var _configuracao_de_modulos := _sorteador._ler_arquivo_json('res://elementos/modulos.json') as Dictionary
onready var _fabrica_obstaculos := FabricaObstaculos.new(
	_configuracao_de_modulos['tipo_de_obstaculo'],
	_configuracao_de_modulos['sfx']
)

var _numero_modulos_criados := 0

func iniciar() -> void:
	EnchenteEstadoDeJogo.DictVelocidades = _configuracao_de_modulos['velocidade']
	EnchenteEstadoDeJogo.connect("nova_velocidade", self, 'alterar_tempo')
	_intervalo_adicionar_modulos.connect('timeout', self, 'adicionar_modulo')
	intervalo_modulos = _configuracao_de_modulos['distancia_entre_modulos']
	_intervalo_adicionar_modulos.wait_time = intervalo_modulos / EnchenteEstadoDeJogo.VelocidadeGlobal
	_intervalo_adicionar_modulos.start()

func alterar_tempo() -> void:
	_intervalo_adicionar_modulos.wait_time = intervalo_modulos / EnchenteEstadoDeJogo.VelocidadeGlobal


func parar() -> void:
	_intervalo_adicionar_modulos.stop()

func adicionar_modulo() -> void:
	var modulo = _sorteador.proximo_modulo(_numero_modulos_criados)

	var contador_linha = 0
	for linha in modulo:
		contador_linha += 1
		for obstaculo_indice in range(linha.size()):
			var id_obstaculo = linha[obstaculo_indice]
			if id_obstaculo != 0:
				var obstaculo_criado = _fabrica_obstaculos.criar(
					String(id_obstaculo),
					self._posicao_do_obstaculo(obstaculo_indice, contador_linha)
				)
				if obstaculo_criado.is_in_group('aereo'):
					obstaculo_criado.position.y = altura_objeto_aereo

				add_child(obstaculo_criado)
	_numero_modulos_criados += 1

func _posicao_do_obstaculo(obstaculo_indice: int, contador_linha: int) -> Vector3:
	var ponto_de_origem: Position3D = _pontos_de_origem[obstaculo_indice]
	return Vector3(
		ponto_de_origem.transform.origin.x,
		ponto_de_origem.transform.origin.y,
		position.z + (contador_linha * distancia_obstaculos)
	)
