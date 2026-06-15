class_name HealthBar extends ProgressBar

@export_category("Components")
@export_subgroup("Settings")
@export var timer: Timer
@export var damage_bar: ProgressBar
@export var health_component: HealthComponent

var current_health: float = 0.0

func _ready() -> void:
	health_component.health_changed.connect(_on_health_changed)
	health_component.died.connect(_on_died)
	init_health(health_component.health, health_component.max_health)

func init_health(health: float, max_health: float) -> void:
	current_health = health
	max_value = max_health
	value = current_health
	damage_bar.max_value = max_health
	damage_bar.value = current_health

func _on_health_changed(new_health: float, max_health: float) -> void:
	var prev_health := current_health
	current_health = min(max_value, new_health)
	value = current_health

	if current_health < prev_health:
		timer.start()
	else:
		damage_bar.value = current_health

func _on_died() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	damage_bar.value = current_health
