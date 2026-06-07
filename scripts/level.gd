extends Area2D
class_name GameLevel

@export_range(0, 5) var desired_volume : float = 0.3
@export var music : AudioStream
@export var background_sound : AudioStream
@onready var _area : CollisionShape2D = $CollisionShape2D
@onready var _half_area_size : Vector2 = _area.shape.get_rect().size / 2

var _checkpoints : Array[Node]

func _ready() -> void:
	_checkpoints = $CheckPoints.get_children()
	
	for i in _checkpoints.size():
		if _checkpoints[i] is CheckPoint:
			_checkpoints[i].id = i
			
func get_checkpoint_position(checkpoint_id : int):
	if checkpoint_id >=0 and checkpoint_id < _checkpoints.size():
		return _checkpoints[checkpoint_id].global_position
	
	return Vector2.ZERO
	
func get_min():
	print(_area.shape.get_rect().size)
	return _area.position - _half_area_size
	
func get_max():
	return _area.position + _half_area_size
	
