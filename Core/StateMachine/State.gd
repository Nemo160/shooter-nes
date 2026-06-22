class_name State extends Node

signal switch_state(new_state: State)


## Called once by the StateMachine after the state enters the tree.
## Override in subclasses to receive a reference to the owning entity.
func setup(_owner_entity) -> void:
	pass


func enter_state() -> void:
	pass


func exit_state() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
