extends Node2D
class_name Patrol

enum LedgeBehaviour{
	Turn_Around,
	Walk_Off,
}

@export var _ledge_behaviour : LedgeBehaviour
@onready var _character : Character = get_parent()
@onready var _floor_ray : RayCast2D = $RayCast2D
@onready var _is_patrolling : bool = true
var _direction : float

func _ready() -> void:
	_direction = 1 if _character.is_facing_left() else -1
	_set_floor_ray_position()
func _set_floor_ray_position():
	_floor_ray.position.x = (Global.ppt/1.5 ) *_direction
	
func pause(direction):
	_is_patrolling = false
	_direction = direction.x
	_character.run(0)
	
func resume():
	_is_patrolling = true

func _process(delta: float) -> void:
	if not _is_patrolling:
		return
	if _character.is_on_wall():
		_direction = sign(_character.get_wall_normal().x)
		_set_floor_ray_position()
	
	if _character.is_on_floor() and not _floor_ray.is_colliding():
		_ledge_detected()
		
	_character.run(_direction)
	
func _ledge_detected():
	match  _ledge_behaviour:
		LedgeBehaviour.Turn_Around:
			_direction *= -1
			_set_floor_ray_position()
		LedgeBehaviour.Walk_Off:
			return
