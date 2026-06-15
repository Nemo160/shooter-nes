class_name HealthBar extends ProgressBar

@export_category("Components")

@export_subgroup("Settings")
@export var timer: Timer
@export var damage_bar: ProgressBar

var health_bar = 0 : set = _set_health

func _set_health(new_health) -> void:
	var prev_health = health_bar
	health_bar = min(max_value, new_health)
	value = health_bar
	
	if health_bar <= 0:
		queue_free()
	if health_bar < prev_health:
		timer.start()
	else:
		damage_bar.value = health_bar
	

func init_health(_health: float) -> void:
	health_bar = _health
	max_value = health_bar
	value = health_bar
	damage_bar.max_value = health_bar
	damage_bar.value = health_bar
	


func _on_timer_timeout() -> void:
	damage_bar.value = health_bar
