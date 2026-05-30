extends Area2D
class_name GameLevel
@onready var _area : CollisionShape2D = $CollisionShape2D
@onready var _half_area_size : Vector2 = _area.shape.get_rect().size / 2

func get_min():
	print(_area.shape.get_rect().size)
	return _area.position - _half_area_size
	
func get_max():
	return _area.position + _half_area_size
	
