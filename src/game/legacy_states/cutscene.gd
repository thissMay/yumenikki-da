extends LegacyState

@export var dream_fsm: LegacyFSM

func _state_enter() -> void: 
	EventManager.invoke_event("CUTSCENE_START")
	Game.set_cinematic_bars(true)

func _state_exit() -> void: 
	EventManager.invoke_event("CUTSCENE_END")
	Game.set_cinematic_bars(false)
