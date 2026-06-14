class_name Goblin_Enemy extends Enemy

#health 100
#move_speed 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 300
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.x = direction.x * move_speed
		velocity.y += GameConstant.GRAVITY * delta
	
	velocity.x -= 1
	move_and_slide()
	print("X: ", position.x)
	print("y: ", position.y)
	pass
