class_name Enemy extends CharacterBody2D


@export_subgroup("Components")
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent

@export_subgroup("Settings")
@export var move_speed: float = 80.0
@export var health: float = 100

var player: Node2D


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func can_see_player() -> bool:
	return player != null


func is_in_attack_range() -> bool:
	if player == null:
		return false
	
	return global_position.distance_to(player.global_position) < 35.0
