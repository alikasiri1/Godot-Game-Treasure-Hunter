extends Area2D

@export var _water_particle : PackedScene
@onready var _sfx : AudioStreamPlayer2D = $AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is TileMap : 
		return
		
	if body is Character:
		_spawn_splash(body.position.x)
		body.enter_water(position.y)


func _on_body_exited(body: Node2D) -> void:
	if body is Character:
		if body.position.y - float(Global.ppt) / 2 <= position.y:
			body.exit_water()
			_spawn_splash(body.position.x)
		else:
			body.dive()

func _spawn_splash(x : float):
	var splash : AnimatedSprite2D = _water_particle.instantiate()
	splash.anim = "water_splash"
	add_child(splash)
	splash.global_position.x = x
	#_sfx.play()
