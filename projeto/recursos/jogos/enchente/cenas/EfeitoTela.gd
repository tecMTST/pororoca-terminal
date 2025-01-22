extends ColorRect

export var preenchimento_minimo := 0.0
export var preenchimento_maximo := 1.0

func _ready() -> void:
	EnchenteEstadoDeJogo.connect('dano_jogador', self, '_dano_jogador')

func _dano_jogador(vida: Vida) -> void:
	preenchimento_maximo = 0.25
	var preenchimento = range_lerp(vida.vida_atual, 0, vida.vida_maxima, preenchimento_minimo, preenchimento_maximo)

