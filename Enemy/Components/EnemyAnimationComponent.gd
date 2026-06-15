class_name EnemyAnimationComponent extends AnimationComponent


func play_idle() -> void:
	play_animation("idle")


func play_walk() -> void:
	play_animation("walk")


func play_attack() -> void:
	play_animation("attack")


func play_hurt() -> void:
	play_animation("hurt")


func play_death() -> void:
	play_animation("death")
