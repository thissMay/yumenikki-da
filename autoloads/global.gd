extends Node

signal paused
signal resumed

# -- 

var delta: float:
	get: return get_process_delta_time()
var phys_delta: float:
	get: return get_physics_process_delta_time()

# ---- game values ----	

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

# scene parent directory
const SCENE_MAP_DIR := "res://src/map/"
const SCENE_DIR	 	:= "res://src/scenes/"

# - scene paths
const INITIAL_SCENE 		:= SCENE_DIR + "initial_scene.tscn" 		# - 0
const PRELOAD_SHADERS_SCENE := SCENE_DIR + "debug_preload.tscn" 		# - 1
const PREMENU_SCENE			:= SCENE_DIR + "pre_menu.tscn"				# - 2
const MENU_SCENE 			:= SCENE_DIR + "menu/menu.tscn"	# - 3
const PREGAME_SCENES 		:= [INITIAL_SCENE, MENU_SCENE, PREMENU_SCENE]
#endregion
