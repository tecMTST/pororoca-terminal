extends Spatial

export(Array, StreamTexture) var texturas_de_ataque
export(StreamTexture) var textura_entrada_saida
export var tamanho_balao_ataque_max: float = 0.85
export var tamanho_balao_ataque_min: float = 0.3

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
var ultima_posicao: int = 1
var timer_atual: int = 0 # maximo é 3
var CAMINHO_MODULO = 'res://recursos/jogos/enchente/chefao/modulos.json'
var conteudo_total_modulo = loadJson(CAMINHO_MODULO)

func _ready():
	EnchenteEstadoDeJogo.emit_signal("entrada_boss")
	yield(get_tree().create_timer(3.0),"timeout")
	randomize()
	boss_sprite.texture = textura_entrada_saida
	boss_sprite.visible = true
	audio_stream_player_sfx.tocar_sfx("chefe-morte")
	Animplayer.play("in_out")
	yield(Animplayer, "animation_finished")
	Animplayer.play("Idle")
	_mudaModulo()
	adicionar_lista('20_sec', 1)
	timer_modulo.start(32)

func adicionar_lista(modulo_atual, ataque):
	randomize()
	var Id_conteudo_modulo = conteudo_total_modulo.get(String(modulo_atual))
	lista_posicoes = Id_conteudo_modulo.get(String(ataque))
	if ModuloAtual == ModulosDisponiveis.sessenta_sec:
		lista_posicoes += Id_conteudo_modulo.get(String(ataque) + String('_1'))
	ultima_posicao = ataque
	#print(lista_posicoes)


func _on_TimerModos_timeout():
	timer_atual += 1
	#print(timer_atual)

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
	var random_ataque = randi() % 6 + 1
	while ultima_posicao == random_ataque:
		random_ataque = randi() % 6 + 1
	match ModuloAtual:
		ModulosDisponiveis.vinte_sec:
			adicionar_lista("20_sec", random_ataque)
			_avisar_player()
			_realizar_ataque()
		ModulosDisponiveis.quarenta_sec:
			adicionar_lista("40_sec", random_ataque)
			_avisar_player()
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

func _avisar_player():
	var lane_atual = 1
	var animacao_ataque_feita = false
	for obj_pos in lista_posicoes:
		var instanciaAlerta = Alerta.instance()

		if lane_atual == 4:
			lane_atual = 1

		elif obj_pos == 1:
			add_child(instanciaAlerta)
			if lane_atual == 1:
				instanciaAlerta.global_position = faixa_1.global_position
			elif lane_atual == 2:
				instanciaAlerta.global_position = faixa_2.global_position
			elif lane_atual == 3:
				instanciaAlerta.global_position = faixa_3.global_position

		elif obj_pos == 2:
			add_child(instanciaAlerta)
			if lane_atual == 1:
				instanciaAlerta.global_position = faixa_1.global_position
			elif lane_atual == 2:
				instanciaAlerta.global_position = faixa_2.global_position
			elif lane_atual == 3:
				instanciaAlerta.global_position = faixa_3.global_position

		lane_atual += 1
		animacao_ataque_feita = false

