extends Area2D
class_name CheckPoint

@onready var _sfx : AudioStreamPlayer2D = $AudioStreamPlayer2D
var id : int

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print(body)
	_sfx.play()
	collision_mask = 0
	Global.play_scene.checkpoint = id
	#File.data.checkpoint = id
