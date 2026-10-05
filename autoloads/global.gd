extends Node


signal time_scale_changed		(_new: float)
signal true_time_scale_changed	(_new: float)

signal game_ready
signal scene_loaded
signal scene_unloaded


# ---- game values ----	
func get_real_delta() -> float:  return get_process_delta_time()
func get_timescale() -> float: 	 return Engine.time_scale


# -- time scaling.
func lerp_timescale(_new: float):
	var t_tween := self.create_tween() 
	t_tween.tween_method(set_timescale, Engine.time_scale, _new, 0.35)
func set_timescale(_new: float) -> void:
	Engine.time_scale = _new
	Global.wtime_scale_changed.emit(_new)
