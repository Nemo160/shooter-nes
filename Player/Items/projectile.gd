class_name Projectile extends CharacterBody2D
@export var SPEED = 300.0
@export var damage_amount: float = 5.0
func _physics_process(delta: float) -> void:
	position += transform.x * SPEED *delta
	move_and_slide()
	##check for bullet collisions
	for i  in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(damage_amount)

		queue_free()
		
		break
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
