class_name PlayerAnimationComponent extends AnimationComponent


func update_animation(player: CharacterBody2D, move_direction: float) -> void:
	handle_horizontal_flip(move_direction)

	if not player.is_on_floor():
		if player.velocity.y < 0:
			play_animation("jump")
		else:
			play_animation("fall")
		return

	if move_direction != 0:
		play_animation("walk")
	else:
		play_animation("idle")
