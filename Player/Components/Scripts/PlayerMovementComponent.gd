class_name PlayerMovementComponent extends MovementComponent

#@export_subgroup("Settings")
#@export var speed: float = 115

func handle_horizontal_movement(body: CharacterBody2D, direction: float) -> void:
	body.velocity.x = direction * speed
