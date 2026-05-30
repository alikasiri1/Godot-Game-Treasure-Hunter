extends Camera2D
class_name Camera

@export var _subject : Node2D
@export var following_offset : Vector2
@export var direction_x_change_speed : float = 2  # Smooth transition speed

var _look_ahead_distance : float 
var _vertival_movement : float
var _target_facing_left : bool
var _horizontal_tween : Tween
var _vertical_tween : Tween

func _ready() -> void:
	following_offset *= Global.ppt
	_target_facing_left = _subject._is_facing_left
	position.y = _subject.position.y + following_offset.y 


func _process(delta: float) -> void:
	_horizontal_tween = create_tween()
	_horizontal_tween.tween_property(self, "_look_ahead_distance" , following_offset.x * (-1 if _subject._is_facing_left else 1) , direction_x_change_speed)
	self.position.x = _subject.position.x + _look_ahead_distance
	

	#if _subject.is_on_floor():
	_vertical_tween = create_tween()
	_vertical_tween.tween_property(self, "_vertival_movement" , _subject.position.y + following_offset.y ,1)
	self.position.y = _vertival_movement


func set_bounds(min_boundary: Vector2, max_boundary : Vector2):
	self.limit_left = min_boundary.x
	self.limit_top = min_boundary.y
	self.limit_right = max_boundary.x
	self.limit_bottom = max_boundary.y
	
