extends Area
class_name Obstaculo

enum TIPO {TERRESTRE, AEREO, RAMPA, ITEM}

const sfx_impacto = preload("res://elementos/audio/sfx/obstaculos/dano-poste.mp3")

export var cores : PoolColorArray = []
export var velocidade := 22.0
export var textura: Texture
var sfx: AudioStream
var info: Dictionary

onready var sprite := $Sprite3D as Sprite3D
onready var tween = $Tween as Tween
onready var sfx_player := get_node("/root/Enchente/AudioStreamSFX") as AudioStreamPlayer
var cor_padrao := Color.white
var cor_adicional : Color

func _ready() -> void:
	sfx_impacto.loop = false
	if sfx is AudioStreamMP3:
		sfx.loop = false

	$Sprite3D.texture = textura
	var tipo = TIPO.TERRESTRE
	if "aereo" in info["grupos"]:
		tipo = TIPO.AEREO
	elif "rampa" in info["grupos"]:
		tipo = TIPO.RAMPA
	elif "item" in info["grupos"]:
		tipo = TIPO.ITEM

	cor_adicional = cores[tipo]
	tween.interpolate_property(sprite, 'modulate', cor_padrao, cor_adicional, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(sprite, 'modulate', cor_adicional, cor_padrao, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _physics_process(delta: float) -> void:
	position.z += velocidade * EnchenteEstadoDeJogo.VelocidadeGlobal * delta

func tocar_som_impacto(imune: bool):
	if not sfx:
		return
	if imune:
		sfx_player.pitch_scale = 3.0
		sfx_player.volume_db = -10.0
		sfx_player.stream = sfx_impacto
	else:
		sfx_player.pitch_scale = 1.0
		sfx_player.volume_db = 0.0
		sfx_player.stream = sfx
	sfx_player.play()

func _on_VisibilityNotifier_screen_exited() -> void:
	queue_free()
