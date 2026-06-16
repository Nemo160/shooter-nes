class_name Goblin extends Enemy

@export var patrol_direction: float = -1.0
##health, damage, and movespeed edited with inspector tool!
#here we can place other logic perhaps...

func _ready() -> void:
	# Run Enemy._ready() first so the hitbox signals, player lookup and
	# death signal get wired up. Without this the goblin never damages the player.
	super._ready()
	audio_component.set_volume_db(sound_volume_db)

func take_damage(amount: float) -> void:
	health_component.take_damage(amount)
