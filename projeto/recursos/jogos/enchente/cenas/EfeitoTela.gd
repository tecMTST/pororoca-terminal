extends ColorRect

export var preenchimento_minimo := 0.0
export var preenchimento_maximo := 1.0
export var tempo_pulso := 1

onready var tween := $Tween as Tween

func _ready() -> void:
	EnchenteEstadoDeJogo.connect('dano_jogador', self, '_dano_jogador')
	tween.repeat = true

func _dano_jogador(vida) -> void:
	if tween.is_active():
		tween.stop_all()
		tween.remove_all()

	if vida.vida_atual == vida.vida_maxima:
		tween.stop_all()
		tween.remove_all()
		self.material.set_shader_param('dissolve_amount', 0.0)
		return

	var tempo = vida.vida_atual * tempo_pulso / 2
	tween.interpolate_property(
		self.material, 
		'shader_param/dissolve_amount',
		preenchimento_minimo,
		preenchimento_maximo,
		tempo,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN
	)
	tween.interpolate_property(
		self.material,
		'shader_param/dissolve_amount',
		preenchimento_maximo,
		preenchimento_minimo,
		tempo,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT_IN,
		tempo / 2
	)
	tween.start()
