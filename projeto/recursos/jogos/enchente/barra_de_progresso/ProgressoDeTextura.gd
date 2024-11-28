extends TextureProgress


onready var icone = $Icone


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var progresso = value / max_value
	var largura = .get_rect().size.x
	icone.position.x = largura * progresso
