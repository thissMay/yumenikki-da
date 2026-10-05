@tool

class_name EVN_PlayBGM
extends Event

enum MUSIC_BUS {MUSIC, AMBIENCE}
@export var stream: AudioStream
@export var music_bus: MUSIC_BUS

@export_group("Volume and Pitch")
@export_range(0, 1, .1) var vol: float = 1
@export_range(0.1 , 2, .01) var pitch: float = 1
@export var abrupt: bool = false

# -- tests
@export_group("Test AudioBusManager")
@export_tool_button("Play Test AudioBusManager") var play: Callable = play_test_audio
@export_tool_button("Stop Test AudioBusManager") var stop: Callable = stop_test_audio

func _execute() -> void:	
	match music_bus:
		MUSIC_BUS.MUSIC: 	Game.aud_music.		play_sound(stream, linear_to_db(vol), pitch)
		MUSIC_BUS.AMBIENCE: Game.aud_amb.	play_sound(stream, linear_to_db(vol), pitch) 

func play_test_audio() -> void:	AudioService.play_test_audio_from("BGM", stream, vol, pitch)
func stop_test_audio() -> void: AudioService.stop()
