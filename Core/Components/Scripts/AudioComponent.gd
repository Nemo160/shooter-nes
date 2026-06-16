class_name AudioComponent extends Node

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D


func set_volume_db(volume: float) -> void:
	audio_player.volume_db = volume

func play_sound(sound: AudioStream, random_pitch: bool = false) -> void:
	if sound == null:
		return

	audio_player.stream = sound

	if random_pitch:
		audio_player.pitch_scale = randf_range(0.9, 1.1)
	else:
		audio_player.pitch_scale = 1.0

	audio_player.play()


func stop() -> void:
	audio_player.stop()


func is_playing() -> bool:
	return audio_player.playing
