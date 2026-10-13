class_name GameStatePregame
extends State

func on_enter() -> void:
	Game.screen_transition.		fade(ScreenTransition.DEFAULT_GRADIENT, 1, 0)
	
	Game.player_hud.visible 				= false
	Game.options_menu.visible 				= false
	Game.instance.inventory_menu.visible 	= false
	
	Game.instance.inventory_menu.position = Vector2.ZERO
	
	PlayerInstance.equipment_pending 	= null
	PlayerInstance.equipment_favourite = null

func get_initial() -> State:
	if !SceneManager.curr_scene_path in Global.PREGAME_SCENES:
		return (parent as GameStateRoot).state_active
	return (parent as GameStateRoot).state_menu
		
	
