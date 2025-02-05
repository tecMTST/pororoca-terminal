extends Node

const chamada_boss = preload("res://recursos/jogos/enchente/chefao/Chefao.tscn")

func iniciar():
	$Timer.start()

func _on_Timer_timeout():
	var instancia = chamada_boss.instance()
	add_child(instancia)
