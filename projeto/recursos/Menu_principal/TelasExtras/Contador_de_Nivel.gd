extends Control

export (Array, StreamTexture) var textura_indicador
export (Array, StreamTexture) var textura_popup
export (Array, AudioStreamMP3) var audio_fases

onready var Indicador = $Indicador
onready var PopUp = $PopUp
onready var Indicador_tween = $Indicador/IndicadorTween
onready var PopUp_tween = $PopUp/PopUpTween
onready var barraprogresso = get_node("/root/Enchente/BarraDeProgresso")
onready var audio_stream_player = $AudioStreamPlayer

func _ready() -> void:
	Indicador.texture = textura_indicador[0]
	PopUp.texture = textura_popup[0]
	PopUp.visible = false
	EnchenteEstadoDeJogo.connect('trocou_fase', self, "_change_all")
	EnchenteEstadoDeJogo.connect("entrada_boss", self, "_entrada_boss")
	if barraprogresso.has_method("enviar_pos"):
		var progressopos = barraprogresso.enviar_pos()
		Indicador.rect_position = Vector2((progressopos.x + 250), (progressopos.y + 75))

func _change_all(fase):
	if fase > 3: # Limita somente a primeira fase do boss
		return
	if fase < 3:
		change_popup(fase)
	change_indicador(fase)
	# -1 pois os tons dos áudios vão subindo e a primeira fase não tem toque de entrada
	tocar_audio(fase - 1)

func _entrada_boss():
	change_popup(4)
	tocar_audio(4)
	yield(audio_stream_player, "finished")

func change_popup(fase):
	PopUp.texture = textura_popup[fase - 1]
	PopUp.visible = true
	PopUp_tween.interpolate_property(PopUp, "rect_scale", Vector2(0,0), Vector2(1,1), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	PopUp_tween.start()
	yield(get_tree().create_timer(1.6),"timeout")
	PopUp_tween.interpolate_property(PopUp, "rect_scale", Vector2(1,1), Vector2(0,0), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	PopUp_tween.start()
	yield(get_tree().create_timer(1.6),"timeout")
	PopUp.visible = false

func change_indicador(fase):
	Indicador.texture = textura_indicador[fase - 1]
	Indicador_tween.interpolate_property(Indicador, "rect_scale", Vector2(0,0), Vector2(1,1), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	Indicador_tween.start()
	yield(get_tree().create_timer(1.6),"timeout")

func tocar_audio(fase: int):
	audio_stream_player.stop()
	audio_stream_player.stream = audio_fases[fase - 1]
	audio_stream_player.stream.loop = false
	audio_stream_player.play()
