extends Node


signal time_scale_changed		(_new: float)
signal true_time_scale_changed	(_new: float)

signal game_ready
signal scene_loaded
signal scene_unloaded


# ---- game values ----	
func get_delta() -> float:  return get_process_delta_time()
func get_timescale() -> float: 	 return Engine.time_scale


# -- time scaling.
func lerp_timescale(_new: float):
	var t_tween := self.create_tween() 
	t_tween.tween_method(set_timescale, Engine.time_scale, _new, 0.35)
func set_timescale(_new: float) -> void:
	Engine.time_scale = _new
	Global.wtime_scale_changed.emit(_new)

#region Constants
const DIR 			:= "user://game"
const SAVE_DIR 		:= DIR + "/save"
const CONFIG_PATH 	:= DIR + "/settings.cfg"

# - scene paths
const INITIAL_SCENE 		:= "res://src/scenes/initial_scene.tscn" 		# - 0
const PRELOAD_SHADERS_SCENE := "res://src/scenes/debug_preload.tscn" 		# - 1
const PREMENU_SCENE			:= "res://src/scenes/pre_menu.tscn"				# - 2
const MENU_SCENE 			:= "res://src/levels/_neutral/menu/menu.tscn"	# - 3
const PREGAME_SCENES 		:= [INITIAL_SCENE, MENU_SCENE, PREMENU_SCENE]
#endregion
