class_name State_Jump extends State
@onready var walk: State_Walk = $"../walk"
@onready var idle: State_Idle = $"../idle"
@onready var falling: State_Falling = $"../fall"
@onready var dash: State_Dash = $"../dash"


const jump_velocity: float = -320.0
const MAX_JUMP_VELOCITY: float = -420.0
const JUMP_CUT: float = 0.5
const JUMP_HOLD_GRAVITY_MULTIPLIER: float = 0.55
func Enter() -> void:
	var p := player as PlayerCharacter
	p.velocity.y = jump_velocity
	p.update_animation("jump")


func Physics(delta: float) -> State:
	var p := player as PlayerCharacter

	var direction := Input.get_axis("left", "right")

	p.velocity.x = direction * p.move_speed

	#short jump
	if Input.is_action_just_pressed("dash") and p.dash_timer.is_stopped():
		return dash
		
	if Input.is_action_just_released("jump") and p.velocity.y < 0:
		p.velocity.y *= JUMP_CUT

	if p.velocity.y < 0 and Input.is_action_pressed("jump"):
		#weaker gravity for long jump
		p.velocity.y += p.gravity * JUMP_HOLD_GRAVITY_MULTIPLIER * delta
	else:
		#normal gravity
		p.velocity.y += p.gravity * delta

	p.move_and_slide()

	if p.velocity.y > 0:
		return falling

	if p.is_on_floor():
		if direction != 0:
			return walk
		return idle

	return null

	
