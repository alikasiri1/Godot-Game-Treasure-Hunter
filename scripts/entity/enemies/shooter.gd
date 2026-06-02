extends Enemy
class_name Shooter

@export var _projectile : PackedScene 
@export_range(0 , 100) var _p_speed : float = 10
@export_range(0 , 100) var _p_damage : int = 1
@export var _p_duration : float = 10
@onready var _p_origin : Node2D = $ProjectileOrigin

func _ready() -> void:
	super._ready()
	_p_speed = Global.ppt * _p_speed
	
func _spawn_projectile():
	var projectile : Node2D = _projectile.instantiate()
	projectile.global_position = _p_origin.global_position
	get_parent().add_child(projectile)
	projectile.fire(Vector2.LEFT if is_facing_left else Vector2.RIGHT ,_p_speed , _p_damage , _p_duration )
	
