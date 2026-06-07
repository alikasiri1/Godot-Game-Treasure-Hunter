extends Node2D
class_name Bullet

@export var speed : float = 1000
@onready var explosion_sound : AudioStreamPlayer = $ExplosionSound 


var move_direction : Vector2 = Vector2(1, 1)
var damage : float = 0.5

var bullets_num : int = 0

func _ready() -> void:
	for child in get_children():
		if child is Area2D:
			bullets_num += 1
			child.body_entered.connect(_on_body_entered.bind(child))

func _process(delta: float) -> void:
	if move_direction != Vector2.ZERO:
		position += move_direction * speed * delta

func _on_body_entered(body: Node2D, source_area: Area2D) -> void:

	bullets_num -= 1 
	if bullets_num <= 0:
		$shadow.hide()
	source_area.queue_free()

	#GameManager.play_explosion_anim(self.global_position - Vector2(0 , 45))
	#explosion_sound.play()
	
	if body is Hero:
		var hero = body as Hero
		hero.health_component.apply_damage(damage)

		
	#elif body is GameObject:
		#var object = body as GameObject
		#object.health_component.apply_damage(damage)
		
	if bullets_num <= 0:
		await get_tree().create_timer(0.2).timeout
		queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
