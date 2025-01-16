extends Camera

onready var tween := $Tween as Tween

func mover(_direcao, alvo) -> void:
	var alvo_camera = self.global_transform.origin
	alvo_camera.x = 0.0
	if alvo.x > 0:
		alvo_camera.x = 0.5
	elif alvo.x < 0:
		alvo_camera.x = -0.5

	tween.interpolate_property(self, "global_transform", global_transform, Transform(global_transform.basis, alvo_camera), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
