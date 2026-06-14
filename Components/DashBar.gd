class_name DashBar extends ProgressBar

@export_subgroup("Settings")
@export var dash_duration: float
@export var dash_value: float
@export var is_visible: bool


func init_dash_bar(current_dash_duration: float, maximum:float,) -> void:
	max_value = maximum
	value = current_dash_duration
	is_visible = visible
	
	
func animate_value(target, tween_duration) -> void:
	pass
