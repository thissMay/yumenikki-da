class_name GameStatePregame
extends State

func on_enter() -> void:
	Game.screen_transition.		fade(ScreenTransition.DEFAULT_GRADIENT, 1, 0)
	
	#Game.player_hud.visible 				= false
	Game.options_menu.visible 				= false
	Game.instance.inventory_menu.visible 	= false
	
	Game.instance.inventory_menu.position = Vector2.ZERO
	
	var initial_scene: PackedScene = SceneLoader.get_scene_resource()
	if initial_scene == null or Game.started: return
	if initial_scene.resource_path == Global.INITIAL_SCENE:
			SceneLoader.change_scene_to(load(Global.PRELOAD_SHADERS_SCENE), false, false)
	
	Game.started = true

func get_initial() -> State:
	
	if !SceneLoader.get_scene_resource_path() in Global.PREGAME_SCENES:
		return (parent as GameStateRoot).state_active
	return (parent as GameStateRoot).state_menu
		
	
