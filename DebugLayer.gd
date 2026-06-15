extends CanvasLayer

var label: Label

func _ready() -> void:
	layer = 10
	label = Label.new()
	label.position = Vector2(5,5)
	label.add_theme_color_override("font_color", Color.GREEN)
	add_child(label)
	

# In DebugOverlay.gd
func update_player(body: CharacterBody2D,  air_jumped: bool, dash_time_stopped: bool = false) -> void:
	label.text = "FPS: %d\nVelocity X: %.1f\nVelocity Y: %.1f\nDash ready: %s\nAir jumped: %s" % [
		Engine.get_frames_per_second(),
		body.velocity.x,
		body.velocity.y,
		"YES" if dash_time_stopped else "NO",
		str(air_jumped)
	]
