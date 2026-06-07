extends GameLevel
class_name SelectLevel


@export var world_id : int = 1
@onready var _fade : LoadingPage = $CanvasLayer/Fade
@onready var _level_buttons :Array[Node] = $CanvasLayer/PanelContainer/VBoxContainer/GridContainer.get_children()
@onready var _coin_counter : DataCounter = $"CanvasLayer/Coin Counter"
@onready var _diamond_counter : DataCounter = $"CanvasLayer/Blue Diamond"
@onready var _next_button : Button = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer3/NextButton
@onready var _back_button : Button = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer3/BackButton

func _ready() -> void:
	super._ready()
	print("world : " , File.data.world)
	_fade.visible = true
	var button = 0
	print(_level_buttons)
	
	if File.data.world == 1:
		_back_button.disabled = true
		_back_button.flat = true
		_back_button.mouse_default_cursor_shape = Control.CURSOR_ARROW
		
	for level in File.data.progress[world_id-1].size():
		var level_status = File.data.check_progress_marker(Data.Progress.UNLOCKED, world_id  , level + 1)
		#_level_buttons[button].get_child(1).visible = level_status
		#_level_buttons[button].get_child(2).visible = !level_status
		_level_buttons[button].get_child(0).disabled = !level_status
		
		if !level_status:
			_level_buttons[button].get_child(0).mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN

		button += 1

	_coin_counter.set_value(File.data.coins)
	_diamond_counter.set_value(File.data.diamonds)
	_fade.fade_to_clear()

func _change_world(world : int):
	if File.data.world + world > File.data.progress.size():
		return
		
	_back_button.disabled = true
	_next_button.disabled = true
	File.data.world += world
	File.data.level = 0
	await _fade.fade_to_black()
	get_tree().change_scene_to_file("res://scenes/PlayScene.tscn")
	
func _on_level_selected(world: int, level: int) -> void:
	File.data.level = level
	File.data.world = world
	await _fade.fade_to_black()
	get_tree().change_scene_to_file("res://scenes/PlayScene.tscn")
