class_name EVN_StopBGM
extends Event

enum MUSIC_BUS {MUSIC, AMBIENCE, BOTH}
@export var music_bus: MUSIC_BUS

func _init(_bus: MUSIC_BUS = MUSIC_BUS.MUSIC) -> void:
	music_bus = _bus

func _execute() -> void:
	match music_bus:
		MUSIC_BUS.MUSIC: 	Music.		stop()
		MUSIC_BUS.AMBIENCE: Ambience.	stop()
		_:
			Music.		stop()
			Ambience.	stop()
