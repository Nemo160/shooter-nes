class_name State_Idle extends State
@onready var walk: State_Walk = $"../walk"
@onready var jump: State_Jump = $"../jump"
@onready var falling: State_Falling = $"../fall"
@onready var dash: State_Dash = $"../dash"



## Code when entering the state
func Enter() -> void:
	var p := player as PlayerCharacter
	p.velocity.x = 0
	#printerr("ENTERING: IDLE")
	p.update_animation("Idle")

	
	
##Update character movements
func Physics(_delta : float) -> State:
	
	var p := player as PlayerCharacter
	
	if Input.is_action_just_pressed("jump"):
		return jump
		
	if Input.is_action_just_pressed("dash") and p.dash_timer.is_stopped():
		return dash
		
	if p.direction.x != 0:
		return walk
		
	p.velocity.x = 0
	p.move_and_slide()

	return null
	

	
