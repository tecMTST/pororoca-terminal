extends Control

export(NodePath) var componente_com_vida
export(Texture) var textura_icone
export(StreamTexture) var textura_icone_desabilitada
export var tamanho_icone := 32.0

onready var vida := get_node(componente_com_vida).vida as Vida
onready var icone := TextureRect.new()
onready var icones := $Vidas as HBoxContainer
onready var barraprogresso = get_node("/root/Enchente/BarraDeProgresso")

func _ready() -> void:
	icone.texture = textura_icone
	icone.expand = true
	icone.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icone.rect_min_size = Vector2(tamanho_icone, tamanho_icone)
	_vida_maxima_alterada(Vida.VidaMaximaAlterada.new(0, vida.vida_maxima))

	vida.connect('vida_alterada', self, '_vida_alterada')

func _vida_maxima_alterada(vida_maxima_alterada: Vida.VidaMaximaAlterada) -> void:
	if vida_maxima_alterada.diferenca > 0:
		for _i in range(vida_maxima_alterada.diferenca):
			icones.add_child(icone.duplicate())
	else:
		for _i in range( - vida_maxima_alterada.diferenca):
			icones.remove(icones)

func _vida_alterada(vida_alterada: Vida.VidaAlterada) -> void:
	for icone_vida in icones.get_children():
		if icone_vida.get_index() < vida_alterada.vida_atual:
			icone_vida.texture = textura_icone
		else:
			icone_vida.texture = textura_icone_desabilitada

func _process(delta):
	if barraprogresso.has_method("enviar_pos"):
		var progressopos = barraprogresso.enviar_pos()
		self.rect_position = Vector2((progressopos.x + 250), (progressopos.y + 100))
