class_name PlayerJumpComponent extends JumpComponent

@export_subgroup("Settings")
@export var jump_velocity: float = -350.0
@export var air_jump_multiplier: float = 0.95
@export var jump_sound: AudioStream

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var is_jumping: bool = false
var has_air_jumped: bool = false

func _ready() -> void:
	audio_player.stream =jump_sound
	
func handle_jump(body: CharacterBody2D, want_to_jump: bool) -> void:
	if body.is_on_floor():
		has_air_jumped = false
	
	if want_to_jump:
		if body.is_on_floor():
			body.velocity.y = jump_velocity
			audio_player.play()

		elif not has_air_jumped:
			var air_jump: float = jump_velocity * air_jump_multiplier
			body.velocity.y = air_jump
			has_air_jumped = true
	#true when body is moving upward and not on floor
	is_jumping = body.velocity.y < 0 and not body.is_on_floor()
