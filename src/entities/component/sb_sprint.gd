class_name SBSprint
extends SBComponent

@export var stamina_fsm: FSM


func _setup(_sb: SentientBase = null) -> void:
	super(_sb)
	stamina_fsm._setup(sentient) 		# --- fsm; not player dependency but required
func _physics_update(_delta: float) -> void: 
	stamina_fsm._physics_update(_delta)
	
