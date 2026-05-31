extends Resource
class_name Data

@export var level : int
@export var coins : int 
@export var lives : int
@export var checkpoint : int

func _init() -> void:
	coins = 0
	lives = 3
	checkpoint = 0
	level = 1
	
func retry():
	coins = 0 
	lives = 3
	checkpoint = 0
