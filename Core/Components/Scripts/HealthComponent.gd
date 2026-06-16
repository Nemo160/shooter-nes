class_name HealthComponent extends Node

@export var max_health: float = 25.0
@export_category("Sound")
@export_range(-40.0, 10.0, 0.5) var sound_volume_db: float = 0.0
@export var hurt_sound: AudioStream
@onready var audio_component: AudioComponent = $AudioComponent

signal health_changed(current_health: float, max_health: float)
signal died

var health: float
var is_dead: bool = false

func _enter_tree() -> void:
	health = max_health
	
func _ready() -> void:
	audio_component.set_volume_db(sound_volume_db)

func take_damage(amount: float) -> void:
	if is_dead:
		return

	health = max(health - amount, 0.0)
	audio_component.play_sound(hurt_sound, true)
	health_changed.emit(health, max_health)

	if health <= 0:
		is_dead = true
		died.emit()

func heal(amount: float) -> void:
	if is_dead:
		return
	health = min(health + amount, max_health)
	health_changed.emit(health, max_health)
