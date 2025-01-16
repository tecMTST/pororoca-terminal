extends Spatial

export(Array, StreamTexture) var texturas_de_ataque

onready var faixa_1 = $Faixas/Faixa1
onready var faixa_2 = $Faixas/Faixa2
onready var faixa_3 = $Faixas/Faixa3
onready var origem_obstaculos = $OrigemObstaculos
onready var timer_do_Ataque = $Timers/TimerAtaque
onready var timer_modulo = $Timers/TimerModos
onready var boss_sprite = $Sprites/SpriteChefao
onready var Tentaculos = preload("res://recursos/jogos/enchente/chefao/Tentaculos.tscn")
onready var BombasChefe = preload("res://recursos/jogos/enchente/chefao/BombasChefe.tscn")
onready var Alerta = preload("res://recursos/jogos/enchente/chefao/Alerta.tscn")
onready var Animplayer = $Sprites/SpriteChefao/AnimationPlayer
onready var audio_stream_player_sfx = $AudioStreamPlayerSFX
onready var balao_de_ataque = $Sprites/BalaoDeAtaque
onready var timer_balao = $Sprites/BalaoDeAtaque/DeixarInvisivel
onready var tween_balao = $Sprites/BalaoDeAtaque/TweenBalao

signal Chefao_Derrotado

#	"tipo_de_obstaculo": {
#		"1": "mina_aquatica",
#		"2": "tentaculo"

enum ModulosDisponiveis {
	vinte_sec,
	quarenta_sec,
	sessenta_sec,
	acabou
}

var ModuloAtual
var lista_posicoes
var timer_atual: int = 0 # maximo é 3
var CAMINHO_MODULO = 'res://recursos/jogos/enchente/chefao/modulos.json'
var conteudo_total_modulo = loadJson(CAMINHO_MODULO)

func _ready():
	#print(conteudo_total_modulo)
	#print(timer_atual)
	Animplayer.play("in_out")
	yield(Animplayer, "animation_finished")
	Animplayer.play("Idle")
	_mudaModulo()
	adicionar_lista('20_sec', 1)
	timer_modulo.start(28)

func adicionar_lista(modulo_atual, ataque):
	#print(modulo_atual)
	var Id_conteudo_modulo = conteudo_total_modulo.get(String(modulo_atual))
	lista_posicoes = Id_conteudo_modulo.get(String(ataque))
	if ModuloAtual == ModulosDisponiveis.sessenta_sec:
		lista_posicoes += Id_conteudo_modulo.get(String(ataque) + String('_1'))
	#print(lista_posicoes)
#		if item.has(modulo_atual):

func _on_TimerModos_timeout():
	timer_atual += 1
	print(timer_atual)

func _mudaModulo():
	if timer_atual == 0:
		ModuloAtual = ModulosDisponiveis.vinte_sec
	elif timer_atual == 1:
		ModuloAtual = ModulosDisponiveis.quarenta_sec
	elif timer_atual == 2:
		ModuloAtual = ModulosDisponiveis.sessenta_sec
	elif timer_atual == 3:
		ModuloAtual = ModulosDisponiveis.acabou
		timer_modulo.stop()

func _realizar_acao():
	randomize()
	var random_ataque = randi() % 3 + 1
	match ModuloAtual:
		ModulosDisponiveis.vinte_sec:
			adicionar_lista("20_sec", random_ataque)
			_realizar_ataque()
		ModulosDisponiveis.quarenta_sec:
			adicionar_lista("40_sec", random_ataque)
			_realizar_ataque()
		ModulosDisponiveis.sessenta_sec:
			adicionar_lista("60_sec", random_ataque)
			_realizar_ataque()
		ModulosDisponiveis.acabou:
			_auto_destruir()

	timer_do_Ataque.start(7)
	_mudaModulo()

func _on_TimerAtaque_timeout():
	_realizar_acao()
	
func animacao(animacao):
	Animplayer.play(animacao)

