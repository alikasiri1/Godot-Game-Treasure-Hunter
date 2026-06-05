extends Node

var data : Data
const _path : String = "user://autosave.tres"
func _ready() -> void:
	new_game()
	
func save_file_exists() -> bool:
	return ResourceLoader.exists(_path)
	
func new_game():
	data = Data.new()

func save_game():
	ResourceSaver.save(data, _path)
	
func load_game():
	data = ResourceLoader.load(_path)
