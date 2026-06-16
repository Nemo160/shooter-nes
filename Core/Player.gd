class_name Player extends CharacterBody2D
@export_subgroup("Components")
@export var health_component: HealthComponent
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var jump_component: JumpComponent
@export var dash_component: PlayerDashComponent

@export_subgroup("Bars")
@export var dash_bar: ProgressBar
@export_subgroup("Settings")
@export var damage_cooldown_timer: Timer

var facing_direction: float = 1.0

func _ready() -> void:
	health_component.died.connect(_on_died)
	damage_cooldown_timer.one_shot = true
	
	dash_bar.min_value = 0.0
	dash_bar.max_value = 1.0
	dash_bar.step = 0.0
	dash_bar.visible = false

func take_damage(amount: float) -> void:
	if not damage_cooldown_timer.is_stopped():
		return

	health_component.take_damage(amount)
	damage_cooldown_timer.start()
	
func _on_died() -> void:
	print("PLAYER HAS DIED")
	# death animation, respawn, game over screen, etc.
	pass

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
