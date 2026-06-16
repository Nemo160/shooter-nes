class_name Gun extends Node2D

@export var shoot_sound: AudioStream

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var shoot_timer: Timer = $shoot_timer
@onready var charge_timer: Timer = $charge_timer
@onready var muzzle: Marker2D = $Marker2D
@onready var sprite: Sprite2D = $Sprite2D

const BULLET = preload("res://Scenes/projectile.tscn")

var direction: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())

	if Input.is_action_pressed("attack") and shoot_timer.is_stopped():
		shoot()
		
	elif Input.is_action_just_pressed("charge_attack") and charge_timer.is_stopped():
		charge_shoot()


func shoot() -> void:
	var bullet_instance = BULLET.instantiate()
	get_tree().root.add_child(bullet_instance)

	bullet_instance.global_position = muzzle.global_position
	bullet_instance.global_rotation = global_rotation

	audio_player.stream = shoot_sound
	audio_player.play()

	shoot_timer.start()


func charge_shoot() -> void:
	var spread_angles := [-15.0, 0.0, 15.0]

	for angle in spread_angles:
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)

		bullet_instance.global_position = muzzle.global_position
		bullet_instance.global_rotation = global_rotation + deg_to_rad(angle)

	audio_player.stream = shoot_sound
	audio_player.play()

	charge_timer.start()
