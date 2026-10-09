extends State

func on_enter() -> void:
	Game.player_hud.visible 		= false

	Player.Instance.equipment_favourite = null
	Player.Instance.equipment_pending 	= null
	
