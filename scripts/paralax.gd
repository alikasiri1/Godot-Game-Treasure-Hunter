extends Node2D

@export var _scroll_speed = -80
@export var _width : float = 928
var clouds : Array[Sprite2D]  = []

func _ready() -> void:
	for child in self.get_children():
		if child is Sprite2D:
			if "Cloud" in child.name:
				clouds.push_back(child)


func _process(delta: float) -> void:
	move_clouds(delta)

func _scroll(cloud : Sprite2D , distance : float):
	if "Larg" in cloud.name :
		distance /= 4
	elif "Medium" in cloud.name:
		distance /= 5
	elif "Small" in cloud.name :
		distance /= 7
	elif "Big" in cloud.name : 
		distance /= 2
		
	cloud.position.x += distance
	if cloud.position.x < _width * -1:
		cloud.position.x += _width * 2

func move_clouds(delta : float):
	for cloud in self.clouds:
		_scroll(cloud , _scroll_speed * delta)
