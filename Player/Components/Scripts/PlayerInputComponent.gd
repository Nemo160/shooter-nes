class_name InputComponent extends Node

var input_horizontal: float = 0.0
var jump_pressed: bool = false
var jump_held: bool = false
var dash_pressed: bool = false
var holding_down: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_input() -> void:
	input_horizontal = Input.get_axis("left", "right")
	jump_pressed = Input.is_action_just_pressed("jump")
	jump_held = Input.is_action_pressed("jump")
	dash_pressed = Input.is_action_just_pressed("dash")
	holding_down = Input.is_action_pressed("down")
	
