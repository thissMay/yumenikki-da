extends LegacyState

@export var dream_fsm: SM

func _state_enter() -> void: 
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	EventManager.invoke_event("CUTSCENE_START")
	Game.set_cinematic_bars(true)

func _state_exit() -> void: 
	EventManager.invoke_event("CUTSCENE_END")
	Game.set_cinematic_bars(false)
