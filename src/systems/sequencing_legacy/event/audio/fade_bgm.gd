class_name EVN_FadeBGM
extends Event

enum FADE {IN, OUT}

@export var music_bus: BGMPlayer.BUS
@export var fade_type: FADE 

func _init(_bgm_bus: BGMPlayer.BUS = BGMPlayer.BUS.MUSIC, _fade: FADE = FADE.IN) -> void:
	music_bus = _bgm_bus
	fade_type = _fade

func _execute() -> void:
	match fade_type:
		FADE.IN:
			match music_bus:
				BGMPlayer.BUS.MUSIC: 	Music.		fade_in()
				BGMPlayer.BUS.AMBIENCE: Ambience.	fade_in()
				_:					__fade_in_both()
		FADE.OUT:
			match music_bus:
				BGMPlayer.BUS.MUSIC: 	Music.		fade_out()
				BGMPlayer.BUS.AMBIENCE: Ambience.	fade_out()
				_:					__fade_out_both()

func __fade_in_both() -> void:
	Music.		fade_in()
	Ambience.	fade_in()
func __fade_out_both() -> void:
	Music.		fade_out()
	Ambience.	fade_out()
