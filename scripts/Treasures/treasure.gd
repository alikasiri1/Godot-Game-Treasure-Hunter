extends CollisionObject2D
class_name Treasure

@onready var _sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var _sfx : AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	pass

func _collect():
	pass

func _on_body_entered(body: Node) -> void:
	if body is Character:
		_collect()
		_sfx.play()
		collision_mask = 0
		_sprite.play("effect")
		await _sprite.animation_finished
		queue_free()
