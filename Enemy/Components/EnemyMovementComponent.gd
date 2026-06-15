class_name EnemyMovementComponent extends MovementComponent

@export var testMov: float = 0.9


func handle_horizontal_movement(body: CharacterBody2D, direction: float) -> void:
	if not body.is_on_wall():
		body.velocity.x += 1 * direction
	pass
