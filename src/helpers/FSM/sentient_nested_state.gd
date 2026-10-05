class_name SBNestedState
extends NestedState

var sentient: SentientBase

func _setup() -> void: 
	for states in self.get_children():
		if states is SBState or states is SBNestedState:
			states.sentient = sentient 
			states.fsm = fsm
			states.parent = self
			sub_states[states.name.to_lower()] = states 
			states.setup()
	_setup_sub_state()
