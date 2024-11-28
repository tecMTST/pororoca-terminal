extends Node

onready var opcoesMenu = preload("res://recursos/Menu_principal/menu_opcoes/MenuDeOpcoes.tscn")
onready var tween = $CanvasLayer/Menu/Tween
onready var audio_stream_sfx = $AudioStreamSFX

export(Array, StreamTexture) var img_pause
export(Array, StreamTexture) var img_config

var menuApertado: bool = false

func _ready():
	var cena_nodes = get_tree().get_nodes_in_group("Enchente")
	if cena_nodes:
		print(get_tree().get_nodes_in_group("Enchente"))
		$CanvasLayer/Menu.texture_normal = img_pause[0]
		$CanvasLayer/Menu.texture_pressed = img_pause[1]
		$CanvasLayer/Menu.texture_hover = img_pause[2]
	else:
		print(get_tree().get_nodes_in_group("Enchente"))
		$CanvasLayer/Menu.texture_normal = img_config[0]
		$CanvasLayer/Menu.texture_pressed = img_config[1]
		$CanvasLayer/Menu.texture_hover = img_config[2]

func _on_Menu_button_up():
	menuApertado = true
	var instanciaMenu = opcoesMenu.instance()
	if menuApertado:
		tween.interpolate_property($CanvasLayer/Menu, "rect_scale", Vector2(1,1), Vector2(1.2,1.2), 0.4, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		tween.interpolate_property($CanvasLayer/Menu, "rect_scale", Vector2(1.2,1.2), Vector2(1,1), 0.4, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")
		get_tree().get_root().add_child(instanciaMenu)

func _on_Menu_button_down():
	audio_stream_sfx.stream.loop = false
	audio_stream_sfx.play()
