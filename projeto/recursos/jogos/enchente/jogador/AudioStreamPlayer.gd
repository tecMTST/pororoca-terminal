extends AudioStreamPlayer

var _volume_atual = 999

func _ready():
	# garante que o loop do audio permaneça inativo no caso de faixas mp3
	for grupoSFX in clipesSFX:
		for audio in clipesSFX[grupoSFX]:
			if audio is AudioStreamMP3:
				audio.loop = false

#Array de clipes de audio:
onready var clipesSFX = {
	"trocaFaixa": [
		preload ("res://elementos/audio/sfx/personagem/personagem-mov1.mp3"),
		preload ("res://elementos/audio/sfx/personagem/personagem-mov2.mp3"),
		preload ("res://elementos/audio/sfx/personagem/personagem-mov3.mp3"),
		preload ("res://elementos/audio/sfx/personagem/personagem-mov4.mp3"),
	],
	"pulo": [
		preload('res://elementos/audio/sfx/personagem/personagem-pulo.mp3'),
	],
	"queda": [
		preload("res://elementos/audio/sfx/personagem/personagem-queda.mp3")
	],
	"agachar": [
		preload('res://elementos/audio/sfx/personagem/personagem-agachar.mp3')
	],
	"levantar": [
		preload("res://elementos/audio/sfx/personagem/personagem-levantar.mp3")
	],
	"risada": [
		preload('res://elementos/audio/sfx/personagem/personagem-risada1.mp3'),
		preload('res://elementos/audio/sfx/personagem/personagem-risada2.mp3')
	]
	}

#Gerador de número randômico:
var rng = RandomNumberGenerator.new()

#Gatilho de troca de faixa:
func _on_ControleFaixa3D_iniciou_movimento(_direcao, _alvo) -> void:
	stop()
	stream = clipesSFX.trocaFaixa[rng.randi_range(0, clipesSFX.trocaFaixa.size() -1)]
	play()

func som_jogador(acao: String) -> void:
	stop()
	stream = clipesSFX[acao][rng.randi_range(0, clipesSFX[acao].size() -1)]
	play()

func _on_ControleFaixa3D_abaixou() -> void:
	som_jogador('agachar')

func _on_ControleFaixa3D_levantou():
	som_jogador('levantar')

func _on_ControleFaixa3D_pulou() -> void:
	som_jogador('pulo')

func _on_ControleFaixa3D_no_chao() -> void:
	som_jogador('queda')
