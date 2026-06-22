class_name GoblinChaseState extends EnemyState

@export var patrol_state: State


func enter_state() -> void:
	enemy.animation_component.play_walk()


func physics_update(delta: float) -> void:
	enemy.gravity_component.handle_gravity(enemy, delta)

	if enemy.player == null or not is_instance_valid(enemy.player):
		enemy.move_and_slide()
		switch_state.emit(patrol_state)
		return

	var direction := signf(enemy.player.global_position.x - enemy.global_position.x)
	enemy.movement_component.handle_horizontal_movement(enemy, direction)
	enemy.animation_component.handle_horizontal_flip(direction)
	enemy.move_and_slide()

	# Lost sight of the player: drop back to patrolling.
	if not enemy.can_see_player():
		switch_state.emit(patrol_state)
