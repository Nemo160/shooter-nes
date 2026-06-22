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

# Editor preview of the assigned enemy (drawn at this spawner while editing).
const PREVIEW_MODULATE := Color(1.0, 1.0, 1.0, 0.5)
var _preview_texture: Texture2D = null
var _preview_region: Rect2 = Rect2()
var _preview_offset: Vector2 = Vector2.ZERO
var _preview_centered: bool = true

@onready var respawn_timer: Timer = $RespawnTimer
@onready var visibility_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	if Engine.is_editor_hint():
		_update_preview()
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

	_update_preview()


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


##THIS PART WAS ADDED USING AI. Just a useful tool while creating the game
# --- Editor preview -------------------------------------------------------
# Caches the assigned enemy's sprite (first frame) so _draw() can show it in
# the editor. Runs only in the editor; at runtime the real enemy is spawned.

func _update_preview() -> void:
	_preview_texture = null

	if enemy_scene != null:
		# Instantiate without adding to the tree: no _ready/_process runs, so
		# this is a cheap, side-effect-free way to read the enemy's sprite.
		var instance: Node = enemy_scene.instantiate()
		var sprite: Sprite2D = _find_sprite(instance)

		if sprite != null and sprite.texture != null:
			_preview_texture = sprite.texture
			_preview_region = _frame_region(sprite)
			_preview_offset = sprite.offset
			_preview_centered = sprite.centered

		instance.free()

	queue_redraw()


func _find_sprite(node: Node) -> Sprite2D:
	if node is Sprite2D:
		return node as Sprite2D

	for child in node.get_children():
		var found: Sprite2D = _find_sprite(child)
		if found != null:
			return found

	return null


func _frame_region(sprite: Sprite2D) -> Rect2:
	if sprite.region_enabled:
		return sprite.region_rect

	var texture_size: Vector2 = sprite.texture.get_size()
	var columns: int = maxi(sprite.hframes, 1)
	var rows: int = maxi(sprite.vframes, 1)
	var cell: Vector2 = Vector2(texture_size.x / columns, texture_size.y / rows)

	return Rect2(Vector2(sprite.frame_coords) * cell, cell)


func _draw() -> void:
	if not Engine.is_editor_hint() or _preview_texture == null:
		return

	var top_left: Vector2 = _preview_offset
	if _preview_centered:
		top_left -= _preview_region.size * 0.5

	draw_texture_rect_region(
		_preview_texture,
		Rect2(top_left, _preview_region.size),
		_preview_region,
		PREVIEW_MODULATE
	)
