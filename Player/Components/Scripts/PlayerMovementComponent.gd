class_name PlayerMovementComponent extends MovementComponent

func handle_horizontal_movement(body: CharacterBody2D, direction: float) -> void:
	body.velocity.x = direction * body.move_speed
