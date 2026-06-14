class_name InputComponent extends Node

var input_horizontal: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	input_horizontal = Input.get_axis("left","right")
	pass

func get_jump_input() -> bool:
	return Input.is_action_just_pressed("jump")
	
func get_dash_input() -> bool:
	return Input.is_action_just_pressed("dash")
