extends AudioStreamPlayer

const bgm = {
	'1': {
		'audio': preload("res://elementos/audio/bgm/jogo/lv1-surf.mp3"),
		'espera': 2.0,
		'loop': false
	},
	'2': {
		'audio': preload("res://elementos/audio/bgm/jogo/lv2-surf.mp3"),
		'espera': 2.0,
		'loop': true
	},
	'4': {
		'audio': preload("res://elementos/audio/bgm/jogo/lv3-chefe.mp3"),
		'espera': 2.0,
		'loop': false
	},
}

onready var tween = Tween.new()

func _ready() -> void:
	add_child(tween)

func mudar_musica(fase: String) -> void:
	if !bgm.has(fase):
		return
	var musica = bgm[fase]
	tween.interpolate_property(self, "volume_db", volume_db, -80, musica.espera, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	tween.reset(self, "volume_db")

	stream = musica.audio
	stream.loop = musica.loop
	play()
