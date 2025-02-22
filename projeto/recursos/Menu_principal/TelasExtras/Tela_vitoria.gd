extends Node

export var cutscene: String = 'res://recursos/jogos/enchente/encerramento/CutsceneFim.tscn'

onready var audio_stream_bgm = $AudioStreamBGM
onready var audio_stream_sfx = $AudioStreamSFX

func _ready():
	audio_stream_bgm.stream.loop = false
	audio_stream_bgm.play()
	$Transparencia.rect_size.x = get_viewport().get_visible_rect().size.x
	$Transparencia.rect_size.y = get_viewport().get_visible_rect().size.y

func _on_VoltarMenu_button_up():
	get_tree().paused = false
	TrocadorDeCenas.trocar_cena(cutscene)

func _on_VoltarMenu_button_down():
	audio_stream_sfx.stream.loop = false
	audio_stream_sfx.play()
