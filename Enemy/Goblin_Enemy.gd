class_name Goblin_Enemy extends Enemy

@export_category("Nodes")
@export var healthbar: HealthBar
#health 100

#move_speed 200

func _ready() -> void:
	health = 50
	
	healthbar.init_health(health)
	pass 

func _set_health(value: float) -> void:
	super._set_health(value)
	if health <= 0 and is_alive:
		die()
	healthbar.health = health

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.x += move_speed *delta
		velocity.y += GameConstant.GRAVITY * delta
	
	velocity.x -= 1
	move_and_slide()

	pass
