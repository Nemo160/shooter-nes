class_name State_Dash extends State
@onready var fall: State_Falling = $"../fall"
@onready var walk: State_Walk = $"../walk"
@onready var jump: State_Jump = $"../jump"
@onready var idle: State_Idle = $"../idle"


var dash_timer: float = 0.0
var dash_direction: float = 1.0
var dash_cooldown: float = 2.0

var dash_speed: float = 500.0
var dash_duration: float = 0.0

func Enter() -> void:
	var p := player as PlayerCharacter
	dash_duration = 0.18

	p.dash_timer.start()
	p.dashing = true
	
	#dash towrads key input, otherwise dash towrad facing direction
	if p.direction.x != 0:
		dash_direction = sign(p.direction.x)
	else:
		dash_direction = p.get_facing_direction()
		
	p.velocity.y = 0
	p.update_animation("dash")


func Physics(delta: float) -> State:
	var p := player as PlayerCharacter

	dash_duration -= delta
	
	p.velocity.x = dash_direction * dash_speed
	p.velocity.y = 0
	p.move_and_slide()
	
	if dash_duration > 0:
		return null
		
	if not p.is_on_floor():
		return fall
	if p.direction.x != 0:
		return walk
	return idle
func Exit() -> void:
	var p := player as PlayerCharacter
	p.dashing = false

	
