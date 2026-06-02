extends Character
class_name Enemy

@onready var _vision : Area2D = $Vision
@onready var _line_of_sight : RayCast2D = $Vision/LineOfSight
@onready var _patrol : Patrol = get_node_or_null("Patrol")

var _can_see_player : bool
var _hero : Hero
	
func _process(_delta: float) -> void:
	if _hero:
		_line_of_sight.target_position = _hero.global_position - global_position
		
		if not _is_facing_left:
			_line_of_sight.target_position.x *= -1
			
		if _line_of_sight.is_colliding() and _line_of_sight.get_collider() == _hero:
			_see_hero(true)
		else:
			_see_hero(false)
	else:
		_see_hero(false) 
	
	if _can_see_player:
		run(sign(_hero.global_position.x - global_position.x)*3)
	
func _see_hero(can_now_see_hero : bool):
	if not _can_see_player and can_now_see_hero:
		_can_see_player = true
		if _patrol:
			_patrol.pause((_hero.global_position - global_position).normalized())
		if _hero.global_position.x < global_position.x:
			face_left()
		elif _hero.global_position.x > global_position.x:
			face_right()
			
	elif _can_see_player and not can_now_see_hero:
		_can_see_player = false
		if _patrol:
			_patrol.resume()
			
func face_left():
	super.face_left()
	_vision.scale.x = 1
	
func face_right():
	super.face_right()
	_vision.scale.x = -1
	
func _on_vision_body_entered(body: Node2D) -> void:
	if body is Hero:
		print(body.name)
		_hero = body

func _on_vision_body_exited(body: Node2D) -> void:
	if body is Hero:
		_hero = null


func _on_target_area_entered(area: Area2D) -> void:
	attack()
