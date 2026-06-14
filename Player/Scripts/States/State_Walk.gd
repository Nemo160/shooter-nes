class_name State_Walk extends State
@onready var jump: State_Jump = $"../jump"
@onready var idle: State_Idle = $"../idle"
@onready var falling: State_Falling = $"../fall"
@onready var dash: State_Dash = $"../dash"


## Code when entering the state
func Enter() -> void:
	var p := player as PlayerCharacter
	#printerr("ENTERING: WALK")

	
	
##Update character movements
func Physics(_delta : float) -> State:

	var p := player as PlayerCharacter
	
	if not p.is_on_floor():
		return falling
		
	if Input.is_action_just_pressed("jump"):
		return jump
		
	if Input.is_action_just_pressed("dash") and p.dash_timer.is_stopped():
		return dash
		
	if p.direction.x == 0:
		return idle
		
	p.velocity.x = p.direction.x * p.move_speed
	p.move_and_slide()
	return null

func Exit() -> void:
	pass	


func Process(_delta: float) -> State:
	return null

#when input event enter this state
func handle_input(_event : InputEvent ) -> State:
	return null
