extends Resource
class_name Data

@export var coins : int 
@export var lives : int
@export var checkpoint : int

func _init() -> void:
	coins = 0
	lives = 3
	checkpoint = 0
