@tool

class_name EVN_PlaySound
extends Event

@export var sound: AudioStream = null
@export_range(0, 2, .1) var vol: 		float = 1
@export_range(0.1 , 2, .01) var pitch: 	float = 1

# -- test
@export_tool_button("Play Test AudioBusManager") var play: Callable = play_test_audio
@export_tool_button("Stop Test AudioBusManager") var stop: Callable = stop_test_audio


func _execute() -> void:
	await AudioService.play_sound(sound, vol, pitch)

func _validate() -> bool:
	if sound == null: 
		printerr("EVENT - PLAYSOUND :: Sound is null!")
		return false
	return true


func play_test_audio() -> void:	AudioService.play_sound(sound, vol, pitch)
func stop_test_audio() -> void: AudioService.stop()
