class_name SentientFSM
extends SM

var sentient: SentientBase
var animator: Node

func _setup(_sentient: Node = null, _skip_initial_state_setup: bool = false) -> void:
	if _sentient is SentientBase:
		sentient 	= _sentient
		context 	= _sentient
		
		for states in self.get_children():
			if states is SBState or states is SBNestedState:
				states.fsm = self 
				state_dict[states.name.to_lower()] = states 
				states.sentient = sentient
				states.setup()
				
		curr_state = initial_state
		if curr_state != null: curr_state.state_enter()
