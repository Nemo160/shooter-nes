class_name Gun extends Node2D
@onready var shoot_timer: Timer = $shoot_timer
const BULLET = preload("res://Scenes/projectile.tscn")
@onready var muzzle: Marker2D = $Marker2D
@onready var charge_timer: Timer = $charge_timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#look_at(get_global_mouse_position())
#
	#if Input.is_action_just_pressed("attack"):
		#var bullet_instance = BULLET.instantiate()
		#get_tree().root.add_child(bullet_instance)
		#bullet_instance.global_position = muzzle.global_position
		#bullet_instance.rotation = rotation


func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())

	if Input.is_action_pressed("attack") and shoot_timer.is_stopped():
		
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation
		shoot_timer.start()
		
	elif Input.is_action_just_pressed("charge_attack") and charge_timer.is_stopped():
		var spread_angles := [-15.0, 0.0, 15.0]

		for angle in spread_angles:
			var bullet_instance = BULLET.instantiate()
			get_tree().root.add_child(bullet_instance)

			bullet_instance.global_position = muzzle.global_position
			bullet_instance.global_rotation = global_rotation + deg_to_rad(angle)
			charge_timer.start()
	
