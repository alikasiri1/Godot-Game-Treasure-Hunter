extends Node
class_name HealthComponent

var _current_health : int 
var character : Character
signal on_damaged
signal on_defeated

func _ready() -> void:
	character = get_parent()
	_current_health = character.max_health
	print(_current_health)
	
func apply_damage(damage : float , direction : Vector2):
	if _current_health <= 0 : 
		return
		
	_current_health -= damage
	_current_health = max(0 , _current_health)
	on_damaged.emit()
	
	character.velocity = direction * Global.ppt * 5
	if _current_health == 0:
		on_defeated.emit()
