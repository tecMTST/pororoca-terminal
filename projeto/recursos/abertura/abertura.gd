extends Control

export(PackedScene) var proxima_cena: PackedScene

func _ready() -> void:
	randomize()
	var rndsfx = randi() % 100 + 1
	print(rndsfx)
	if rndsfx == 88:
		$AudioStreamBGM.stream = load("res://elementos/audio/sfx/gameboy_easteregg.mp3")

	$AnimationPlayer.play('abertura')
	yield ($AnimationPlayer, 'animation_finished')
	_pular_intro()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_pular_intro()

func _pular_intro() -> void:
	TrocadorDeCenas.trocar_cena(proxima_cena.resource_path)
