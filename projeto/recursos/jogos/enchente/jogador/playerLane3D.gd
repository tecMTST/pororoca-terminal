extends KinematicBody
class_name PlayerLane3D

export var tempo_imunidade_dano: float = 3.0
export var tempo_imunidade_item: float = 5.0
export var tempo_tela_balao: float = 1
export(Array, StreamTexture) var texturas

onready var controle_faixa_3d = $ControleFaixa3D
onready var vida = $Vida as Vida
onready var sprite = $Sprite as AnimatedSprite3D
onready var sprite_agua = $SpriteAgua as AnimatedSprite3D
onready var timer_imunidade = $TimerImunidade
onready var imunidade_modulate = false
onready var menuOpcoes = preload("res://recursos/Menu_principal/menu_opcoes/BotaoMenu.tscn")
onready var posicao_sprite_agua_original = sprite_agua.global_position
onready var imunidade_particulas = $ImunidadeParticulas
onready var BaloesDeFalha: Sprite3D = $BalaoDeFala
onready var TweenBalao: Tween = $BalaoDeFala/TweenBalao

var imune = false
var imune_dano = false
var imunidade_time: float = 0
var range_baloes: int = 4
var abaixado = false
var pulando = false
var anim_cair = false
var lastrnd

func _input(event):
	if Input.is_action_just_pressed("pause"):
		pause()

func _process(delta):
	sprite_agua.global_position.y = posicao_sprite_agua_original.y

func _on_ControladorArrasta_arrastado(chave):
	if chave == 'direita':
		controle_faixa_3d.mover_direita()
	elif chave == 'esquerda-0' or chave == 'esquerda-1':
		controle_faixa_3d.mover_esquerda()
	elif chave == 'baixo':
		controle_faixa_3d.abaixar()

func _on_AreaDano_body_entered(body: Node) -> void:
	if body.has_method('tocar_som_impacto'):
		if not body.is_in_group('obstaculo'):
			body.tocar_som_impacto(false)
		if imune and body.is_in_group('obstaculo'):
			body.tocar_som_impacto(imune)
	
	if body.is_in_group("terrestre") and not imune and not pulando:
		vida.receber_dano(1.0)
		_gerar_fala_de_dano()
		imunidade(true, tempo_imunidade_dano)
		if body.has_method('tocar_som_impacto'):
			body.tocar_som_impacto(false)
	if body.is_in_group("aereo") and not imune and not abaixado:
		vida.receber_dano(1.0)
		_gerar_fala_de_dano()
		imunidade(true, tempo_imunidade_dano)
		if body.has_method('tocar_som_impacto'):
			body.tocar_som_impacto(false)
	if body.is_in_group("invencibilidade"):
		body.queue_free()
		imunidade(false, tempo_imunidade_item)
	if body.is_in_group("vida"):
		body.queue_free()
		vida.curar(1.0)
	if body.is_in_group("rampa"):
		controle_faixa_3d.pular()

func _on_Vida_vida_acabou() -> void:
	TrocadorDeCenas.trocar_cena('res://recursos/Menu_principal/TelasExtras/Tela_Derrota.tscn')

func imunidade(dano: bool, tempo: float):
	if imune:
		finaliza_imunidade()
	imunidade_time = tempo
	imune_dano = dano
	imune = true
	timer_imunidade.start()
	if not dano:
		imunidade_particulas.visible = true
		AudioServer.set_bus_mute(AudioServer.get_bus_index("BGM Track"), true)
		$ImunidadeBGM.play()

func _on_TimerImunidade_timeout():
	if imune_dano:
		sprite.visible = not sprite.visible
		sprite_agua.visible = not sprite_agua.visible
	else:
		imunidade_modulate = not imunidade_modulate
		if imunidade_modulate:
			sprite.modulate = Color(1.5, 1.5, 1)
		else:
			sprite.modulate = Color(1, 1, 1)
	imunidade_time = imunidade_time - timer_imunidade.wait_time
	if imunidade_time <= 0:
		finaliza_imunidade()

func finaliza_imunidade():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("BGM Track"), false)
	$ImunidadeBGM.stop()
	imunidade_particulas.visible = false
	sprite.visible = true
	sprite_agua.visible = true
	imune = false
	imune_dano = false
	imunidade_modulate = false
	sprite.modulate = Color(1, 1, 1)
	timer_imunidade.stop()
	

func pause():
	var instance = menuOpcoes.instance()
	add_child(instance)

func _on_ControleFaixa3D_pulou():
	sprite.play("pulo")
	sprite_agua.play("Pular")
	pulando = true

func _on_ControleFaixa3D_caindo():
	sprite_agua.visible = false

func _on_ControleFaixa3D_no_chao():
	sprite_agua.visible = true
	sprite.play("idle")
	sprite_agua.play("Cair")
	anim_cair = true
	pulando = false

func _on_ControleFaixa3D_abaixou():
	sprite.play("agachamento")
	sprite_agua.play("Agachamento")
	abaixado = true

func _on_ControleFaixa3D_levantou():
	sprite.play("idle")
	sprite_agua.play("Idle")
	abaixado = false

func _on_Sprite_animation_finished():
	if(abaixado):
		sprite.frame = 6
		sprite.stop()

func _on_SpriteAgua_animation_finished():
	if anim_cair:
		anim_cair = false
		sprite_agua.play("Idle")

func _gerar_fala_de_dano():
	randomize()
	var rndbalao = randi() % 4 + 1
	if rndbalao == lastrnd:
		randomize()
		rndbalao = randi() % 4 + 1
	print(rndbalao)
	lastrnd = rndbalao
	BaloesDeFalha.texture = texturas[rndbalao - 1]
	_animar_tween_balao("Aparecer")
	$BalaoDeFala/DeixarInvisivel.start(1.2)
	yield($BalaoDeFala/DeixarInvisivel, 'timeout')
	_animar_tween_balao("Desaparecer")

func _animar_tween_balao(anim):
	if anim == "Aparecer":
		BaloesDeFalha.visible = true
		TweenBalao.interpolate_property(BaloesDeFalha, "scale", Vector3(0.54, 0.54, 0.54), Vector3(0.71, 0.71, 0.71), tempo_tela_balao, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		TweenBalao.start()
	elif anim == "Desaparecer":
		TweenBalao.interpolate_property(BaloesDeFalha, "scale", Vector3(0.71, 0.71, 0.71), Vector3(0.54, 0.54, 0.54), tempo_tela_balao, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		TweenBalao.start()
		yield(TweenBalao, "tween_completed")
		BaloesDeFalha.visible = false
