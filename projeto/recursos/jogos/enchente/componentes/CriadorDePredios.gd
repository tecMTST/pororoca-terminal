extends Spatial
class_name CriadorDePredios

export(Array, String) var modelos = []
export var velocidade = 17.0
export var quantidade_inicial = 10
export var espacamento = 10.0
export var deslocamento_vertical : float = 0.0
export var inverter_x : bool = false
export var z_aleatorio : bool = true
onready var spawn = $Spawn

var proximo : Spatial

var instancias = []

func _ready():
	if modelos.size() > 0:
		var posicao = spawn.global_position
		var deslocamento = 0
		for i in range(quantidade_inicial):
			randomize()
			var indice = (randi() % modelos.size() + 1) -  1
			var instancia = load(modelos[indice]).instance()
			add_child(instancia)
			instancia.global_position = posicao
			instancia.global_position.y = instancia.global_position.y + deslocamento_vertical
			instancia.global_position.z = instancia.global_position.z + deslocamento
			if inverter_x:
				instancia.scale.x = instancia.scale.x * -1
			if z_aleatorio:
				if rand_range(0, 1) > 0.5:
					instancia.scale.z = instancia.scale.z * -1
			deslocamento = deslocamento + espacamento
			instancias.push_back(instancia)

func _physics_process(delta: float) -> void:
	movimento(delta)
	verificar_criacao()

func verificar_criacao():
	if (instancias[0].global_position.z - spawn.global_position.z) > espacamento:
		var ultimo = instancias.pop_back()
		var posicao = spawn.global_position
		ultimo.global_position = posicao
		ultimo.global_position.y = ultimo.global_position.y + deslocamento_vertical
		if z_aleatorio:
			randomize()
			if rand_range(0, 1) > 0.5:
				ultimo.scale.z = ultimo.scale.z * -1
		instancias.push_front(ultimo)

func movimento(delta):
	for instancia in instancias:
		instancia.global_position.z += velocidade * delta * EnchenteEstadoDeJogo.VelocidadeGlobal

func remover_ultimo():
	var ultimo = instancias.pop_back()
	remove_child(ultimo)
