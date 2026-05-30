extends Node2D

@export_range(1 , 100) var damage : int = 1
func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_hit_box_area_entered(area: Area2D) -> void:
	area.get_parent().health_component.apply_damage(damage,(area.global_position - global_position).normalized())
