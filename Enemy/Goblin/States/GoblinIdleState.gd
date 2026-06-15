class_name GoblinIdleState
extends EnemyState

@export var patrol_state: EnemyState
@export var chase_state: EnemyState


func enter_state() -> void:
	enemy.velocity.x = 0
	enemy.animation_component.play_idle()


func physics_update(delta: float) -> void:
	enemy.gravity_component.handle_gravity(enemy, delta)
	enemy.move_and_slide()

	if enemy.can_see_player():
		switch_state.emit(chase_state)
		return
