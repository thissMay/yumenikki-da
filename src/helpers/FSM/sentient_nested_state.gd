class_name SBNestedState
extends NestedState

var actor: Actor2D

func _setup() -> void: 
	for states in self.get_children():
		if states is SBState or states is SBNestedState:
			states.actor = actor 
			states.fsm = fsm
			states.parent = self
			sub_states[states.name.to_lower()] = states 
			states.setup()
	_setup_sub_state()
