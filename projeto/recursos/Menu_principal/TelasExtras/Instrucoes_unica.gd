extends Control

onready var ajudardonamaria = $canvasinstrucoes/AjudeDonaMaria
onready var tomardano = $canvasinstrucoes/TomarDano
onready var primeiroframe = $canvasinstrucoes/Primeiro
onready var segundoframe = $canvasinstrucoes/Segundo
onready var terceiroframe = $canvasinstrucoes/Terceiro
onready var quartoframe = $canvasinstrucoes/Quarto
onready var tweentransicao = $canvasinstrucoes/Tweentransicao
onready var tweentransicaoobjeto2 = $canvasinstrucoes/Tweentransicaoobjeto2

# Called when the node enters the scene tree for the first time.
func _ready():
	if SingletonOpcoesGlobais.Tutorial_finalizado == true:
		self.queue_free()
		get_tree().paused = false
	else:
		get_tree().paused = true

func _on_PularPrimeiro_button_up():
	segundoframe.modulate = Color(1, 1, 1, 0)
	segundoframe.visible = true
	tweentransicao.interpolate_property(primeiroframe, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tweentransicao.start()
	yield(tweentransicao, "tween_completed")
	tweentransicaoobjeto2.interpolate_property(segundoframe, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tweentransicaoobjeto2.start()
	yield(tweentransicao, "tween_completed")
	primeiroframe.modulate = Color(1, 1, 1, 0)
	primeiroframe.visible = false
	get_tree().paused = true

func _on_PularSegundo_button_up():
	terceiroframe.modulate = Color(1, 1, 1, 0)
	terceiroframe.visible = true
	tweentransicao.interpolate_property(segundoframe, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tweentransicao.start()
	yield(tweentransicao, "tween_completed")
	tweentransicaoobjeto2.interpolate_property(terceiroframe, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tweentransicaoobjeto2.start()
	yield(tweentransicao, "tween_completed")
	segundoframe.modulate = Color(1, 1, 1, 0)
	segundoframe.visible = false
	get_tree().paused = true

func _on_PularTerceiro_button_up():
	quartoframe.modulate = Color(1, 1, 1, 0)
	quartoframe.visible = true
	tweentransicao.interpolate_property(terceiroframe, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tweentransicao.start()
	tomardano.modulate = Color(1, 1, 1, 0)
	tomardano.visible = true
	yield(tweentransicao, "tween_completed")
	tweentransicaoobjeto2.interpolate_property(quartoframe, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tweentransicaoobjeto2.start()
	tweentransicao.interpolate_property(ajudardonamaria, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tweentransicao.start()
	yield(tweentransicao, "tween_completed")
	tweentransicaoobjeto2.interpolate_property(tomardano, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tweentransicaoobjeto2.start()
	yield(tweentransicao, "tween_completed")
	terceiroframe.modulate = Color(1, 1, 1, 0)
	terceiroframe.visible = false
	ajudardonamaria.modulate = Color(1, 1, 1, 0)
	ajudardonamaria.visible = false
	get_tree().paused = true

func _on_PularQuarto_button_up():
	tweentransicao.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tweentransicao.start()
	yield(tweentransicao, "tween_completed")
	SingletonOpcoesGlobais.Tutorial_finalizado = true
	SingletonOpcoesGlobais.salvar_globais()
	quartoframe.visible = false
	get_tree().paused = false
	self.queue_free()
