class_name PlayerMovementComponent extends MovementComponent
@export_category("Settings")
@export var move_speed: float = 115
@export var walk_sound: AudioStream

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	audio_player.stream = walk_sound
	

func handle_horizontal_movement(body: CharacterBody2D, direction: float) -> void:
	body.velocity.x = direction * move_speed
	audio_player.play()
