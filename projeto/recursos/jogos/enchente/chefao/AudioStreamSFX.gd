extends AudioStreamPlayer

const sfx := {
	"chefe-alerta": [
		preload("res://elementos/audio/sfx/chefe/boss_alarm.mp3")
	],
	"ataque": [
		preload("res://elementos/audio/sfx/chefe/ataque-tentaculo.mp3")
	],
	"chefe": [
		preload("res://elementos/audio/sfx/chefe/chefe-curto1.mp3"),
		preload("res://elementos/audio/sfx/chefe/chefe-curto2.mp3"),
	],
	"chefe-morte": [
		preload("res://elementos/audio/sfx/chefe/chefe-longo.mp3")
	]
}

func tocar_sfx(tipo: String) -> void:
	if sfx.has(tipo):
		stop()
		stream = sfx[tipo][randi() % sfx[tipo].size()]
		play()
