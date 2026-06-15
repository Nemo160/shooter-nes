class_name HealthComponent extends Node

signal health_changed(current_health: float, max_health: float)
signal died

@export var max_health: float = 25.0

var health: float
var is_dead: bool = false

func _enter_tree() -> void:
	health = max_health

func take_damage(amount: float) -> void:
	if is_dead:
		return

	health = max(health - amount, 0.0)
	health_changed.emit(health, max_health)

	if health <= 0:
		is_dead = true
		died.emit()

func heal(amount: float) -> void:
	if is_dead:
		return
	health = min(health + amount, max_health)
	health_changed.emit(health, max_health)
