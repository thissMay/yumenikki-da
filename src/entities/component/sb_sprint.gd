class_name SBSprint
extends SBComponent

@export var stamina_fsm: LegacyFSM


func _setup(_sb: Actor2D = null) -> void:
	super(_sb)
	stamina_fsm._setup(actor) 		# --- fsm; not player dependency but required
func _physics_update(_delta: float) -> void: 
	stamina_fsm._physics_update(_delta)
	
