extends StaticBody2D

@export_range(1 , 100) var damage : int = 1
func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_hit_box_area_entered(area: HealthComponent) -> void:
	area.apply_damage(damage)
