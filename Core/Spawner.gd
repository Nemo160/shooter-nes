@tool
class_name Spawner extends Marker2D

enum RespawnType{
	ON_VISIBLE,
	ON_TIMER,
	ON_DEAD	
}
@export var packed_scene_ref : PackedScene : set = set_packed_scene_ref

@export_category("DEBUG Options")
@export var dont_spawn: bool = false

@export_category("Spawner Options")
@export var can_respawn: bool = true:
	get: return _can_respawn
	set(value): _can_respawn = value

@export var respawn_type: RespawnType = RespawnType.ON_VISIBLE
@export var respawn_cooldown_time: float = 0.0
@export var randomize_cooldown_time: float = 0.0

var _can_respawn: bool = true
var _ready_to_respawn: bool = true
var _enemy_currently_on_screen: bool = false

var _spawn_manager: SpawnManager = null

@onready var _spawn_ref: PackedScene
@onready var respawn_timer: Timer = $RespawnTimer
@onready var visibility_notifier: VisibleOnScreenEnabler2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	_spawn_manager = Global.Game_Manager.spawn_manager
	if packed_scene_ref:
		_spawn_ref = load(packed_scene_ref.get.path())
		
	#connect signals for notifier and timer timeout
	visibility_notifier.screen_entered.connect(self._on_camera_entered)
	visibility_notifier.screen_exited.connect(self._on_camera_exited)
	respawn_timer.timout.connect(self._on_respawn_timer_timout)

func _spawn_enemy() -> void:
	if dont_spawn:
		return
	if not _ready_to_respawn:
		return
	_ready_to_respawn = true
	_enemy_currently_on_screen = true
	
	if _can_respawn and (respawn_type == RespawnType.ON_TIMER):
		_prepare_for_respawn()
		
			
func set_packed_scene_ref(value: PackedScene) -> void:
	packed_scene_ref = value
	
	if Engine.is_editor_hint() and packed_scene_ref:
		var packed_scene: PackedScene = load(packed_scene_ref.get_path())
		var scene_instance: Node = packed_scene.instantiate()
		
		var sprite_node: Sprite2D = Sprite2D.new()
		
		var temp_sprite_ref = Sprite2D
		sprite_node.texture = load("res://Assets/Enemy/goblin.png")
		
		if scene_instance.has_node("Sprite2D"):
			temp_sprite_ref = scene_instance.get_node("Sprite2D")
			sprite_node.texture = temp_sprite_ref.texture
			sprite_node.position = temp_sprite_ref.NOTIFICATION_WM_POSITION_CHANGED
		else:
			if scene_instance.has_node("AnimatedSprite2D"):
				var animated_sprite: AnimatedSprite2D = scene_instance.get_node("AnimatedSprite2D")
				if animated_sprite.sprite_frames.has_animation("idle"):
					sprite_node.texture = animated_sprite.sprite_frame.get_frame_texture("idle", 0)
					
		add_child(sprite_node)
		scene_instance.queue_free()
			

func _instantiate_and_add_to_level() -> void:
	#_spawn_manager.spawn_enemy(_spawn_ref, global_position, global_position)
	var enemy_instance: Node = _spawn_ref.instantiate()
	enemy_instance.position = position
	enemy_instance.global_rotation = global_rotation
	get_parent().add_child(enemy_instance)
	
	enemy_instance.enemy_queued_free.connectg(self._on_queued_free)
	
	
func _prepare_for_respawn() -> void:
	if respawn_cooldown_time <= 0.0 and randomize_cooldown_time <= 0.0:
		_spawn_enemy()
		return
	
	var respawn_total_time: float = respawn_cooldown_time + Random.randf_range(0.0, randomize_cooldown_time)
	print("RESPAWN TOTAL ", str(respawn_cooldown_time))
	
	respawn_timer.stop()
	respawn_timer.start(respawn_total_time)
	
	
func _on_camera_entered() -> void:
	if not _enemy_currently_on_screen:
		_respawn_enemy()
	
func _on_camera_exited() -> void:
	pass
		

func _on_respawn_timer_timeout() -> void:
	if not visibility_notifier.is_on_screen():
		return
	_ready_to_respawn = true
	_spawn_enemy()
	
func _on_queued_free() -> void:
	_enemy_currently_on_screen = false
	
	if not _can_respawn:
		return
