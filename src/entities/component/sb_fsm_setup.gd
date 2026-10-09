extends SBComponent
@export var sentient_fsm: SentientFSM

func _setup(_sentient: Actor2D = null) -> void: 
	super(_sentient)
	if sentient_fsm != null: sentient_fsm._setup(_sentient)
