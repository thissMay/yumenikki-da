@tool

class_name EVN_PlaySoundArr
extends Event

@export var sound_arr: Array[AudioStream] = []
@export_range(0, 2, .1) var vol: 		float = 1
@export_range(0.1 , 2, .01) var pitch: 	float = 1

# -- test
@export_tool_button("Play Test AudioBusManager") var play: Callable = play_test_audio
@export_tool_button("Stop Test AudioBusManager") var stop: Callable = stop_test_audio

func _execute() -> void:
	var sound = sound_arr.pick_random() 
	await AudioService.play_sound(sound_arr.pick_random(), vol, pitch)


func play_test_audio() -> void:	AudioService.play_sound(sound_arr.pick_random(), vol, pitch)
func stop_test_audio() -> void: AudioService.stop()
