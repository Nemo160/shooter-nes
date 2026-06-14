class_name State_Attack extends State
@onready var walk: State_Walk = $"../walk"
@onready var idle: State_Idle = $"../idle"
@onready var jump: State_Jump = $"../jump"
@onready var fall: State_Falling = $"../fall"

## Code when entering the state
func Enter() -> void:
	#printerr("ENTERING: Attack")
	var p := player as PlayerCharacter



##Update character movements
func Physics(_delta : float) -> State:
	var p := player as PlayerCharacter
	
	return null
	
