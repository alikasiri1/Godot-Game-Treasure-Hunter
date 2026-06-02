extends Character
class_name Hero

@export var _has_sword : bool  
@onready var _attack_input_buffer : Timer = $InputBuffer
var _sword : RigidBody2D 

func attack():
	_want_to_attack = true
	#print('attakc ' , _want_to_attack , is_one_floor())
	_attack_input_buffer.start()
	await _attack_input_buffer.timeout
	_want_to_attack = false
	
	
func has_sword():
	return _has_sword
	
func _equip_sword(sword : RigidBody2D):
	_sword = sword
	_has_sword = true

	
func _drop_sword():
	if not _has_sword : 
		return
		
	_has_sword = false
	_sword.be_dropped(global_position)
	_sword = null

func _die():
	if _has_sword:
		_drop_sword()
	super._die()
