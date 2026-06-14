class_name AnimationComponent extends Node


@export_subgroup("Nodes")
@export var sprite: Sprite2D
@export var animation_player: AnimationPlayer

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

func play_animation(animation_name: String) -> void:
	if animation_player.current_animation == animation_name:
		return
	
	animation_player.play(animation_name)
	

func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return
	sprite.flip_h = false if move_direction > 0 else true
