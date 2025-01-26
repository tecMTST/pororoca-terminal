extends Node

signal iniciou()
signal trocou_fase(fase)
signal nova_velocidade()
signal dano_jogador(vida)

var VelocidadeGlobal = 1.0
var DictVelocidades: Dictionary = {}
var TemporizadorGlobal := Timer.new()
var TempoAtual := 0.0
var fase := 1

func _process(_delta: float) -> void:
	TempoAtual = TemporizadorGlobal.wait_time - TemporizadorGlobal.time_left
	var floor_tempo = str(floor(TempoAtual))
	if floor_tempo in DictVelocidades:
		VelocidadeGlobal = DictVelocidades[floor_tempo]
		emit_signal("nova_velocidade")
	var checar_fase = int(TempoAtual / 60) + 1  # verificar outra forma de fazer isso
	if checar_fase > fase:
		fase = checar_fase
		emit_signal('trocou_fase',fase)

func reset() -> void:
	TempoAtual = 0
	fase = 1

func definir_tempo_de_jogo(tempo: float) -> void:
	TemporizadorGlobal.wait_time = tempo

func iniciar_temporizador() -> void:
	TemporizadorGlobal.start()
	emit_signal('iniciou')
