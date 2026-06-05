extends Node2D

@export var _music : AudioStream
@onready var _fade : LoadingPage = $CanvasLayer/Fade
@onready var _continue : Button = $CanvasLayer/Buttons/Continue

func _ready() -> void:
	_fade.visible = true
	if File.save_file_exists():
		_continue.disabled = false
	Music.start_track(_music)
	_fade.fade_to_clear(1)


func _change_scene(path : String):
	await _fade.fade_to_black(0.4)
	get_tree().change_scene_to_file(path)
	
func _on_new_game_pressed() -> void:
	if not File.save_file_exists():
		_start_new_game()
	else:
		#confirm
		_start_new_game()
		pass
		
func _start_new_game():
	File.new_game()
	File.save_game()
	_change_scene("res://scenes/PlayScene.tscn")

func _on_continue_pressed() -> void:
	File.load_game()
	File.data.level = 0
	_change_scene("res://scenes/PlayScene.tscn")


func _on_exit_pressed() -> void:
	await _fade.fade_to_black()
	get_tree().quit()