func _realizar_ataque():
	var lane_atual = 1
	var animacao_ataque_feita = false

	for obj_pos in lista_posicoes:
		var instanciaMinaAquatica = BombasChefe.instance() as KinematicBody
		var instanciaTentaculo = Tentaculos.instance() as KinematicBody
		var instanciaAlerta = Alerta.instance()
		#print(obj_pos)
		if lane_atual == 4:
			yield(get_tree().create_timer(0.3), "timeout")
			animacao("Idle")
			lane_atual = 1

		if obj_pos == 0:
			instanciaMinaAquatica.queue_free()
			instanciaTentaculo.queue_free()

		elif obj_pos == 1:
			_gerar_fala_de_ataque(1)
			yield(get_tree().create_timer(1), "timeout")
			add_child(instanciaMinaAquatica)
			add_child(instanciaAlerta)
			if animacao_ataque_feita == false:
				animacao("Ataque_bombas")
				animacao_ataque_feita = true
			if lane_atual == 1:
				instanciaMinaAquatica.global_position = faixa_1.global_position
				instanciaAlerta.global_position = faixa_1.global_position
			elif lane_atual == 2:
				instanciaMinaAquatica.global_position = faixa_2.global_position
				instanciaAlerta.global_position = faixa_2.global_position
			elif lane_atual == 3:
				instanciaMinaAquatica.global_position = faixa_3.global_position
				instanciaAlerta.global_position = faixa_3.global_position
			yield(Animplayer, "animation_finished")
			animacao("Idle")

		elif obj_pos == 2:
			_gerar_fala_de_ataque(0)
			yield(get_tree().create_timer(1), "timeout")
			add_child(instanciaTentaculo)
			add_child(instanciaAlerta)
			if animacao_ataque_feita == false:
				animacao("Ataque_tentaculo")
				animacao_ataque_feita = true
			if lane_atual == 1:
				instanciaTentaculo.global_position = faixa_1.global_position
				instanciaAlerta.global_position = faixa_1.global_position
			elif lane_atual == 2:
				instanciaTentaculo.global_position = faixa_2.global_position
				instanciaAlerta.global_position = faixa_2.global_position
			elif lane_atual == 3:
				instanciaTentaculo.global_position = faixa_3.global_position
				instanciaAlerta.global_position = faixa_3.global_position
			yield(Animplayer, "animation_finished")
			animacao("Idle")
		lane_atual += 1
		animacao_ataque_feita = false

func loadJson(nomejson):
	var arquivo = File.new()
	if arquivo.file_exists(nomejson):
		arquivo.open(nomejson, arquivo.READ)
		var conteudo = parse_json(arquivo.get_as_text())
		if conteudo == null:
			print("Could not parse " + nomejson + " as JSON." + \
			"Porfavor cheque se o path está certo.")
		#print(conteudo)
		return conteudo
	else:
		print("File Open Error: could not open file " + nomejson)
	arquivo.close()

func _auto_destruir():
	Animplayer.play_backwards("in_out")
	audio_stream_player_sfx.tocar_sfx("chefe-morte")
	yield(get_tree().create_timer(0.7), "timeout")
	emit_signal("Chefao_Derrotado")
	yield(get_tree().create_timer(2), "timeout")
	TrocadorDeCenas.trocar_cena('res://recursos/Menu_principal/TelasExtras/Tela_Vitoria.tscn')

func _gerar_fala_de_ataque(num_ataque):
	balao_de_ataque.texture = texturas_de_ataque[num_ataque]
	_animar_tween_balao("Aparecer")
	timer_balao.start(1.2)
	yield(timer_balao, 'timeout')
	_animar_tween_balao("Desaparecer")

func _animar_tween_balao(anim):
	if anim == "Aparecer":
		tween_balao.interpolate_property(balao_de_ataque, "scale", Vector3(1.9, 1.9, 1.9), Vector3(2.5, 2.5, 2.5), 1.2, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		tween_balao.start()
		balao_de_ataque.visible = true
	elif anim == "Desaparecer":
		tween_balao.interpolate_property(balao_de_ataque, "scale", Vector3(2.5, 2.5, 2.5), Vector3(1.9, 1.9, 1.9), 1.2, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		tween_balao.start()
		yield(tween_balao, "tween_completed")
		balao_de_ataque.visible = false
