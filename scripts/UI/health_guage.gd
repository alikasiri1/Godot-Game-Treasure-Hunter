extends Control

@export var max_pixels : int = 76
@onready var _fill : TextureRect = $Fill

func set_value(percentage : float):
	_fill.size.x = max_pixels * percentage
	
func _ready() -> void:
	pass # Replace with function body.
