@tool
class_name Spawner
extends Marker2D


enum RespawnType {
	ON_VISIBLE,
	ON_TIMER,
	ON_DEAD
}


@export var enemy_scene: PackedScene : set = set_enemy_scene

@export_category("DEBUG Options")
@export var dont_spawn: bool = false

@export_category("Spawner Options")
@export var can_respawn: bool = true
@export var respawn_type: RespawnType = RespawnType.ON_VISIBLE
@export var respawn_cooldown_time: float = 0.0
@export var randomize_cooldown_time: float = 0.0


var _spawn_manager: SpawnManager = null
var _current_enemy: Enemy = null
var _ready_to_respawn: bool = true
var _is_on_screen: bool = false

@onready var respawn_timer: Timer = $RespawnTimer
@onready var visibility_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	_spawn_manager = Global.game_manager.spawn_manager

	visibility_notifier.screen_entered.connect(_on_camera_entered)
	visibility_notifier.screen_exited.connect(_on_camera_exited)
	respawn_timer.timeout.connect(_on_respawn_timer_timeout)

	if visibility_notifier.is_on_screen():
		_is_on_screen = true
		_try_spawn()


func set_enemy_scene(value: PackedScene) -> void:
	enemy_scene = value

	if not Engine.is_editor_hint():
		return

	#add editor preview logic here. LATER.


func _try_spawn() -> bool:
	if dont_spawn:
		return false

	if not _ready_to_respawn:
		return false

	if enemy_scene == null:
		push_warning("Spawner has no enemy_scene assigned.")
		return false

	if _spawn_manager == null:
		push_warning("Spawner has no SpawnManager reference.")
		return false

	if _current_enemy != null and is_instance_valid(_current_enemy):
		return false

	var enemy_instance: Enemy = _spawn_manager.spawn_enemy(enemy_scene, global_transform)

	if enemy_instance == null:
		push_warning("SpawnManager failed to spawn enemy.")
		return false

	_current_enemy = enemy_instance
	_ready_to_respawn = false

	# tree_exited fires whenever the enemy leaves the scene (e.g. queue_free on death).
	enemy_instance.tree_exited.connect(_on_enemy_left_scene)

	return true


func _prepare_for_respawn() -> void:
	if not can_respawn:
		return

	var respawn_total_time: float = respawn_cooldown_time + randf_range(0.0, randomize_cooldown_time)

	if respawn_total_time <= 0.0:
		_ready_to_respawn = true
		_try_spawn()
		return

	_ready_to_respawn = false
	respawn_timer.stop()
	respawn_timer.start(respawn_total_time)


func _on_camera_entered() -> void:
	_is_on_screen = true

	match respawn_type:
		RespawnType.ON_VISIBLE:
			_ready_to_respawn = true
			_try_spawn()

		RespawnType.ON_TIMER:
			if _ready_to_respawn:
				_try_spawn()

		RespawnType.ON_DEAD:
			if _ready_to_respawn:
				_try_spawn()


func _on_camera_exited() -> void:
	_is_on_screen = false


func _on_respawn_timer_timeout() -> void:
	_ready_to_respawn = true

	match respawn_type:
		RespawnType.ON_TIMER:
			if _is_on_screen:
				_try_spawn()

		RespawnType.ON_DEAD:
			_try_spawn()

		RespawnType.ON_VISIBLE:
			if _is_on_screen:
				_try_spawn()


func _on_enemy_left_scene() -> void:
	_current_enemy = null

	if not can_respawn:
		return

	match respawn_type:
		RespawnType.ON_VISIBLE:
			_ready_to_respawn = true

		RespawnType.ON_TIMER:
			_prepare_for_respawn()

		RespawnType.ON_DEAD:
			_prepare_for_respawn()
