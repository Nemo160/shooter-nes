class_name State_Falling extends State
@onready var walk: State_Walk = $"../walk"
@onready var idle: State_Idle = $"../idle"
@onready var jump: State_Jump = $"../jump"
@onready var dash: State_Dash = $"../dash"

## Code when entering the state
func Enter() -> void:
	#print("ENTERING: FALLING")
	var p := player as PlayerCharacter
	p.update_animation("Fall")



##Update character movements
func Physics(_delta : float) -> State:
	var p := player as PlayerCharacter

	if Input.is_action_just_pressed("dash") and p.dash_timer.is_stopped():
		return dash
		
	p.velocity.x = p.direction.x * p.move_speed
	p.velocity.y += p.gravity * _delta

	p.move_and_slide()

	if p.is_on_floor():
		if p.direction.x == 0:
			return idle
		else:
			return walk
		
	return null
	
