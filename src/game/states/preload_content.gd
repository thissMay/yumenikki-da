extends LegacyState

func _state_enter() -> void: 
	await Game.main_tree.process_frame
	
	SceneManager.load_scene(load(Game.PRELOAD_SHADERS_SCENE))
	print(SceneManager.curr_scene_resource)
