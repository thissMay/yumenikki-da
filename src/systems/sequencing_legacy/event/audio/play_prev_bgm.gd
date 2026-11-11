extends Event

func _execute() -> void:
	Music.play_music_dict(Music.prev_music)
	finished.emit()
