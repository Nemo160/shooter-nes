extends Node

func play(sound_name: String) -> void:
	var player := get_node_or_null(sound_name) as AudioStreamPlayer
	if player == null:
		printerr("NO player found")
		return
	if player.playing:
		player.stop()
	player.play()
