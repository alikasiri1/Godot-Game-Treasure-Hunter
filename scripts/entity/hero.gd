extends Character
class_name Hero

@export var _has_sword : bool  
var _sword : RigidBody2D 

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
