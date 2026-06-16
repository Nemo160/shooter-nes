class_name Enemy extends CharacterBody2D

@export_subgroup("Components")
@export var health_component: HealthComponent
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var audio_component: AudioComponent



@export_category("Settings")
@export var move_speed: float = 80.0
@export var damage: float = 5
@export var hitbox: Area2D
@export_subgroup("Sound")
@export_range(-40.0, 10.0, 0.5) var sound_volume_db: float = 0.0
@export var hurt_sound: AudioStream

var player: Node2D
var bodies_in_hitbox: Array[Node2D] = []

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	health_component.died.connect(_on_died)
	hitbox.body_entered.connect(_on_hitbox_body_entered)
	hitbox.body_exited.connect(_on_hitbox_body_exited)

func _physics_process(delta: float) -> void:
	#every frame check if the instance body is still valid and a damageable entity
	for body in bodies_in_hitbox:
		if is_instance_valid(body) and body.has_method("take_damage"):
			body.take_damage(damage)

func take_damage(amount: float) -> void:
	health_component.take_damage(amount)
	

func _on_died() -> void:
	queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	bodies_in_hitbox.append(body)

func _on_hitbox_body_exited(body: Node2D) -> void:
	bodies_in_hitbox.erase(body)

func can_see_player() -> bool:
	return player != null

func is_in_attack_range() -> bool:
	if player == null:
		return false
	return global_position.distance_to(player.global_position) < 35.0
