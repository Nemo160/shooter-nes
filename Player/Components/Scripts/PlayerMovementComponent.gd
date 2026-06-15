class_name PlayerMovementComponent extends MovementComponent

@export var move_speed: float = 115
func handle_horizontal_movement(body: CharacterBody2D, direction: float) -> void:
	body.velocity.x = direction * move_speed
