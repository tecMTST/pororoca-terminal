extends Control

export (Array, StreamTexture) var textura_indicador
export (Array, StreamTexture) var textura_popup

onready var Indicador = $Indicador
onready var PopUp = $PopUp
onready var contador = get_node("/root/Enchente/Contador")

func _ready() -> void:
	Indicador.texture = textura_indicador[0]
	PopUp.texture = textura_popup[0]

	if contador.has_method("isPlaying"):
		if contador.isPlaying():
			PopUp.visible = false

func _process(delta):
	Indicador.rect_position = Vector2((get_viewport_rect().size.x / 2 - 20), (get_viewport_rect().size.y / 2))
