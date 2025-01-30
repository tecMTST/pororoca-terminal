extends Spatial

signal animacaoTerminou

onready var timerDoTempoDeEspera: Timer = $TimerDoTempoDeEspera
onready var tween := $Tween

export var tempoDeEsperaPrimeiraFase: int = 25 #em segundos
export var tempoDeEsperaSegundaFase: int = 25 #em segundos

var faseAtual: int = 0
var ativadoPorSinal: bool = false

func _ready() -> void:
	EnchenteEstadoDeJogo.connect('iniciou', self, '_iniciar')

func _iniciar() -> void:
	timerDoTempoDeEspera.start()

func _mover_cidade() -> void:
	var posicao_inicial := Vector3(0,-15.0, 0)
	var posicao_final := Vector3(0, 23.0, 0)
	var tempo_transicao := EnchenteEstadoDeJogo.TemporizadorGlobal.wait_time - 60
	tween.interpolate_property($SpriteCidade, "position", posicao_inicial, posicao_final, tempo_transicao, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
