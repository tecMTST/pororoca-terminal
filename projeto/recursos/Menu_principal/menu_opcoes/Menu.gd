extends Control

onready var opcoesMenu = preload("res://recursos/Menu_principal/menu_opcoes/MenuDeOpcoes.tscn")
onready var audio_stream_bgm = $AudioStreamBGM
onready var audio_stream_sfx = $AudioStreamSFX
onready var tween_jogar = $Buttons/Btn_Jogar/tween_jogar

export(PackedScene) var proxima_cena: PackedScene
export(PackedScene) var cena_jogo: PackedScene

var _volume_atual: float = 999
var opcoes_apertado: bool = false
var jogar_apertado: bool = false

func _on_Jogar_button_up():
	jogar_apertado = true
	tween_jogar.interpolate_property($Buttons/Btn_Jogar, 'rect_scale', Vector2(1,1), Vector2(1.2,1.2), 0.45, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween_jogar.interpolate_property($Buttons/Btn_Jogar, 'rect_scale', Vector2(1.2,1.2), Vector2(1,1), 0.45, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween_jogar.start()
	$Buttons/Btn_Jogar.disabled = true
	yield(tween_jogar, "tween_completed")
	if jogar_apertado and opcoes_apertado == false:
		TrocadorDeCenas.trocar_cena(proxima_cena.resource_path)		
		$Buttons/Btn_Jogar.disabled = false
		jogar_apertado = false

func _on_Btn_Jogar_button_down():
	audio_stream_sfx.stream.loop = false
	audio_stream_sfx.play()
