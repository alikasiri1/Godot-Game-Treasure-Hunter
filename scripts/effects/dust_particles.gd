extends AnimatedSprite2D

var anim : String = ""
 
func _ready() -> void:
	if anim != "":
		play(anim)

func _on_animation_finished() -> void:
	queue_free()
