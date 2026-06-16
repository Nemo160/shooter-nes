class_name HealthBar extends ProgressBar

## World-space offset from the entity's origin. The bar is centred horizontally
## on the entity and shifted by this amount (negative Y = above the entity).
@export var follow_offset: Vector2 = Vector2(0, -28)

@onready var health_component: HealthComponent = get_parent() as HealthComponent
@onready var damage_bar: ProgressBar = $DamageBar
@onready var timer: Timer = $Timer

# The CharacterBody2D (Player/Enemy) that owns this health component.
var entity: Node2D
var current_health: float = 0.0

func _ready() -> void:
	# The HealthComponent is a plain Node, which breaks the 2D transform chain,
	# so the bar would otherwise anchor to the viewport. Instead we detach from
	# the parent transform (top_level) and follow the entity in world space.
	entity = health_component.get_parent() as Node2D
	top_level = true

	health_component.health_changed.connect(_on_health_changed)
	health_component.died.connect(_on_died)
	init_health(health_component.health, health_component.max_health)

func _process(_delta: float) -> void:
	if not is_instance_valid(entity):
		return
	global_position = entity.global_position - Vector2(size.x * 0.5, 0.0) + follow_offset

func init_health(health: float, max_health: float) -> void:
	current_health = health
	max_value = max_health
	value = current_health
	damage_bar.max_value = max_health
	damage_bar.value = current_health

func _on_health_changed(new_health: float, max_health: float) -> void:
	var prev_health := current_health
	current_health = min(max_value, new_health)
	value = current_health

	if current_health < prev_health:
		timer.start()
	else:
		damage_bar.value = current_health

func _on_died() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	damage_bar.value = current_health
