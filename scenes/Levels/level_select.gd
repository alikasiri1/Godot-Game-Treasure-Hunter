extends GameLevel
class_name SelectLevel


@export var world_id : int = 1
@onready var _fade : LoadingPage = $CanvasLayer/Fade
@onready var _level_buttons :Array[Node] = $CanvasLayer/PanelContainer/VBoxContainer/GridContainer.get_children()
@onready var _coin_counter : DataCounter = $"CanvasLayer/Coin Counter"

func _ready() -> void:
	super._ready()
	
	_fade.visible = true
	var button = 0
	print(_level_buttons)
	for level in File.data.progress[world_id].size():
		var level_status = File.data.check_progress_marker(Data.Progress.UNLOCKED, world_id  , level + 1)
		#_level_buttons[button].get_child(1).visible = level_status
		#_level_buttons[button].get_child(2).visible = !level_status
		_level_buttons[button].get_child(0).disabled = !level_status
		
		if !level_status:
			_level_buttons[button].get_child(0).mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN

		button += 1

	_coin_counter.set_value(File.data.coins)
	_fade.fade_to_clear()


func _on_level_selected(world: int, level: int) -> void:
	File.data.level = level
	File.data.world = world
	await _fade.fade_to_black()
	get_tree().change_scene_to_file("res://scenes/PlayScene.tscn")
