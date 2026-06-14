class_name Player extends CharacterBody2D

@onready var player_animation: AnimationPlayer = $AnimationPlayer

##maybe should have a _ready function to initalize the components.
#this way the components dont need to be passed to each component and instead reached through player?
func _physics_process(delta: float) -> void:
	input_component.update_input()
	update_facing_direction(input_component.input_horizontal)


var direction: Vector2 = Vector2.ZERO
var move_speed: float = 200
var health: float = 100.0

func _ready() -> void:
	state_machine.init(self)


func update_animation(animation_name: String) -> void:
	player_animation.play(animation_name)
