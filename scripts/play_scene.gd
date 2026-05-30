extends Node2D
class_name PlayScene

@onready var _camera : Camera = $Camera
@onready var _player : Character = $Roger
@onready var _level : GameLevel = $Level
@onready var _coin_counter : CoinCounter = $"UserInterFace/Coin Counter"
@onready var _lives_counter :  = $"UserInterFace/Lives Counter"

func _ready() -> void:
	Global.player = _player
	Global.play_scene = $"."
	_init_boundaries()
	_init_ui()
	
func _init_boundaries():
	var _min_boundary : Vector2 = _level.get_min()
	var _max_boundary : Vector2 = _level.get_max()
	print(_min_boundary)
	print(_max_boundary)
	
	_camera.set_bounds(_min_boundary , _max_boundary)
	_player.set_bounds(_min_boundary , _max_boundary)
	

func _init_ui() -> void:
	_coin_counter.set_value(File.data.coins)
	_lives_counter.set_value(File.data.lives)
	
func collect_coin(value : int):
	File.data.coins += value
	if File.data.coins >= 100:
		File.data.coins = 0
		collect_skull()
		
	_coin_counter.set_value(File.data.coins)


func collect_skull():
	File.data.lives += 1
	_lives_counter.set_value(File.data.lives)
	
