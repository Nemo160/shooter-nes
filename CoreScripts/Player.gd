class_name Player extends CharacterBody2D
@export_category("Components")
@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var jump_component: JumpComponent
@export var dash_component: DashComponent
@export_subgroup("Bars")
@export var dash_cooldown_bar: ProgressBar
var facing_direction: float = 1.0

func _ready() -> void:
	dash_cooldown_bar.min_value = 0.0
	dash_cooldown_bar.max_value = 1.0
	dash_cooldown_bar.step = 0.0
	dash_cooldown_bar.visible = false

func _physics_process(delta: float) -> void:
	input_component.update_input()
	update_facing_direction(input_component.input_horizontal)

	
	gravity_component.handle_gravity(self, delta, input_component.holding_down)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
	jump_component.handle_jump(self, input_component.jump_pressed)
	dash_component.handle_dash(self, input_component.dash_pressed, delta)

	move_and_slide()
	animation_component.update_animation(self, input_component.input_horizontal)
	update_dash_cooldown_bar()

func update_dash_cooldown_bar() -> void:
	var progress := dash_component.get_cooldown_progress()
	dash_cooldown_bar.value = progress
	dash_cooldown_bar.visible = progress < 1.0
	
func update_facing_direction(input_horizontal: float) -> void:
	if input_horizontal != 0:
		facing_direction = sign(input_horizontal)
