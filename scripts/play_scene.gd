extends Node2D
class_name PlayScene

@onready var _camera : Camera = $Camera
@onready var _player : Character = $Roger

@onready var _coin_counter : DataCounter = $"UserInterFace/Coin Counter"
@onready var _lives_counter : DataCounter = $"UserInterFace/Lives Counter"
@onready var _fade : LoadingPage = $UserInterFace/Fade
@onready var _game_over_menu : Control = $UserInterFace/GameOverMenu
@onready var _pause_menu : Control = $UserInterFace/PauseMenu

var _level : GameLevel 
func _ready() -> void:
	_fade.visible = true
	#await _fade.fade_to_clear(0.1)
	_load_level()
	Global.player = _player
	Global.play_scene = $"."
	
	_spawn_player()
	
	_player.is_enable = true
	await get_tree().create_timer(1).timeout
	await _fade.fade_to_clear(0.7)
func _load_level():
	_level = load("res://scenes/Levels/level_" + str(File.data.level) + ".tscn").instantiate()
	
	add_child(_level)
	_init_boundaries()
	_init_ui()
	
func _pause(should_be_paused : bool):
	get_tree().paused = should_be_paused
	_pause_menu.visible = should_be_paused
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_pause(!get_tree().paused)

	
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
	_game_over_menu.visible = false
	
func _spawn_player():
	_player.global_position = _level.get_checkpoint_position(File.data.checkpoint)
	_player.velocity = Vector2.ZERO

	#_camera.global_position = _player.global_position# + following_offset.y 
	#_camera.global_position.x = _player.position.x #+ following_offset.x * (-1 if _subject._is_facing_left else 1)

func collect_coin(value : int):
	File.data.coins += value
	if File.data.coins >= 100:
		File.data.coins = 0
		collect_skull()
		
	_coin_counter.set_value(File.data.coins)


func collect_skull():
	File.data.lives += 1
	_lives_counter.set_value(File.data.lives)
	
func collect_map():
	_player.is_enable = false
	# game_finished.play() # Audio streamplayer2D
	#await game_finished.finished
	await _fade.fade_to_black()
	# load level selection scene
	
func _on_player_died() -> void:
	if File.data.lives == 0 :
		#_game_over()
		print('_game_over')
		await get_tree().create_timer(1, true).timeout
		_return_to_last_checkpoint()
	else:
		File.data.lives -=1 
		_lives_counter.set_value(File.data.lives)
		await get_tree().create_timer(1, true).timeout
		_return_to_last_checkpoint()

func _return_to_last_checkpoint():
	#_camera.position_smoothing_enabled = true
	_fade.visible = true
	await _fade.fade_to_black()
	_level.queue_free()
	
	_load_level()
	
	_spawn_player()
	_player.revive()
	await _fade.fade_to_clear()
	#_camera.position_smoothing_enabled = true
	
func _game_over():
	print("GAME OVER!")
	_game_over_menu.visible = true

func _on_retry_pressed() -> void:
	_game_over_menu.visible = false
	await _fade.fade_to_black()
	File.data.retry()
	_level.queue_free()
	# raload same level
	_load_level()
	
	_spawn_player()
	_player.is_enable = false
	_player.revive()
	await _fade.fade_to_clear()
	_player.is_enable = true
	
func _on_level_select_pressed() -> void:
	_game_over_menu.visible = false
	await _fade.fade_to_black()
	File.data.retry()
	print('Return to level selection')

func _on_exit_pressed() -> void:
	_game_over_menu.visible = false
	await _fade.fade_to_black()
	get_tree().quit()
