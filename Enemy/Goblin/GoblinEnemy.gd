class_name Goblin extends Enemy
@export var hurt_sound: AudioStream

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
func _ready() -> void:
	audio_player.stream = hurt_sound

func take_damage(amount: float) -> void:
	health_component.take_damage(amount)
	audio_player.play()
@export var patrol_direction: float = -1.0
##heatlh, damage, and movespeed edited with inspector tool! 
#here we can place other logic perhaps...
