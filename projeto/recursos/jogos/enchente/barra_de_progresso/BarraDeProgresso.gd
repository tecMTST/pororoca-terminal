extends Control

signal tempo_acabado

export(NodePath) var tempo

onready var _tempo := get_node(tempo) as Timer
onready var barra = $ProgressoDeTextura

# Called when the node enters the scene tree for the first time.
func _ready():
	_tempo.connect("timeout", self, "_ao_tempo_acabar")


func _process(delta):
	barra.value = 2 * barra.rect_size.x * (1 - _tempo.time_left / _tempo.wait_time)


func _ao_tempo_acabar():
	emit_signal("tempo_acabado")
