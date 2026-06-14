class_name Enemy extends CharacterBody2D


var health:float
var move_speed: float = 200
var direction: Vector2 = Vector2.ZERO
var gravity: float = GameConstant.GRAVITY
var damage: float = 25

var is_alive: bool = true


func _ready() -> void:
	direction.y = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func take_damage(damage: float) -> void:
	health -= damage
	_set_health(health)
	
func die() -> void:
	queue_free()
	
func _set_health(value: float) -> void:
	health = value
