class_name Projectile extends CharacterBody2D
@export var SPEED = 300.0
func _physics_process(delta: float) -> void:
	position += transform.x * SPEED *delta
	move_and_slide()
	##check for bullet collisions
	for i  in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		queue_free()
		break
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
