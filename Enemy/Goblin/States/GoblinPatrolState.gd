class_name GoblinPatrolState extends EnemyState

@export var chase_state: State

var direction: float = -1.0


func enter_state() -> void:
	enemy.animation_component.play_walk()

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	enemy.gravity_component.handle_gravity(enemy, delta)

	enemy.movement_component.handle_horizontal_movement(enemy, direction)
	enemy.animation_component.handle_horizontal_flip(direction)

	enemy.move_and_slide()

	if enemy.is_on_wall():
		direction *= -1.0

	if enemy.can_see_player():
		switch_state.emit(chase_state)

func exit_state() -> void:
	pass
