@tool
extends Event

enum state {DREAM, NEUTRAL}
@export var world_state: state

func _execute() -> void: 
	match world_state:
		state.DREAM: 	EventManager.invoke_event("OVERRIDE_TO_DREAM_STATE") 
		state.NEUTRAL: 	EventManager.invoke_event("OVERRIDE_TO_NEUTRAL_STATE") 
