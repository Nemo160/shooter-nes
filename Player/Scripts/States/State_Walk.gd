class_name move_state extends State
#
#@export var idle_state: State
### Code when entering the state
#func enter_state() -> void:
	##play animation
	#pass
#
###Code when exiting the state
#func exit_state() -> void:
	#pass
	#
###process logic
#func update(_delta: float) -> void:
	#if Input.get_vector("left","right","jump","crouch") == Vector2.ZERO:
		#switch_state.emit(idle_state)
	#pass
#
###Update character movements
#func physics_update(_delta : float) -> void:
	#pass
