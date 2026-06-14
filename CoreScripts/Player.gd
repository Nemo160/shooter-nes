class_name Player extends CharacterBody2D

@onready var player_animation: AnimationPlayer = $AnimationPlayer

@onready var sprite: Sprite2D = $PlayerSprite
@onready var state_machine: PlayerStateMachine = $StateMachine


var direction: Vector2 = Vector2.ZERO
var move_speed: float = 200
var health: float = 100.0

func _ready() -> void:
	state_machine.init(self)


func update_animation(animation_name: String) -> void:
	player_animation.play(animation_name)
