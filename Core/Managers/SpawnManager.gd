class_name SpawnManager extends Node

## Node2D that spawned enemies are parented to.
## If left unset, it falls back to the current scene root on first use,
## so spawning works out of the box. Call set_entity_layer() to target a
## dedicated container (e.g. an "Entities" Node2D) instead.
var _entity_layer: Node2D = null

func set_entity_layer(layer: Node2D) -> void:
	_entity_layer = layer

func spawn_enemy(enemy_scene: PackedScene, spawn_transform: Transform2D) -> Enemy:
	var layer: Node2D = _resolve_entity_layer()
	if layer == null:
		push_warning("SpawnManager: no entity layer to spawn into (scene root is not a Node2D).")
		return null

	if enemy_scene == null:
		push_warning("SpawnManager: spawn_enemy called with a null enemy_scene.")
		return null

	var enemy: Enemy = enemy_scene.instantiate() as Enemy
	if enemy == null:
		push_warning("SpawnManager: enemy_scene root is not an Enemy, cannot spawn.")
		return null

	layer.add_child(enemy)
	enemy.global_transform = spawn_transform

	return enemy

func _resolve_entity_layer() -> Node2D:
	if _entity_layer != null and is_instance_valid(_entity_layer):
		return _entity_layer

	# Fallback: parent enemies under the current scene root if it's a 2D node.
	var scene_root: Node = get_tree().current_scene
	if scene_root is Node2D:
		_entity_layer = scene_root
		return _entity_layer

	return null
