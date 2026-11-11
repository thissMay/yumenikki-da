extends PLAction
@export var sound: AudioStream

func _perform(_pl: Player) -> void: 
	AudioService.play_sound(sound)
