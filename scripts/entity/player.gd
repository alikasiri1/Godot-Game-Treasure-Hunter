extends Node

@onready var _character : Character = get_parent() 


func _input(event: InputEvent) -> void:
	if not _character.is_enable:
		return
	if event.is_action_pressed("jump"):
		_character.jump()

	if event.is_action_released("jump"):
		_character.stop_jump()
		
	if event.is_action_pressed("attack"):
		_character.attack()
		
func _process(_delta: float) -> void:
	if not _character.is_enable:
		return
	_character.run(Input.get_axis("run_left" , "run_right"))