func _realizar_ataque():
	var lane_atual = 1
	var animacao_ataque_feita = false

	for obj_pos in lista_posicoes:
		var instanciaMinaAquatica = BombasChefe.instance()
		var instanciaTentaculo = Tentaculos.instance()

		if lane_atual == 4:
			var idle_timer = get_tree().create_timer(0.45)
			yield(idle_timer, "timeout")
			animacao("Idle")
			lane_atual = 1

		if obj_pos == 0:
			if instanciaMinaAquatica:
				instanciaMinaAquatica.queue_free()
			if instanciaTentaculo:
				instanciaTentaculo.queue_free()

		elif obj_pos == 1:
			_gerar_fala_de_ataque(1)
			var mina_timer = get_tree().create_timer(1)
			yield(mina_timer, "timeout")
			add_child(instanciaMinaAquatica)
			if animacao_ataque_feita == false:
				animacao("Ataque_bombas")
				animacao_ataque_feita = true
			if lane_atual == 1:
				instanciaMinaAquatica.global_position = Vector3(faixa_1.global_position.x, origem_obstaculos.global_position.y, origem_obstaculos.global_position.z)
			elif lane_atual == 2:
				instanciaMinaAquatica.global_position = Vector3(faixa_2.global_position.x, origem_obstaculos.global_position.y, origem_obstaculos.global_position.z)
			elif lane_atual == 3:
				instanciaMinaAquatica.global_position = Vector3(faixa_3.global_position.x, origem_obstaculos.global_position.y, origem_obstaculos.global_position.z)

			yield(Animplayer, "animation_finished")
			animacao("Idle")

		elif obj_pos == 2:
			_gerar_fala_de_ataque(0)
			var tentaculo_timer = get_tree().create_timer(1)
			yield(tentaculo_timer, "timeout")
			add_child(instanciaTentaculo)
			if animacao_ataque_feita == false:
				animacao("Ataque_tentaculo")
				animacao_ataque_feita = true
			if lane_atual == 1:
				instanciaTentaculo.global_position = faixa_1.global_position
			elif lane_atual == 2:
				instanciaTentaculo.global_position = faixa_2.global_position
			elif lane_atual == 3:
				instanciaTentaculo.global_position = faixa_3.global_position
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
	$Sprites/SpriteChefao/tweenchefao.interpolate_property(boss_sprite, "translation", Vector3(boss_sprite.translation.x, boss_sprite.translation.y, boss_sprite.translation.z), Vector3(boss_sprite.translation.x, - 5, boss_sprite.translation.z), 2.6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Sprites/SpriteChefao/tweenchefao.start()
	yield(Animplayer, "animation_finished")
	yield($Sprites/SpriteChefao/tweenchefao, "tween_completed")
	boss_sprite.texture = textura_entrada_saida
	boss_sprite.visible = false
	$Sprites/Onda/TweenOnda.interpolate_property($Sprites/Onda, "scale", $Sprites/Onda.scale, Vector3($Sprites/Onda.scale.x, 1, $Sprites/Onda.scale.z), 1.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Sprites/Onda/TweenOnda.start()
	yield($Sprites/Onda/TweenOnda, "tween_completed")
	$Sprites/Onda.visible = false
	audio_stream_player_sfx.tocar_sfx("chefe-morte")
	var derrota_timer = get_tree().create_timer(0.7)
	yield(derrota_timer, "timeout")
	emit_signal("Chefao_Derrotado")
	var trocar_cena_timer = get_tree().create_timer(3.5)
	yield(trocar_cena_timer, "timeout")
	TrocadorDeCenas.trocar_cena('res://recursos/Menu_principal/TelasExtras/Tela_Vitoria.tscn')

func _gerar_fala_de_ataque(num_ataque):
	balao_de_ataque.texture = texturas_de_ataque[num_ataque]
	_animar_tween_balao("Aparecer")
	timer_balao.start(1)
	yield(timer_balao, 'timeout')
	_animar_tween_balao("Desaparecer")

func _animar_tween_balao(anim):
	if anim == "Aparecer":
		tween_balao.interpolate_property(balao_de_ataque, "scale", Vector3(tamanho_balao_ataque_min, tamanho_balao_ataque_min, tamanho_balao_ataque_min), Vector3(tamanho_balao_ataque_max, tamanho_balao_ataque_max, tamanho_balao_ataque_max), 0.6, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		tween_balao.start()
		balao_de_ataque.visible = true
	elif anim == "Desaparecer":
		tween_balao.interpolate_property(balao_de_ataque, "scale", Vector3(tamanho_balao_ataque_max, tamanho_balao_ataque_max, tamanho_balao_ataque_max), Vector3(tamanho_balao_ataque_min, tamanho_balao_ataque_min, tamanho_balao_ataque_min), 0.6, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		tween_balao.start()
		yield(tween_balao, "tween_completed")
		balao_de_ataque.visible = false
