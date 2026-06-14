class_name State extends Node


var player: Player


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


## Code when entering the state
func Enter() -> void:
	pass

##Code when exiting the state
func Exit() -> void:
	pass
	

# 
func Process(_delta: float) -> State:
	return null

##Update character movements
func Physics(_delta : float) -> State:
	return null
	
#when input event enter this state
func handle_input(_event : InputEvent ) -> State:
	return null
