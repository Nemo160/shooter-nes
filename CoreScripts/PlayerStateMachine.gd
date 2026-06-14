class_name PlayerStateMachine extends Node

var states : Array[State]
var previous_state : State
var current_state : State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_state(current_state.Process(delta))
	pass
	
	#physics handler
func _physics_process(delta: float) -> void:
	change_state(current_state.Physics(delta))
	pass
	
	#input handler
func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))
	pass

	
##initalize to see each states and add 
func init(_player: Player) -> void:
	states = []
	for node in get_children():
		if node is State:
			states.append(node)
			node.player = _player
			
	if states.size() > 0:
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT

##first check if current state isnt null or the same as current
##then check if current state is initialized 
func change_state(new_state : State) -> void:
	if new_state == current_state || new_state == null:
		return
	if current_state:	
		current_state.Exit()
	previous_state = current_state
	current_state = new_state
	current_state.Enter()
