extends Node

export var jogarnovamente: String = "res://recursos/jogos/enchente/cenas/Enchente.tscn"

func _ready():
	$Transparencia.rect_size.x = get_viewport().get_visible_rect().size.x
	$Transparencia.rect_size.y = get_viewport().get_visible_rect().size.y

func _on_Voltarjogo_button_up():
	get_tree().paused = false
	TrocadorDeCenas.trocar_cena(jogarnovamente)

func _on_Voltarjogo_button_down():
	$AudioStreamSFX.stream.loop = false
	$AudioStreamSFX.play()
