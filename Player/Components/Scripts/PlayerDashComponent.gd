class_name PlayerDashComponent extends Node

@export_subgroup("Settings")
@export var dash_duration: float = 0.18
@export var dash_speed: float = 500
@export var dash_cooldown: float = 5.0
@export var dash_bar: ProgressBar

@onready var cooldown_timer: Timer = $"../cooldown_timer"

var is_dashing: bool = false
var dash_direction: float = 1.0
var dash_time_left: float = 0.0

const PLAYER_LAYER: int = 1
const INVINCIBLE_LAYER: int = 2
const ENEMY_LAYER: int = 10

func _ready() -> void:
	cooldown_timer.wait_time = dash_cooldown
	cooldown_timer.one_shot = true
	dash_bar.min_value = 0.0
	dash_bar.max_value = 1.0
	dash_bar.step = 0.0
	dash_bar.visible = false

##DASH HANDLER
func handle_dash(body: CharacterBody2D, wants_to_dash: bool, delta: float) -> void:
	update_dash_cooldown_bar()
	if is_dashing:
		dash_time_left -= delta
		
		body.velocity.x = dash_direction * dash_speed
		body.velocity.y = 0

		if dash_time_left <= 0:
			is_dashing = false
			end_invincibility(body)
			cooldown_timer.start()
		return

	if wants_to_dash and cooldown_timer.is_stopped():
		start_dash(body)
		
func start_dash(body: CharacterBody2D) -> void:
	is_dashing = true
	start_invincibility(body)
	dash_time_left = dash_duration

	if body is Player:
		dash_direction = body.facing_direction
	else:
		dash_direction = 1.0

##DASH BAR
func update_dash_cooldown_bar() -> void:
	var progress := get_cooldown_progress()
	dash_bar.value = progress
	dash_bar.visible = progress < 1.0

func get_cooldown_progress() -> float:
	if cooldown_timer.is_stopped():
		return 1.0
	return 1.0 - (cooldown_timer.time_left / cooldown_timer.wait_time)
	
##INVINCIBILITY
func start_invincibility(body: CharacterBody2D) -> void:
	body.set_collision_layer_value(PLAYER_LAYER, false)
	body.set_collision_layer_value(INVINCIBLE_LAYER, true)
	body.set_collision_mask_value(ENEMY_LAYER, false)

func end_invincibility(body: CharacterBody2D) -> void:
	body.set_collision_layer_value(PLAYER_LAYER, true)
	body.set_collision_layer_value(INVINCIBLE_LAYER, false)
	body.set_collision_mask_value(ENEMY_LAYER, true)
