class_name Player extends CharacterBody2D
@export_category("Components")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var jump_component: JumpComponent
@export var dash_component: PlayerDashComponent

@export_category("Player Settings")
@export var health: float = 200
@export var move_speed: float = 115

var facing_direction: float = 1.0


func _physics_process(delta: float) -> void:
	input_component.update_input()
	update_facing_direction(input_component.input_horizontal)

	
	gravity_component.handle_gravity(self, delta, input_component.holding_down)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
	jump_component.handle_jump(self, input_component.jump_pressed)
	dash_component.handle_dash(self, input_component.dash_pressed, delta)

	move_and_slide()
	animation_component.update_animation(self, input_component.input_horizontal)
	#DebugLayer.update_player(self, true, jump_component.has_air_jumped)


func update_facing_direction(input_horizontal: float) -> void:
	if input_horizontal != 0:
		facing_direction = sign(input_horizontal)
