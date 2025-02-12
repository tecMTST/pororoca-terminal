extends Spatial

# Tempo de jogo em minutos
export var tempo_jogo = 5

onready var player_lane_3d = $playerLane3D as PlayerLane3D
onready var faixa_1 = $Faixas/Faixa1
onready var faixa_2 = $Faixas/Faixa2
onready var faixa_3 = $Faixas/Faixa3
onready var fps_label = $CanvasLayer/Control/HBoxContainer/FpsLabel
onready var tempo_label = $CanvasLayer/Control/HBoxContainer/Tempo
onready var agua = $Agua
onready var audio_stream_bgm := $AudioStreamBGM
onready var audio_stream_amb := $AudioStreamAMB
onready var camera := $Camera as Camera
onready var chuva := $Chuva
onready var tamanho_tela = OS.get_screen_size()

var _volume_atual = 999

func _ready():
	player_lane_3d.controle_faixa_3d.faixas.append(faixa_1.global_position)
	player_lane_3d.controle_faixa_3d.faixas.append(faixa_2.global_position)
	player_lane_3d.controle_faixa_3d.faixas.append(faixa_3.global_position)
	player_lane_3d.controle_faixa_3d.posicao_inicial = 1

	chuva.emission_rect_extents.x = tamanho_tela.x * 2
	chuva.amount = tamanho_tela.x
	print(get_viewport().size.x)
	$Contador.visible = true
	$Contador/Animador.play("aproximar")
	yield($Contador/Animador, 'animation_finished')
	$Nivel.change_popup(1)

	EnchenteEstadoDeJogo.reset()
	EnchenteEstadoDeJogo.TemporizadorGlobal = $TempoDeJogo
	EnchenteEstadoDeJogo.definir_tempo_de_jogo(tempo_jogo * 60)
	EnchenteEstadoDeJogo.iniciar_temporizador()
	EnchenteEstadoDeJogo.set_process(true)
	EnchenteEstadoDeJogo.connect('trocou_fase', self, "_trocou_fase")
	$ControladorDeObstaculos.iniciar()
	player_lane_3d.controle_faixa_3d.connect('iniciou_movimento', camera, 'mover')
	chuva.visible = true
	audio_stream_bgm.play()

func _process(_delta):
	fps_label.text = str(Engine.get_frames_per_second())
	tempo_label.text = String(EnchenteEstadoDeJogo.TempoAtual)
	agua.get_active_material(0).set_shader_param("Velocidade", EnchenteEstadoDeJogo.VelocidadeGlobal)

func _exit_tree() -> void:
	EnchenteEstadoDeJogo.set_process(false)

func _trocou_fase(fase):
	if fase == 3:
		chuva.visible = false
		$ControladorDeObstaculos.parar()
		$ChamadaDoBoss.iniciar()
	audio_stream_bgm.mudar_musica(str(fase))
