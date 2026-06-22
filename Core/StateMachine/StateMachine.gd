class_name StateMachine extends Node

@onready var initial_state: State = $Idle


var active_state: State
var enemy: Enemy


func _ready() -> void:
	enemy = owner as Enemy

	for child in get_children():
		var child_state := child as State
		if child_state == null:
			continue
		
		child_state.setup(enemy)
		child_state.switch_state.connect(change_state)
	
	change_state(initial_state)


func _process(delta: float) -> void:
	if active_state:
		active_state.update(delta)


func _physics_process(delta: float) -> void:
	if active_state:
		active_state.physics_update(delta)


func change_state(new_state: State) -> void:
	if new_state == null:
		return
	
	if new_state == active_state:
		return
	
	if active_state:
		active_state.exit_state()
	
	active_state = new_state
	active_state.enter_state()
