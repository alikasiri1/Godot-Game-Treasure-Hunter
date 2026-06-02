class_name Character
extends CharacterBody2D

@export_category("Combat")
@export_range(1 , 100) var max_health : int = 1
@export_range(0 , 5) var _invincible_duration = 0
@export_range(0 , 5) var _attack_damage : int = 1

@export_category("Sprite")
@export var effect_sprite : PackedScene
@export var _sprite_face_left : bool = false
var _is_facing_left : bool

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
@onready var animation : AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var _hurt_box_area : Area2D = $HurtBox
@onready var _hit_box_area : Area2D = $HitBox

var _invincible_timer : Timer 
var _water_surface_height : float
var _is_in_water : bool
var _is_below_surface: bool

var _jump_velocity : float
var _direction : float 
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _min_boundary : Vector2
var _max_boundary : Vector2
var _is_bound : bool

var _is_hit : bool = false
var is_dead : bool = false
var is_enable : bool = false
signal died()

var _collision_layer : int = collision_layer
var _collition_mask  : int = collision_mask

#combat
var _want_to_attack : bool = false
var _is_attacking : bool = false

func _ready() -> void:
	_speed *= Global.ppt
	_acceleration *= Global.ppt
	_deceleration *= Global.ppt
	_jump_height *= Global.ppt
	
	_jump_velocity = sqrt(_jump_height * gravity * 2 ) * -1
	
	#_is_facing_left = _sprite_face_left

	face_left() if _sprite_face_left else face_right()
	if _invincible_duration != 0 :
		_invincible_timer = $Invincible

	_hit_box_area.monitoring = false
	_is_attacking = false
	
#region Public Methods

func attack():
	_want_to_attack = true
	
func revive():
	is_dead = false
	health_component._current_health = max_health
	_hurt_box_area.monitorable = true
	collision_layer =  _collision_layer 
	collision_mask = _collition_mask
	is_enable = true
	
func set_bounds(min_boundary: Vector2, max_boundary : Vector2):
	_min_boundary = min_boundary
	_max_boundary = max_boundary
	_is_bound = true
	
func face_right():
	#print(name , 'face right' , _sprite_face_left)
	if is_dead or _is_attacking:
		return
	_is_facing_left = false
	_sprite.flip_h = _sprite_face_left 
	
	_hit_box_area.scale.x = -1 if _sprite_face_left else 1
	
func face_left():
	#print(name , 'face left' , _sprite_face_left)
	if is_dead or _is_attacking:
		return
	_is_facing_left = true
	_sprite.flip_h = not _sprite_face_left 
	_hit_box_area.scale.x = 1 if _sprite_face_left else -1
	
	
func run(direction : float ):
	if is_dead or _is_attacking:
		direction = 0
	else:
		_direction = direction


func jump():
	if is_dead or _is_attacking:
		return
	if _is_in_water:
		if _is_below_surface:
			velocity.y = _jump_velocity * _drag
		else:
			velocity.y = _jump_velocity
			
	if is_on_floor():
		velocity.y = _jump_velocity
		_spawn_effect(effect_sprite , "jump")
	
func stop_jump():
	if is_dead or _is_attacking:
		return
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
	
func is_facing_left():
	return _is_facing_left
	
#endregion

func _physics_process(delta: float) -> void:
	#if not is_enable:
		#velocity = Vector2.ZERO
		#return

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
	

func _change_hit(value : bool):
	_is_hit = value

func _change_want_attack(value : bool):
	_want_to_attack = value
	
func _change_is_attacking(value: bool):
	#print(name, 'is attacking')
	_is_attacking = value
	
func _becom_invincible(duration : float):
	_hurt_box_area.set_deferred("monitorable" , false)
	_invincible_timer.start(duration)
	await _invincible_timer.timeout
	_hurt_box_area.monitorable = true
	
func _on_health_component_on_damaged() -> void:
	print(health_component._current_health)
	_is_hit = true
	
	if _invincible_duration != 0:
		_becom_invincible(_invincible_duration)
	
func _die():
	is_dead = true
	_hurt_box_area.set_deferred("monitorable" , false)
	collision_layer = 0
	collision_mask = 1
	_direction = 0
	died.emit()
	
func _on_health_component_on_defeated() -> void:
	print(name,' died')
	_die()

func _on_hit_box_area_entered(area: Area2D) -> void:
	print(area.get_parent().name)
	if not is_dead and _is_attacking:
		#print((area.global_position - global_position).normalized())
		area.get_parent().health_component.apply_damage(_attack_damage,(area.global_position - global_position).normalized())
