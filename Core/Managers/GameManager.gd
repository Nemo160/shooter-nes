class_name GameManager extends Node

@onready var spawn_manager: SpawnManager = $SpawnManager

func _ready() -> void:
	Global.game_manager = self
