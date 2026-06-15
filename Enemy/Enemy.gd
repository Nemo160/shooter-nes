class_name Enemy extends CharacterBody2D


@export_subgroup("Components")
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var health_bar: HealthBar

@export_subgroup("Settings")
@export var move_speed: float = 80.0
@export var health: float = 25
@export var damage: float = 5

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	health_bar.init_health(health)

func take_damage(damage_taken:float) ->void:
	health -= damage_taken
	health_bar.health_bar -= damage_taken
	if health <= 0:
		die()
		
func die() -> void:
	queue_free()
	
func can_see_player() -> bool:
	return player != null


func is_in_attack_range() -> bool:
	if player == null:
		return false
	
	return global_position.distance_to(player.global_position) < 35.0
