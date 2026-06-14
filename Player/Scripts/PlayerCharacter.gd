class_name PlayerCharacter extends Player

var cardinal_direction: Vector2 = Vector2.DOWN
var jump_velocity: float = -320.0
var gravity: float = 900.0
var descend_gravity_multiplier: float = 3.0
var dashing: bool = false
@onready var dash_timer: Timer = $dash_timer
@onready var gun: Gun = $Gun
@onready var gun_sprite: Sprite2D = $Gun/Sprite2D

func _process(_delta: float) -> void:
	direction.x = Input.get_axis("left", "right")
	direction.y = 0
	#print(dash_timer.time_left)
	#face_move_direction()
	update_facing_direction()

func face_move_direction() -> void:
	if direction.x != 0:
		sprite.flip_h = direction.x < 0
		update_facing_direction()
	
func update_animation(animation_name: String) -> void:
	#this should update all animations
	pass

func get_facing_direction() -> float:
		if sprite.flip_h:
			return -1
		else:
			return 1
			

func get_pressing_direction() -> float:
	if direction.x > 0:
		return -1
	elif direction.x < 0:
		return 1
	else:
		return 0
func update_facing_direction() -> void:
	var facing_left: bool = get_global_mouse_position().x < global_position.x
	sprite.flip_h = facing_left

	gun_sprite.scale.y = -1 if facing_left else 1
	
