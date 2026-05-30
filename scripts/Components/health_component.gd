extends Area2D
class_name HealthComponent


@onready var _current_health : int 

signal on_damaged
signal on_defeated

func _ready() -> void:
	_current_health = get_parent().max_health
	print(_current_health)
	
func apply_damage(damage : float):
	if _current_health <= 0 : 
		return
		
	_current_health -= damage
	_current_health = max(0 , _current_health)
	on_damaged.emit()
	
	if _current_health == 0:
		on_defeated.emit()
