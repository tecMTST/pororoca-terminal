extends Control

onready var dialog_container = $DialogContainer
onready var mascara = $Pre/Mascara
onready var tween_inicio = $TweenInicio
export var menupath: String = 'res://recursos/Menu_principal/Menu_Principal.tscn'
onready var pos = $Pos

func _ready():
	inicia_dialogo()


func inicia_dialogo():
	tween_inicio.interpolate_property(mascara, "modulate:a", 1.0, 0.0, 0.5)
	tween_inicio.start()
	yield(get_tree().create_timer(0.5), "timeout")
	var dialog = Dialogic.start("enchente-fim")
	dialog.connect("dialogic_signal", self, "_on_dialogic_signal")
	dialog_container.add_child(dialog)

func _on_BotaoPular_button_up():
	finalizar()

func _on_dialogic_signal(arg):
	match arg:
		"meio":
			tween_inicio.interpolate_property(mascara, "modulate:a", 0.0, 1.0, 0.5)
			tween_inicio.start()			
			yield(get_tree().create_timer(0.5), "timeout")
			pos.visible = true
			tween_inicio.interpolate_property(mascara, "modulate:a", 1.0, 0.0, 0.5)
			tween_inicio.start()			
			yield(get_tree().create_timer(0.5), "timeout")						
		"fim":
			finalizar()
			
func finalizar():
	TrocadorDeCenas.trocar_cena(menupath)	
