extends Control

export (Array, StreamTexture) var textura_indicador
export (Array, StreamTexture) var textura_popup

onready var Indicador = $Indicador
onready var PopUp = $PopUp
onready var Indicador_tween = $Indicador/IndicadorTween
onready var PopUp_tween = $PopUp/PopUpTween
onready var barraprogresso = get_node("/root/Enchente/BarraDeProgresso")

var fase_atual = EnchenteEstadoDeJogo.get_fase_atual() - 1
var fase = 0

func _ready() -> void:
	Indicador.texture = textura_indicador[0]
	PopUp.texture = textura_popup[0]
	PopUp.visible = false
	yield(get_tree().create_timer(5),"timeout")
	change_popup(0)

func _process(delta):
	if barraprogresso.has_method("enviar_pos"):
		var progressopos = barraprogresso.enviar_pos()
		Indicador.rect_position = Vector2((progressopos.x + 250), (progressopos.y + 75))

	var fase_atual = EnchenteEstadoDeJogo.get_fase_atual() - 1

	if fase < fase_atual and fase_atual <= 2:
		yield(get_tree().create_timer(2.5),"timeout")
		print(fase_atual)
		change_popup(fase_atual)
		change_indicador(fase_atual)
		fase = fase_atual

func change_popup(index):
	PopUp.texture = textura_popup[index]
	PopUp.visible = true
	PopUp_tween.interpolate_property(PopUp, "rect_scale", Vector2(0,0), Vector2(1,1), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	PopUp_tween.start()
	yield(get_tree().create_timer(1.6),"timeout")
	PopUp_tween.interpolate_property(PopUp, "rect_scale", Vector2(1,1), Vector2(0,0), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	PopUp_tween.start()
	yield(get_tree().create_timer(1.6),"timeout")
	PopUp.visible = false

func change_indicador(index):
	Indicador.texture = textura_indicador[index]
	Indicador_tween.interpolate_property(Indicador, "rect_scale", Vector2(0,0), Vector2(1,1), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	Indicador_tween.start()
	yield(get_tree().create_timer(1.6),"timeout")
