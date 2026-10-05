extends LegacyState

@export var hud: PLHUDManager

func _state_enter() -> void: 
	hud.show_ui(hud.indicators, false)
