class_name Enemy extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
var health:float
var move_speed: float = 200
var direction: Vector2 = Vector2.ZERO
var gravity: float = GameConstant.GRAVITY
var damage: float = 25
#standard damage of 25 

func _ready() -> void:
	direction.y = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func take_damage(damage: float) -> void:
	health -= damage
	
func die() -> void:
	queue_free()
	
