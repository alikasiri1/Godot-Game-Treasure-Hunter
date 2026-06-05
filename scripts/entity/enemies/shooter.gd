extends Enemy
class_name Shooter

@export var _projectile : PackedScene 
@export_range(0 , 100) var _p_speed : float = 10
@export_range(0 , 100) var _p_damage : float = 0.5
@export var _p_duration : float = 10
@onready var _p_origin : Node2D = $ProjectileOrigin

var _want_to_fire : bool 

func fire():
	_want_to_fire = true
	
func _ready() -> void:
	super._ready()
	_p_speed = Global.ppt * _p_speed
	
func _spawn_projectile():
	var projectile : Projectile = _projectile.instantiate()
	projectile.global_position = _p_origin.global_position
	#get_parent().add_child(projectile)
	Global.play_scene.add_child(projectile)
	projectile.fire(Vector2.LEFT if is_facing_left else Vector2.RIGHT ,_p_speed , _p_damage , _p_duration )
	

func _change_want_fire(value : bool):
	_want_to_fire = value


func _on_died() -> void:
	print('here should be treasure')
	await get_tree().create_timer(10).timeout
	queue_free()
	#var projectile : Projectile = _projectile.instantiate()
	#projectile.global_position = _p_origin.global_position
	#Global.play_scene.add_child(projectile)
