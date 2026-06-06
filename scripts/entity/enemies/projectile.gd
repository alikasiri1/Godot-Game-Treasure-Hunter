extends Node2D
class_name Projectile


@onready var _sprite : Sprite2D = $Sprite2D
@onready var _timer : Timer = $Timer
@onready var _collision_shape : CollisionShape2D = $CollisionShape2D
@onready var rigid_collision_shape : CollisionShape2D = $RigidBody2D/CollisionShape2D

var _direction : Vector2
var _speed : float 
var _damage : float
var _is_destroyed : bool 

func fire(direction : Vector2 , speed: float , damage: float, duration: float):
	_direction = direction
	_speed = speed
	_damage = damage
	if duration > 0:
		_timer.start(duration)
		
func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	if not _is_destroyed: 
		position += _direction * _speed * delta

func _on_area_entered(area: Area2D) -> void:
	#print('area ', area)
	if area.name == "Level":
		return
	self.hide()

	_collision_shape.set_deferred("disabled" , true)
	#_collision_shape.disabled = true
	var _character = area.get_parent()
	if _character is Character:
		_character.health_component.apply_damage(_damage , (area.global_position - global_position).normalized())
	queue_free()

#func _on_body_entered(body: Node2D) -> void:
	#print(body)
	#self.hide()
	#_collision_shape.disabled = true
	#var _character = body
	#if _character is Character:
		#_character.health_component.apply_damage(_damage , (body.global_position - global_position).normalized())
	#queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await get_tree().create_timer(1).timeout
	queue_free()


func _on_rigid_body_2d_body_entered(body: Node) -> void:
	self.hide()
	rigid_collision_shape.disabled = true
	queue_free()
