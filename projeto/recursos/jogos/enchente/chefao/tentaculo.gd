extends Area
class_name Tentaculo

export var Tempo = 2

const sfx_impacto = preload("res://elementos/audio/sfx/obstaculos/dano-poste.mp3")

const sfx := [
	preload("res://elementos/audio/sfx/chefe/dano-tentaculo-1.mp3"),
	preload("res://elementos/audio/sfx/chefe/dano-tentaculo-2.mp3"),
	preload("res://elementos/audio/sfx/chefe/dano-tentaculo-3.mp3")
]

onready var sprite_tentaculo = $Sprite3D
onready var tempo_tela = $TempoDeTela
onready var tentaculo_anim = $Sprite3D/AnimationPlayer
onready var sfx_player := get_node("/root/Enchente/AudioStreamSFX") as AudioStreamPlayer
export(StreamTexture) var Textinit

func _ready():
	$CollisionShape.disabled = true
	sprite_tentaculo.visible = false
	yield(get_tree().create_timer(2.5), "timeout")
	sprite_tentaculo.visible = true
	sprite_tentaculo.texture = Textinit
	tentaculo_anim.play("In_OUt")
	yield(tentaculo_anim, "animation_finished")
	$CollisionShape.disabled = false
	tentaculo_anim.play("Idle")
	tempo_tela.start(Tempo)
	yield(tempo_tela, "timeout")
	tentaculo_anim.play_backwards("In_OUt")
	yield(tentaculo_anim, "animation_finished")
	self.queue_free()

func _on_AreaColetoraObstaculos_body_entered(body):
	if body.is_in_group("minasAquaticas"):
		body.queue_free()

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
		sfx_player.stream = sfx[randi() % sfx.size()]
	sfx_player.play()
