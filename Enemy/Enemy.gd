class_name Enemy extends CharacterBody2D

signal died

@export_subgroup("Components")
@export var health_component: HealthComponent
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var animation_component: EnemyAnimationComponent
@export var audio_component: AudioComponent

@export_category("Settings")
@export var damage: float = 5.0

@export var detection_range: float = 120.0
@export var attack_range: float = 35.0

@export var hitbox: Area2D

var player: Node2D
var bodies_in_hitbox: Array[Node2D] = []


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

	if health_component != null:
		health_component.died.connect(_on_died)

	if hitbox != null:
		hitbox.body_entered.connect(_on_hitbox_body_entered)
		hitbox.body_exited.connect(_on_hitbox_body_exited)


func _physics_process(_delta: float) -> void:
	for body in bodies_in_hitbox:
		if is_instance_valid(body) and body.has_method("take_damage"):
			body.take_damage(damage)


func take_damage(amount: float) -> void:
	if health_component != null:
		health_component.take_damage(amount)


func can_see_player() -> bool:
	if player == null or not is_instance_valid(player):
		return false
	return global_position.distance_to(player.global_position) <= detection_range


func is_in_attack_range() -> bool:
	if player == null or not is_instance_valid(player):
		return false
	return global_position.distance_to(player.global_position) <= attack_range


func _on_died() -> void:
	died.emit()
	queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	bodies_in_hitbox.append(body)


func _on_hitbox_body_exited(body: Node2D) -> void:
	bodies_in_hitbox.erase(body)
