class_name EnemyMovementComponent extends MovementComponent

@export var move_speed: float = 80
func handle_horizontal_movement(body: CharacterBody2D, direction: float) -> void:
	if not body.is_on_wall():
		body.velocity.x = move_speed * direction
	pass
