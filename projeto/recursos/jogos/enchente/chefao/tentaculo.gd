extends KinematicBody

<<<<<<< HEAD
=======
export var Tempo = 3.5

>>>>>>> e522084 (adição de todas as features requisitadas na issue)
const sfx_impacto = preload("res://elementos/audio/sfx/obstaculos/dano-poste.mp3")

const sfx := [
	preload("res://elementos/audio/sfx/chefe/dano-tentaculo-1.mp3"),
	preload("res://elementos/audio/sfx/chefe/dano-tentaculo-2.mp3"),
	preload("res://elementos/audio/sfx/chefe/dano-tentaculo-3.mp3")
]

<<<<<<< HEAD
=======
onready var sprite_tentaculo = $Sprite3D
onready var sprite_aviso = $AnimatedSprite3D
onready var tempo_tela = $TempoDeTela
onready var tempo_aviso = $TempoDeAviso
>>>>>>> e522084 (adição de todas as features requisitadas na issue)
onready var tentaculo_anim = $Sprite3D/AnimationPlayer
onready var sfx_player := get_node("/root/Enchente/AudioStreamSFX") as AudioStreamPlayer

func _ready():
	$CollisionShape.disabled = true
<<<<<<< HEAD
=======
	sprite_tentaculo.visible = false
	yield(get_tree().create_timer(2.5), "timeout")
	sprite_aviso.visible = false
	sprite_tentaculo.visible = true
>>>>>>> e522084 (adição de todas as features requisitadas na issue)
	tentaculo_anim.play("In_OUt")
	yield(tentaculo_anim, "animation_finished")
	$CollisionShape.disabled = false
	tentaculo_anim.play("Idle")
<<<<<<< HEAD
	$Timer.start(5)
	yield($Timer, "timeout")
=======
	tempo_tela.start(Tempo)
	yield(tempo_tela, "timeout")
>>>>>>> e522084 (adição de todas as features requisitadas na issue)
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
