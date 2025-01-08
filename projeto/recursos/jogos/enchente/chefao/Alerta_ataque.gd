extends Spatial

export var timer = 2

onready var tween_saida = $Saidatween
onready var sprite = $Sprite

func _ready():
	tween_saida.interpolate_property(sprite, "scale", Vector3(0, 0, 0), Vector3(0.6, 0.6, 0.6), 0.8, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween_saida.start()
	yield(get_tree().create_timer(2), "timeout")
	tween_saida.interpolate_property(sprite, "scale", Vector3(0.6, 0.6, 0.6), Vector3(0, 0, 0), 0.6, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween_saida.start()
	yield(tween_saida, "tween_completed")
	self.queue_free()
