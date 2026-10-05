extends LegacyState

func _state_enter() -> void: 
	Game.player_hud.visible 		= false
	
	Player.Instance.equipment_favourite = null
	Player.Instance.equipment_pending 	= null
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _state_exit() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
