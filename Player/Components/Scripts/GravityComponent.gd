class_name GravityComponent extends Node

@export_subgroup("Settings")
@export var gravity: float = GameConstant.GRAVITY
@export var descend_multiplier: float = 1.5

var is_falling: bool = false
func handle_gravity(body: CharacterBody2D, delta: float, _is_descending: bool) -> void:
	if not body.is_on_floor():
		if _is_descending:
			body.velocity.y += gravity * descend_multiplier * delta
		else:
			body.velocity.y += gravity * delta
		
	is_falling = body.velocity.y > 0 and not body.is_on_floor()
	pass
