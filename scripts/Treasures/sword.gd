extends RigidBody2D

@onready var _sfx : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var _rng : RandomNumberGenerator = RandomNumberGenerator.new()
@onready var _collition : CollisionShape2D = $CollisionShape2D

var _collision_mask

func _ready() -> void:
	_collision_mask = collision_mask
	print(_collision_mask)
	
func be_dropped(position_dropped_from : Vector2):
	collision_mask = _collision_mask
	global_position = position_dropped_from #+ Vector2.UP * Global.ppt / 2
	#apply_impulse(Vector2.UP * Global.ppt * 8 + Vector2.RIGHT * Global.ppt * _rng.randf_range(-1 , 1))
	visible = true
	
func _on_body_entered(body: Node) -> void:
	#print(body)
	if body is Hero and body.has_sword():
		return
		
	if body is Hero :
		_sfx.play()
		body._equip_sword(self)
		collision_mask = 1
		visible = false
		#set_deferred('freeze', false)
