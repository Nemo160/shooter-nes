class_name PlayerGravityComponent extends GravityComponent

@export var descend_multiplier: float = 1.5
func handle_gravity(body: CharacterBody2D, delta: float, _is_descending: bool = false) -> void:
	if not body.is_on_floor():
		if _is_descending:
			body.velocity.y += gravity * descend_multiplier * delta
		else:
			body.velocity.y += gravity * delta
		
	is_falling = body.velocity.y > 0 and not body.is_on_floor()
	pass
