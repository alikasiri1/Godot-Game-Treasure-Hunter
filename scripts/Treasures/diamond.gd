extends Treasure
class_name Diamond

@export var _value : int = 1

func _collect():
	Global.play_scene.collect_diamond(_value)
	call_deferred("set_freeze_enabled" , true)
	call_deferred("set_freeze_mode" , RigidBody2D.FREEZE_MODE_STATIC)
