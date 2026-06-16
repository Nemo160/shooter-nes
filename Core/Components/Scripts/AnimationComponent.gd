class_name AnimationComponent extends Node

@export_subgroup("Nodes")
@export var sprite: Sprite2D
@export var animation_player: AnimationPlayer


func play_animation(animation_name: StringName) -> void:
	if animation_player == null:
		return
	
	if animation_player.current_animation == animation_name:
		return
	
	animation_player.play(animation_name)


func handle_horizontal_flip(move_direction: float) -> void:
	if sprite == null:
		return
	
	if move_direction == 0:
		return
	
	sprite.flip_h = move_direction < 0


func flip_towards_position(owner: Node2D, target: Node2D) -> void:
	if sprite == null:
		return
	
	sprite.flip_h = target.global_position.x < owner.global_position.x
