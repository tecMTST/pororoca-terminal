extends CanvasLayer

onready var SingletonGlobal = SingletonOpcoesGlobais
onready var menu: TextureRect = $MenuDeOpcoes/Menu
onready var musicaWheel: HSlider = $MenuDeOpcoes/Menu/VolumeMusica
onready var efeitosWheel: HSlider = $MenuDeOpcoes/Menu/VolumeEfeitos
onready var porcentagemMusicaWheel: Label = $MenuDeOpcoes/Menu/Porcentagem
onready var porcentagemEfeitosWheel: Label = $MenuDeOpcoes/Menu/Porcentagem2
onready var voltarmenu: TextureButton = $MenuDeOpcoes/Menu/VoltarMenu
onready var voltarjogo: TextureButton = $MenuDeOpcoes/Menu/VoltarJogo
onready var menu_instrucoes = preload("res://recursos/Menu_principal/TelasExtras/Instrucoes.tscn")
onready var audio_stream_sfx = $MenuDeOpcoes/AudioStreamSFX
onready var cena_nodes = get_tree().get_nodes_in_group("Enchente")

export var menupath: String = 'res://recursos/Menu_principal/Menu_Principal.tscn'

func _ready():
	VisualServer.set_shader_time_scale(0.0)
	print(SingletonGlobal.ativarBotoes)
	get_tree().paused = true

	musicaWheel.value = SingletonGlobal.volumeSom
	porcentagemMusicaWheel.text = str(musicaWheel.value) + '%'

	efeitosWheel.value = SingletonGlobal.volumeSFX
	porcentagemEfeitosWheel.text = str(efeitosWheel.value) + '%'

	if cena_nodes:
		voltarjogo.visible = true
	else:
		voltarjogo.visible = false

	voltarjogo.connect("button_down", self, "_on_button_down_sound")
	voltarmenu.connect("button_down", self, "_on_button_down_sound")

func _input(event):
	var valorMusicaGlobal = musicaWheel.value
	var valorSfxGlobal = efeitosWheel.value
	if event is InputEventScreenTouch:
		#envia para o singleton o valor de som e de musica
		SingletonGlobal.volumeSom = valorMusicaGlobal
		SingletonGlobal.volumeSFX = valorSfxGlobal
		SingletonOpcoesGlobais.salvar_globais()

func _on_VoltarJogo_button_up():
	VisualServer.set_shader_time_scale(1)
	get_tree().paused = false
	self.queue_free()

func _on_VoltarMenu_button_up():
	VisualServer.set_shader_time_scale(1)
	if cena_nodes:
		get_tree().paused = false
		TrocadorDeCenas.trocar_cena(menupath)
		self.queue_free()
	else:
		VisualServer.set_shader_time_scale(1)
		get_tree().paused = false
		self.queue_free()

func _process(delta):
	porcentagemMusicaWheel.text = str(musicaWheel.value) + '%'
	porcentagemEfeitosWheel.text = str(efeitosWheel.value) + '%'


func _on_ReiniciarCutscene_button_up():
	SingletonOpcoesGlobais.pularCutScene = false
	SingletonOpcoesGlobais.pularTutorial = false
	SingletonOpcoesGlobais.salvar_globais()

func _on_Instrucoes_button_up():
	var loadinstrucoes = menu_instrucoes.instance()
	get_tree().get_root().add_child(loadinstrucoes)
	self.queue_free()

func _on_button_down_sound():
	audio_stream_sfx.stream.loop = false
	audio_stream_sfx.play()
