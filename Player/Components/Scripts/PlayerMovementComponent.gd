class_name PlayerMovementComponent extends MovementComponent

@export_subgroup("Settings")
@export var move_speed: float = 115
@export_category("Sound")
@export_range(-40.0, 10.0, 0.5) var sound_volume_db: float = 0.0
@export var walk_sound: AudioStream
@onready var audio_component: AudioComponent = $AudioComponent

func _ready() -> void:
	audio_component.set_volume_db(sound_volume_db)

func handle_horizontal_movement(body: CharacterBody2D, direction: float) -> void:
	body.velocity.x = direction * move_speed

	if direction != 0:
		if not audio_component.is_playing():
			audio_component.play_sound(walk_sound)
	else:
		audio_component.stop()
