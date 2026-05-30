class_name Character
extends CharacterBody2D

@export_range(1 , 100) var max_health : int = 1

@export_category("sprite")
@export var effect_sprite : PackedScene
@export var _sprite_face_left : bool = false
@export var _is_facing_left : bool

@export_category("Locomotion")
@export var _speed = 8
@export var _acceleration : float = 16
@export var _deceleration : float = 32

@export_category("Jump")
@export var _jump_height : float = 2.5
@export var _air_controtl : float = 0.5

@export_category("Swim")
@export var _density : float = -0.1
@export var _drag : float = 0.3


@onready var _sprite : Sprite2D = $Sprite2D
@onready var health_component : HealthComponent = $HealthComponent


var _water_surface_height : float
var _is_in_water : bool
var _is_below_surface: bool

var _jump_velocity : float
var _direction : float 
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _min_boundary : Vector2
var _max_boundary : Vector2
var _is_bound : bool

func _ready() -> void:
	_speed *= Global.ppt
	_acceleration *= Global.ppt
	_deceleration *= Global.ppt
	_jump_height *= Global.ppt
	
	_jump_velocity = sqrt(_jump_height * gravity * 2 ) * -1
	
	_is_facing_left = _sprite_face_left
	
#region Public Methods

func set_bounds(min_boundary: Vector2, max_boundary : Vector2):
	_min_boundary = min_boundary
	_max_boundary = max_boundary
	_is_bound = true
	
func face_right():
	_sprite.flip_h =  _sprite_face_left
	_is_facing_left = false
	
func face_left():
	_sprite.flip_h = not _sprite_face_left
	_is_facing_left = true
	
func run(direction : float ):
	_direction = direction


func jump():
	if _is_in_water:
		if _is_below_surface:
			velocity.y = _jump_velocity * _drag
		else:
			velocity.y = _jump_velocity
			
	if is_on_floor():
		velocity.y = _jump_velocity
		_spawn_effect(effect_sprite , "jump")
	
func stop_jump():
	if velocity.y < 0 and not _is_in_water:
		velocity.y = 0
		
func enter_water(water_surface_height):
	if velocity.y > 0 :
		velocity.y *= _drag
		
	_water_surface_height = water_surface_height
	_is_in_water = true
	_is_below_surface = false
	
func exit_water():
	_is_in_water = false
	
func dive():
	_is_below_surface = true
	
#endregion

func _physics_process(delta: float) -> void:
	if not _is_facing_left and sign(_direction) == -1:
		face_left()
	if _is_facing_left and sign(_direction) == 1:
		face_right()
		
	if _is_in_water:
		_water_physics(delta)
	elif is_on_floor():
		_ground_physics(delta)
	else:
		_air_physics(delta)
	move_and_slide()
	
	if _is_bound:
		position.x = clamp(position.x , _min_boundary.x , _max_boundary.x)
		position.y = clamp(position.y , _min_boundary.y , _max_boundary.y)


func _ground_physics(delta : float):
	if _direction == 0:
		velocity.x = move_toward(velocity.x, 0, _deceleration * delta )
	# accelerate not moving, or trying to move in same direction
	elif velocity.x == 0 || sign(_direction) == sign(velocity.x):
		velocity.x = move_toward(velocity.x, _direction * _speed , _acceleration * delta)
	# decelerate if tryign to move in opposite direction
	else:
		velocity.x = move_toward(velocity.x, _direction * _speed , _deceleration * delta)

func _water_physics(delta: float):

	if _direction == 0:
		velocity.x = move_toward(velocity.x, 0, _deceleration * _drag * delta )
	else:
		velocity.x = move_toward(velocity.x, _direction * _drag * _speed , _acceleration * delta)
	
	if _is_below_surface or _density > 0:
		velocity.y = move_toward(velocity.y , gravity*2 * _density * _drag , gravity*2 * _drag * delta)
	elif position.y - float(Global.ppt) / 4 < _water_surface_height:
		velocity.y = move_toward(velocity.y , gravity*2 * _density * _drag , gravity*2 * _drag * delta)

	else:
		velocity.y = move_toward(velocity.y , gravity*2 * _density * _drag * -1 , gravity*2 * _drag * delta)

func _air_physics(delta : float):
	velocity += get_gravity() * delta
	if _direction :
		velocity.x = move_toward(velocity.x, _direction * _speed , _acceleration * _air_controtl * delta)

func _spawn_effect(effect : PackedScene , animation: String):
	var _effect = effect.instantiate()
	_effect.anim = animation
	_effect.position = self.position
	_effect.flip_h = _sprite.flip_h
	get_parent().add_child(_effect)
	


func _on_health_component_on_damaged() -> void:
	print(health_component._current_health)


func _on_health_component_on_defeated() -> void:
	print('you died')
