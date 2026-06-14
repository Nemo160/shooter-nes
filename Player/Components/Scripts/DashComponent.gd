class_name DashComponent extends Node

@export_subgroup("Settings")
@export var dash_duration: float = 0.18
@export var dash_speed: float = 500

@onready var cooldown_timer: Timer = $"../dash_cooldown"


var is_dashing: bool = false
var dash_direction: float = 1.0
var dash_time_left: float = 0.0

func _ready() -> void:
	cooldown_timer.one_shot = true


func handle_dash(body: CharacterBody2D, wants_to_dash: bool, delta: float) -> void:
	if is_dashing:
		dash_time_left -= delta

		body.velocity.x = dash_direction * dash_speed
		body.velocity.y = 0

		if dash_time_left <= 0:
			is_dashing = false
			cooldown_timer.start()
		return

	if wants_to_dash and cooldown_timer.is_stopped():
		start_dash(body)
		
func start_dash(body: CharacterBody2D) -> void:
	is_dashing = true
	dash_time_left = dash_duration
	if body is Player:
		dash_direction = body.facing_direction
	else:
		dash_direction = 1.0
