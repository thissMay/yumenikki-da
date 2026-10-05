extends LegacyState

@export var hud: PLHUDManager

func _state_enter() -> void: 
	hud.show_ui(hud.indicators, true)
func _state_exit() -> void: 
	hud.show_ui(hud.indicators, false)
	
func _state_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_hud_toggle"): hud.show_ui(hud.indicators, !hud.indicators.visible)
	if Input.is_action_just_pressed("pl_inventory"):  EventManager.invoke_event("SPECIAL_INVERT_START_REQUEST")
